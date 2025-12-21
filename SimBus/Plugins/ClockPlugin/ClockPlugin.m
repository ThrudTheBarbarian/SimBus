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
    CLOCK_HI,
    CLOCK_PERIOD
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
        _clk        = CLOCK_HI;
        _signals    = [NSMutableArray new];
        
        SBEngine *engine    = SBEngine.sharedInstance;
        SBSignal *sig       = [engine makeSignalWithName:@"clk"
                                                 ofWidth:1
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
|* Add two events, the clock going low at T=0 and going high at period/2. We
|* also add in a 'clock period done' event, because it makes the maths a lot
|* simpler in the engine
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
    
    SBEvent *clockDone  = [SBEvent withRelativeTime:_period];
    clockDone.signal    = clk;
    clockDone.plugin    = self;
    clockDone.tag       = CLOCK_PERIOD;
    [list addObject:clockDone];
    }

/*****************************************************************************\
|* Tell the plugin to process the event that it previously added
\*****************************************************************************/
- (void) process:(SBEvent *)event
     withSignals:(NSArray<SBSignal *> *)signals
         persist:(BOOL)storeValues
    {
    if (event.tag != CLOCK_PERIOD)
        {
        _clk = (_clk == CLOCK_LO) ? CLOCK_HI : CLOCK_LO;
        [event.signal update:_clk at:event.when persist:storeValues];
        }
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
