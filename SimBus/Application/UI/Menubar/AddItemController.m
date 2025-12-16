//
//  AddItemController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>

#import "AddItemController.h"

@interface AddItemController ()
@property(strong, nonatomic) IBOutlet NSPopUpButton *           options;
@end

@implementation AddItemController

/*****************************************************************************\
|* We just loaded, fill things out
\*****************************************************************************/
- (void)windowDidLoad
    {
    [super windowDidLoad];

    // Populate the list of available plugins
    [_options removeAllItems];
    SBPluginController *pc = SBPluginController.sharedInstance;
    int idx = 0;
    for (Class klass in pc.classes)
        {
        NSString *name = [klass pluginName];
        [_options addItemWithTitle:name];
        [_options.lastItem setTag:idx];
        idx++;
        }
    }

/*****************************************************************************\
|* Need to handle a cancel action
\*****************************************************************************/
- (IBAction)cancelPressed:(id)sender
    {
    [self.window orderOut:self];
    }

/*****************************************************************************\
|* Need to handle adding an item action
\*****************************************************************************/
- (IBAction)addItemPressed:(id)sender
    {
    [self.window orderOut:self];
    
    // Create a new instance of the item, only done here so we can pass it
    // around easily as a single object.
    SBPluginController *pc          = SBPluginController.sharedInstance;
    int tag                         = (int) _options.selectedItem.tag;
    if ((tag >= 0) && (tag < pc.classes.count))
        {
        Class klass                 = pc.classes[tag];
        id<SBPlugin> instance       = klass.new;
    
        NSNotificationCenter *nc    = NSNotificationCenter.defaultCenter;
        [nc postNotificationName:kAddItemNotification object:instance];
        }
    }

@end
