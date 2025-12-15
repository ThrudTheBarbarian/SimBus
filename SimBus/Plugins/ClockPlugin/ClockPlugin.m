//
//  ClockPlugin.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Common/Common.h>
#import "ClockPlugin.h"

#import "ClockUI.h"

#define PLUGIN_NAME         @"Clock source"

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
- (void) activatePopover:(NSPopover *)popover forView:(NSView *)view
    {    
    // Create the view controller for the NSPopover if needed
    if (_vc == nil)
        {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _vc = [[ClockUI alloc] initWithNibName:@"ClockUI" bundle:bundle];
        [_vc loadView];
        }
        
    [popover setContentSize:NSMakeSize(500, 700)];
    [popover setContentViewController:_vc];
    [popover showRelativeToRect:[view frame] ofView:view.superview preferredEdge:NSMaxXEdge];
    }


@end
