//
//  ClockPlugin.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>
#import "ClockPlugin.h"

#import "ClockUI.h"

#define PLUGIN_NAME         @"Clock source"

enum
    {
    CLOCK_LO = 0,
    CLOCK_HI
    };

@interface ClockPlugin()
@property (assign, nonatomic) int                               clk;
@property (strong, nonatomic) ClockUI *                         vc;
@end

@implementation ClockPlugin

/*****************************************************************************\
|* Initialise an instance of this plugin
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _clk        = 1;
        _signals    = [NSMutableArray new];
        
        SBSignal *sig = [SBSignal withName:@"clk"
                                     width:1
                                      type:SIGNAL_CLOCK_SRC
                                  expanded:NO];
        [_signals addObject:sig];
        
        [self setDuty:50 withPeriod:576];
        }
    return self;
    }

/*****************************************************************************\
|* Return the name to use for this plugin
\*****************************************************************************/
+ (NSString *) pluginName
    {
    return PLUGIN_NAME;
    }

/*****************************************************************************\
|* Return the name to use for this plugin
\*****************************************************************************/
- (NSString *) pluginName
    {
    return PLUGIN_NAME;
    }

/*****************************************************************************\
|* Give the plugin a reference to the popover used for any configuration and
|* make it perform the open-popover configuration action
\*****************************************************************************/
- (NSViewController *)uiViewControllerForPopover:(NSPopover *)popover;
    {    
    // Create the view controller for the NSPopover if needed
    if (_vc == nil)
        {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _vc = [[ClockUI alloc] initWithNibName:@"ClockUI" bundle:bundle];
        [_vc setPlugin:self];
        [_vc view];
       }
        
    [popover setContentSize:NSMakeSize(319, 216)];
    [_vc setPopover:popover];
    return _vc;
    }

/*****************************************************************************\
|* Add two events, the clock going low at T=0 and going high at period/2
\*****************************************************************************/
- (void) addEventsTo:(NSMutableArray<SBEvent *> *)list
    {
    SBSignal *clk       = [_signals objectAtIndex:0];
    
    SBEvent *clockLo    = [SBEvent withRelativeTime:0];
    clockLo.signal      = clk;
    clockLo.plugin      = self;
    clockLo.tag         = CLOCK_LO;
    [list addObject:clockLo];
    
    SBEvent *clockHi    = [SBEvent withRelativeTime:_period/2];
    clockHi.signal      = clk;
    clockHi.plugin      = self;
    clockHi.tag         = CLOCK_HI;
    [list addObject:clockHi];
    }

/*****************************************************************************\
|* Tell the plugin to process the event that it previously added
\*****************************************************************************/
- (void) process:(SBEvent *)event
     withSignals:(NSArray<SBSignal *> *)signals
              at:(uint32_t)cron
    {
    // Since it's a 1-bit datum and we just store when it happened rather than
    // the value, we just need to store the time...
    [event.signal.values append1Bit:cron];
    }

/*****************************************************************************\
|* Update the clock parameters and tell the world
\*****************************************************************************/
- (void) setDuty:(int)duty withPeriod:(int)period
    {
    _duty   = duty;
    _period = period;

    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kClockChangedNotification
                      object:self
                    userInfo:@{ @"period"   : @(period),
                                @"duty"     : @(duty)
                              }];
    }
@end
