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

@interface SBEngine()
// Whether this engine has ever been run
@property(assign, nonatomic) BOOL                               hasRun;

// Whether this engine is currently running
@property(strong, nonatomic) SBOperation *                      currentOp;

// An operation queue to run the simulation on
@property(strong, nonatomic) NSOperationQueue *                 bgQ;

@property(strong, nonatomic)
NSMutableDictionary<NSString *, SBSignal *> *                   signalMap;


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
                                  expanded:(BOOL)expanded
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
    signal = [SBSignal withName:name width:width type:type expanded:expanded];
    _signalMap[name] = signal;
    return signal;
    }
    
/*****************************************************************************\
|* Add a plugin to the engine
\*****************************************************************************/
- (void) addPlugin:(id<SBPlugin>)plugin;
    {
    [_plugins addObject:plugin];
    
    [plugin setEngine:self];
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

#pragma  mark - run-time


/*****************************************************************************\
|* Reset the engine for a new run
\*****************************************************************************/
- (void) reset
    {
    for (id<SBPlugin> plugin in _plugins)
        {
        for (SBSignal *signal in plugin.signals)
            [signal.values clear];
        }
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

#pragma mark - Private methods

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
            double secs = op.cron * 1E-9;
            terminate   = secs >= _termAfterCount;
            break;
            }
            
        case UnitClocks:
            {
            uint32_t clocks = op.cron / _period;
            terminate       = clocks >= _termAfterCount;
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
