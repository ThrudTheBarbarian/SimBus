//
//  SignalsItem.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import "SignalsItem.h"

@interface SignalsItem ()
@property (strong, nonatomic) id<Plugin>            plugin;
@end

@implementation SignalsItem

/*****************************************************************************\
|* Nothing to do here
\*****************************************************************************/
- (void)viewDidLoad
    {
    [super viewDidLoad];
    }

/*****************************************************************************\
|* Set the plugin instance and configure the view
\*****************************************************************************/
- (void) setPlugin:(id<Plugin>)plugin
    {
    _plugin = plugin;
    
    NSRect frame = self.view.frame;
    frame.size.height = 45 + plugin.signals.count * 15;
    [self.view setFrame:frame];
    }

/*****************************************************************************\
|* Return the size that a given item's view should be
\*****************************************************************************/
- (NSSize) calculatedViewSize
    {
    NSRect frame = self.view.frame;
    frame.size.height = 45 + _plugin.signals.count * 15;
    return frame.size;
    }

@end
