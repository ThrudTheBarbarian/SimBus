//
//  SBEngine.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBEngine.h"
#import "SBEvent.h"
#import "SBNotifications.h"
#import "SBOperation.h"
#import "SBPluginController.h"
#import "SBPluginProtocol.h"
#import "SBSignal.h"
#import "SBValues.h"

NSString * _Nonnull const kAutomaticInstantiation   = @"automatic-instantiation";


@interface SBEngine()
// Whether this engine has ever been run
@property(assign, nonatomic) BOOL                               hasRun;

// Whether this engine is currently running
@property(strong, nonatomic) SBOperation *                      currentOp;

// An operation queue to run the simulation on
@property(strong, nonatomic) NSOperationQueue *                 bgQ;

// Map of name to signal objects
@property(strong, nonatomic)
NSMutableDictionary<NSString *, SBSignal *> *                   signalMap;

// Map of signal.identifier to plugins listening for async events
@property(strong, nonatomic)
NSMutableDictionary<NSNumber *, NSMutableSet<id<SBPlugin>> *> * asyncMap;


// Direct methods
- (BOOL) _checkTermOnceFor:(SBEvent *)event
          __attribute__((objc_direct));
- (BOOL) _checkTermWhenFor:(SBEvent *)event
          __attribute__((objc_direct));
- (BOOL) _checkTermAfterFor:(SBEvent *)event during:(SBOperation *)op
         __attribute__((objc_direct));
@end

@implementation SBEngine

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _plugins    = [NSMutableArray new];
        _hasRun     = NO;
        _currentOp  = nil;
        _bgQ        = [NSOperationQueue new];
        _signalMap  = [NSMutableDictionary new];
        _asyncMap   = [NSMutableDictionary new];
        
        // Must match whats in the dialog
        _termMode        = TermAfter;
        _termAfterUnit   = UnitClocks;
        _termAfterCount  = 30;
        
        NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
        [nc addObserver:self
               selector:@selector(_clockParametersChanged:)
                   name:kClockChangedNotification
                 object:nil];
        }
    return self;
    }
    
/*****************************************************************************\
|* Create the shared instance of the engine
\*****************************************************************************/
+ (instancetype) sharedInstance
    {
    static SBEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
        ^{
        engine = [SBEngine new];
        });
    return engine;
    }

/*****************************************************************************\
|* Request creation of a signal - if the name already exists, the existing
|* object will be returned. This will return nil if a signal of the same
|* name already exists, but has different parameters
\*****************************************************************************/
- (nullable SBSignal *) makeSignalWithName:(NSString *)name
                                   ofWidth:(int)width
                                      type:(SignalType)type
    {
    // Check to see if it already exists
    SBSignal *signal = _signalMap[name];
    if (signal != nil)
        {
        if ((signal.width == width) && (signal.type == type))
            return signal;
        return nil;
        }
    
    // It doesn't, so make it
    signal = [SBSignal withName:name width:width type:type];
    _signalMap[name] = signal;
    return signal;
    }
    
/*****************************************************************************\
|* Add a plugin to the engine
\*****************************************************************************/
- (void) addPlugin:(id<SBPlugin>)plugin
    {
    [self addPlugin:plugin autoAdd:NO];
    }
    
- (void) addPlugin:(id<SBPlugin>)plugin autoAdd:(BOOL)autoAdd
    {
    [_plugins addObject:plugin];
    [plugin setEngine:self];
    
    // This is true when we auto-add signals at the start of the app
    if (autoAdd)
        {
        for (SBSignal *signal in plugin.signals)
            if (signal.type == SIGNAL_CLOCK_SRC)
                {
                _triggerOnceSignal  = signal;
                _triggerWhenSignal  = signal;
                _termOnceSignal     = signal;
                _termWhenSignal     = signal;
                break;
                }
        }
    }

/*****************************************************************************\
|* Return a list of signals
\*****************************************************************************/
- (NSArray<SBSignal *> *) signals
    {
    return [_signalMap.allValues sortedArrayUsingComparator:
            ^NSComparisonResult(SBSignal *s1, SBSignal *s2)
                {
                return [s1.name compare:s2.name];
                }];
    }
    
/*****************************************************************************\
|* Find the signal for a given name by iterating through the list
\*****************************************************************************/
- (nullable SBSignal *) signalForName:(NSString *)name
    {
    for (id<SBPlugin> plugin in _plugins)
        for (SBSignal *signal in plugin.signals)
            if ([name isEqualToString:signal.name])
                return signal;
    return nil;
    }
    
/*****************************************************************************\
|* Find the signal for a given name by iterating through the list
\*****************************************************************************/
- (nullable SBSignal *) signalForType:(SignalType)type
    {
    for (id<SBPlugin> plugin in _plugins)
        for (SBSignal *signal in plugin.signals)
            if (type == signal.type)
                return signal;
    return nil;
    }

#pragma  mark - run-time


/*****************************************************************************\
|* Reset the engine for a new run
\*****************************************************************************/
- (void) reset
    {
    for (SBSignal *signal in _signalMap.allValues)
        {
        [signal.values clear];
        signal.hiCount      = 0;
        signal.loCount      = 0;
        signal.changeCount  = 0;
        }
    [_asyncMap removeAllObjects];
    }

/*****************************************************************************\
|* Run the engine until we hit the termination condition, or pause is pressed
\*****************************************************************************/
- (void) run
    {
    // Do an implicit reset if we've never run before
    if (!_hasRun)
        {
        [self reset];
        _hasRun = YES;
        }
    
    _currentOp          = [SBOperation new];
    _currentOp.engine   = self;
    [_bgQ addOperation:_currentOp];
    }

#pragma mark - Event processing

/*****************************************************************************\
|* Allow registration of asynchronous events on a per-plugin basis
\*****************************************************************************/
- (void) addAsynchronousListenerFor:(SBEvent *)event
    {
    for (SBSignal *signal in event.signals)
        {
        NSMutableSet<id<SBPlugin>> *set = _asyncMap[signal.identifier];
        if (set == nil)
            {
            set = NSMutableSet.new;
            _asyncMap[signal.identifier] = set;
            }
        [set addObject:event.plugin];
        }
    }


/*****************************************************************************\
|* Handle asynchronous signal change events. These aren't based purely on time
\*****************************************************************************/
- (void) signal:(SBSignal *)signal changedFrom:(int64_t)oldValue
    {
    NSMutableSet *plugins   = _asyncMap[signal.identifier];
    if (plugins)
        for (id<SBPlugin> plugin in plugins)
            {
            SBEvent *event  = [SBEvent withAbsoluteTime:_currentOp.cron];
            event.plugin    = plugin;
            event.signal    = signal;
            event.tag       = TAG_ASYNCHRONOUS;
            event.lastValue = oldValue;
            
            BOOL persist    = SBEngine.sharedInstance.inSimulation;
            [plugin process:event withSignals:@[] persist:persist];
            }
    }


/*****************************************************************************\
|* Return the next event after a specified one, where nil indicates the first
|* returns nil if not found
\*****************************************************************************/
- (nullable SBEvent *) eventFollowing:(nullable SBEvent *)event
    {
    SBEvent *result     = nil;
    NSInteger numEvents = _currentEvents.count;
    NSInteger idx       = 0;
    
    if (event == nil)
        result = _currentEvents.firstObject;
    else
        for (idx=_lastEventIndex; idx<numEvents; idx++)
            if (_currentEvents[idx] == event)
                {
                if (idx < numEvents -1)
                    {
                    result = _currentEvents[idx+1];
                    break;
                    }
                }
    _lastEventIndex = idx;
    return result;
    }



#pragma mark - Triggering

/*****************************************************************************\
|* Check any trigger conditions for an event
\*****************************************************************************/
- (BOOL) shouldTriggerWith:(SBEvent *)event during:(SBOperation *)op
    {
    BOOL triggered = NO;
    switch (_triggerMode)
        {
        case TriggerOnce:
            triggered = [self _checkTriggerOnceFor:event];
            break;
        
        case TriggerWhen:
            triggered = [self _checkTriggerWhenFor:event];
            break;
        
        case TriggerAfter:
            triggered = [self _checkTriggerAfterFor:event during:op];
            break;
    
        default:    // To prevent a warning, we should never get here
            NSLog(@"We should never get here");
            break;
        }
    
    return triggered;
    }

/*****************************************************************************\
|* Check for a 'once' trigger type
\*****************************************************************************/
- (BOOL) _checkTriggerOnceFor:(SBEvent *)event
    {
    BOOL triggered = NO;
    
    if (event.signal == _triggerOnceSignal)
        {
        switch (_triggerOnceCondition)
            {
            case ConditionHi:
                triggered = (event.signal.hiCount >= _triggerOnceCount);
                break;
            
            case ConditionLo:
                triggered = (event.signal.loCount >= _triggerOnceCount);
                break;
            
            case ConditionChanged:
                triggered = (event.signal.changeCount >= _triggerOnceCount);
                break;
            }
        }
    
    return triggered;
    }

/*****************************************************************************\
|* Check for a 'when' trigger type
\*****************************************************************************/
- (BOOL) _checkTriggerWhenFor:(SBEvent *)event
    {
    BOOL triggered = NO;
    
    if (event.signal == _triggerWhenSignal)
        triggered = (event.signal.currentValue == _triggerWhenValue);
    
    return triggered;
    }

/*****************************************************************************\
|* Check for an 'after' trigger type
\*****************************************************************************/
- (BOOL) _checkTriggerAfterFor:(SBEvent *)event during:(SBOperation *)op
    {
    BOOL triggered = NO;
    
    switch (_triggerAfterUnit)
        {
        case UnitSeconds:
            {
            double secs = op.cron * 1E-9;
            triggered   = secs >= _triggerAfterCount;
            break;
            }
            
        case UnitClocks:
            {
            uint64_t clocks = op.cron / _period;
            triggered       = clocks >= _triggerAfterCount;
            break;
            }
       }
       
    return triggered;
    }


#pragma mark - Termination

/*****************************************************************************\
|* Check any termination conditions for an event
\*****************************************************************************/
- (BOOL) shouldTerminateWith:(SBEvent *)event during:(SBOperation *)op
    {
    BOOL terminate = NO;
    switch (_termMode)
        {
        case TermOnce:
            terminate = [self _checkTermOnceFor:event];
            break;
        
        case TermWhen:
            terminate = [self _checkTermWhenFor:event];
            break;
        
        case TermAfter:
            terminate = [self _checkTermAfterFor:event during:op];
            break;
        }
    
    return terminate;
    }

/*****************************************************************************\
|* Check for a 'once' termination type
\*****************************************************************************/
- (BOOL) _checkTermOnceFor:(SBEvent *)event
    {
    BOOL terminate = NO;
    
    if (event.signal == _termOnceSignal)
        {
        switch (_termOnceCondition)
            {
            case ConditionHi:
                terminate = (event.signal.hiCount >= _termOnceCount);
                break;
            
            case ConditionLo:
                terminate = (event.signal.loCount >= _termOnceCount);
                break;
            
            case ConditionChanged:
                terminate = (event.signal.changeCount >= _termOnceCount);
                break;
            }
        }
    
    return terminate;
    }

/*****************************************************************************\
|* Check for a 'when' termination type
\*****************************************************************************/
- (BOOL) _checkTermWhenFor:(SBEvent *)event
    {
    BOOL terminate = NO;
    
    if (event.signal == _termWhenSignal)
        terminate = (event.signal.currentValue == _termWhenValue);
    
    return terminate;
    }

/*****************************************************************************\
|* Check for an 'after' termination type
\*****************************************************************************/
- (BOOL) _checkTermAfterFor:(SBEvent *)event during:(SBOperation *)op
    {
    BOOL terminate = NO;
    
    switch (_termAfterUnit)
        {
        case UnitSeconds:
            {
            double secs = (op.cron - _triggerBase) * 1E-9;
            terminate   = secs >= _termAfterCount;
            break;
            }
            
        case UnitClocks:
            {
            uint64_t clocks = (op.cron - _triggerBase) / _period;
            terminate       = clocks >= _termAfterCount+1;
            break;
            }
       }
       
    return terminate;
    }


#pragma mark - Notifications

/*****************************************************************************\
|* The clock was reconfigured, store the parameters for later
\*****************************************************************************/
- (void) _clockParametersChanged:(NSNotification *)n
    {
    _period = [(NSNumber *)(n.userInfo[@"period"]) intValue];
    }
    
@end
