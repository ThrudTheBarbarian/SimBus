//
//  SBOperation.m
//  SimBusCommon
//
//  Created by ThrudTheBarbarian on 16/12/2025.
//

#import "SBEngine.h"
#import "SBEvent.h"
#import "SBOperation.h"

@interface SBOperation()

// If this flag is set, we continue the simulation
@property(assign, nonatomic) BOOL                               isRunning;

// If this flag is set, we continue the simulation
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
    BOOL triggered = (_engine.triggerMode == TriggerNone);
    
    // We start off by marking ourselves as in-process
    _isRunning = YES;
    
    // Get the list of signals that the engine is using:
    NSArray<SBSignal *> *signals = [_engine signals];
    
    while (_isRunning)
        {
        /*********************************************************************\
        |* Get a sorted list of all the signals by their next-event timestamp
        \*********************************************************************/
        NSArray<SBEvent *> *events = [self _generateEvents];
        
        /*********************************************************************\
        |* Process each event in the list in turn
        \*********************************************************************/
        for (SBEvent *event in events)
            {
            // Update cron
            _cron = event.when;
            
            // call the plugin
            [event.plugin process:event withSignals:signals];
            
            // Check for termination conditions
            if ([_engine shouldTerminateWith:event during:self])
                _isRunning = NO;
            }
        }
    }
    
/*****************************************************************************\
|* Enumerate a list of events from each plugin in the engine
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
                event.when += _cron + period/2;
                event.type = AbsoluteTimeEvent;
                break;
            
            case AfterNextClockLoEvent:
                event.when += _cron + period;
                event.type = AbsoluteTimeEvent;
                break;
             
            case BeforeNextClockHiEvent:
                event.when = _cron + period/2 - event.when;
                event.type = AbsoluteTimeEvent;
                break;
           
            case BeforeNextClockLoEvent:
                event.when = _cron + period - event.when;
                event.type = AbsoluteTimeEvent;
                break;
            
            default:
                NSLog(@"Unimplemented time spec %d", event.type);
                break;
            }
        }
    
    // Remove any events > 1 clock and put them in the pending list
    
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
    
    return [results sortedArrayUsingComparator:
            ^NSComparisonResult(SBEvent *a, SBEvent *b)
                {
                return b.when > a.when ? NSOrderedAscending
                     : b.when < a.when ? NSOrderedDescending
                     : NSOrderedSame;
                }];
    }
    
    
@end
