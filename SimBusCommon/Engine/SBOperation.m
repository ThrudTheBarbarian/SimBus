//
//  SBOperation.m
//  SimBusCommon
//
//  Created by ThrudTheBarbarian on 16/12/2025.
//

#import "SBEngine.h"
#import "SBEvent.h"
#import "SBNotifications.h"
#import "SBOperation.h"

// Every TIME_DELTA seconds we will ask the UI to update
#define TIME_DELTA          0.1

@interface SBOperation()

// If this flag is set, we continue the simulation
@property(assign, nonatomic) BOOL                               isRunning;

// List of events that went into the next clock cycle
@property(strong, nonatomic) NSMutableArray<SBEvent *> *        pending;

@end


@implementation SBOperation

/*****************************************************************************\
|* Initialise this instance
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _cron       = 0;
        _isRunning  = NO;
        _pending    = NSMutableArray.new;
        }
    return self;
    }
    
/*****************************************************************************\
|* Pause (ie: exit) this operation, but we might re-schedule it keeping its
|* current state later on)
\*****************************************************************************/
- (void) pause
    {
    _isRunning  = NO;
    }
    
/*****************************************************************************\
|* This is the heart of the simulation, while this method is running we are
|* simulating
\*****************************************************************************/
- (void) main
    {
    // Set up the 'have we been triggered yet' flag
    BOOL triggered       = (_engine.triggerMode == TriggerNone);
    uint64_t triggerBase = 0;
    
    // We start off by marking ourselves as in-process
    _isRunning = YES;
    
    // Get the list of signals that the engine is using:
    NSArray<SBSignal *> *signals = [_engine signals];
  
    // Get the starting time
    NSDate *timestamp       = [NSDate date];

    _engine.inSimulation    = NO;
    for (id<SBPlugin> plugin in _engine.plugins)
        [plugin beginSimulation];
        
    // Do the wait-for-trigger phase if needed
    while (_isRunning && (!triggered))
        {
        /*********************************************************************\
        |* Get a sorted list of all the signals by their next-event timestamp
        \*********************************************************************/
        NSArray<SBEvent *> *events = [self _generateEvents];
        
        /*********************************************************************\
        |* Process each event in the list in turn
        \*********************************************************************/
        SBEvent *current = [_engine eventFollowing:nil];
        while (current != nil)
            {
            // Update cron
            _cron = current.when;
            
            // call the plugin but don't let it store any data
            [current.plugin process:current withSignals:signals persist:NO];
            
            // Check for trigger conditions
            if ([_engine shouldTriggerWith:current during:self])
                {
                triggerBase = _cron;
                triggered   = YES;
                }
                
            current = [_engine eventFollowing:current];
            }
            
        /*********************************************************************\
        |* If enough time has passed, tell the UI to update
        \*********************************************************************/
        NSDate *now = [NSDate date];
        double delta = now.timeIntervalSinceReferenceDate
                     - timestamp.timeIntervalSinceReferenceDate;
        if (delta > TIME_DELTA)
            {
            timestamp = now;
            [self updateUI:@{
                            @"mode" : @"Waiting for trigger",
                            }];
            }
        }
    
    [_engine setTriggerBase:triggerBase];
    [_engine reset];                        // Clear the values in the signals
    _engine.inSimulation    = YES;
    
    timestamp = [NSDate date];
    [self updateUI:@{
                    @"mode" : @"Starting capture",
                    }];

    // Do the data-capture phase
    while (_isRunning)
        {
        /*********************************************************************\
        |* Get a sorted list of all the signals by their next-event timestamp
        \*********************************************************************/
        NSArray<SBEvent *> *events = [self _generateEvents];
        
        /*********************************************************************\
        |* Process each event in the list in turn
        \*********************************************************************/
        SBEvent *current = [_engine eventFollowing:nil];
        while (current != nil)
            {
            // Update cron
            _cron = current.when;
            
            // call the plugin
            [current.plugin process:current withSignals:signals persist:YES];
            
            // Check for termination conditions
            if ([_engine shouldTerminateWith:current during:self])
                _isRunning = NO;
            
            current = [_engine eventFollowing:current];
            }

        /*********************************************************************\
        |* If enough time has passed, tell the UI to update
        \*********************************************************************/
        NSDate *now = [NSDate date];
        double delta = now.timeIntervalSinceReferenceDate
                     - timestamp.timeIntervalSinceReferenceDate;
        if (delta > TIME_DELTA)
            {
            [self updateUI:@{
                            @"mode" : @"Capturing data",
                            }];
            timestamp = now;
            }
        }

    /*************************************************************************\
    |* Housekeeping at the end of a simulation run
    \*************************************************************************/
    [self updateUI:@{
                    @"mode" : @"Capture complete",
                    }];
                    
    }
    
/*****************************************************************************\
|* Call the UI to update
\*****************************************************************************/
- (void) updateUI:(NSDictionary *)info
    {
    dispatch_async(dispatch_get_main_queue(), ^(void)
      {
      NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
      [nc postNotificationName:kInterfaceShouldUpdateNotification
                        object:self
                      userInfo:info];
      });
    }
    
/*****************************************************************************\
|* Enumerate a list of events from each plugin in the engine. Note that we
|* store the final list in the engine (which is fine because there's only
|* one operation going on at once) because we want to be able to modify the
|* list for asynchronous event processing
\*****************************************************************************/
- (NSArray<SBEvent *> *) _generateEvents
    {
    // Get the list of events we didn't handle last time as a starting
    // point, and add any that we think we need to for this time around
    NSMutableArray<SBEvent *> *list = _pending;
    _pending                        = NSMutableArray.new;
    
    SBEngine *engine                = SBEngine.sharedInstance;
    int period                      = engine.period;
    
    // First generate the list of events
    for (id<SBPlugin> plugin in engine.plugins)
        [plugin addEventsTo:list];
    
    // Then resolve the events to absolute time, so they can be easily sorted
    for (SBEvent *event in list)
        {
        switch (event.type)
            {
            case AbsoluteTimeEvent:
                break;
            
            case RelativeTimeEvent:
                event.when += _cron;
                event.type = AbsoluteTimeEvent;
                break;
            
            case AfterNextClockHiEvent:
                event.when += _cron + (uint64_t)(period * (0.5 + event.delay));
                event.type = AbsoluteTimeEvent;
                break;
            
            case AfterNextClockLoEvent:
                event.when += _cron + (uint64_t)(period * (1.0 + event.delay));
                event.type = AbsoluteTimeEvent;
                break;
             
            case BeforeNextClockHiEvent:
                event.when = _cron + (uint64_t)(period * (0.5 - event.delay));
                event.type = AbsoluteTimeEvent;
                break;
           
            case BeforeNextClockLoEvent:
                event.when = _cron + (uint64_t)(period * (1.0 - event.delay));
                event.type = AbsoluteTimeEvent;
                break;
            
            default:
                NSLog(@"Unimplemented time spec %d", event.type);
                break;
            }
        }
    
    // Remove any time-based events > 1 clock and put them in the pending list
    NSMutableArray<SBEvent *> *results = NSMutableArray.new;
    uint64_t limit = _cron + period;
    
    for (SBEvent *event in list)
    if (event.type == AbsoluteTimeEvent)
        {
        if (event.when > limit)
            [_pending addObject:event];
        else
            [results addObject:event];
        }
    [list removeAllObjects];
    
    // Then sort them and return the sorted list
    
    NSArray *sorted = [results sortedArrayUsingComparator:
        ^NSComparisonResult(SBEvent *a, SBEvent *b)
            {
            return b.when > a.when ? NSOrderedAscending
                 : b.when < a.when ? NSOrderedDescending
                 : NSOrderedSame;
            }];
    
    [engine setCurrentEvents:[NSMutableArray arrayWithArray:sorted]];
    return engine.currentEvents;
    }
    
    
@end
