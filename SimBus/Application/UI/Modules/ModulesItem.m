//
//  ModulesItem.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import "ModulesItem.h"
#import "ModulesItemView.h"

@interface ModulesItem ()
@property (strong, nonatomic) id<SBPlugin>            plugin;
@end

@implementation ModulesItem

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
- (void) setPlugin:(id<SBPlugin>)plugin
    {
    _plugin = plugin;
    ((ModulesItemView *)(self.view)).plugin = plugin;
    }

@end
