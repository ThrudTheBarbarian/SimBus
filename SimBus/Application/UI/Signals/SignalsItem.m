//
//  SignalsItem.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import "SignalsItem.h"
#import "SignalsItemView.h"

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
|* Set the plugin instance 
\*****************************************************************************/
- (void) setPlugin:(id<Plugin>)plugin
    {
    _plugin = plugin;
    ((SignalsItemView *)(self.view)).plugin = plugin;
    }

@end
