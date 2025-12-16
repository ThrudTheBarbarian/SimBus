//
//  SBEngine.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBEngine.h"
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
    NSMutableArray<SBSignal *> *signals = NSMutableArray.new;
    for (id<SBPlugin> plugin in _plugins)
        for (SBSignal *signal in plugin.signals)
            [signals addObject:signal];
    return signals;
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
    

#pragma mark - Notifications

/*****************************************************************************\
|* The clock was reconfigured, store the parameters for later
\*****************************************************************************/
- (void) _clockParametersChanged:(NSNotification *)n
    {
    _period = [(NSNumber *)(n.userInfo[@"period"]) intValue];
    }
    
@end
