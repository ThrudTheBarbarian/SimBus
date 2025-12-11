//
//  AddItemController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "AddItemController.h"
#import "PluginController.h"
#import "PluginProtocol.h"

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
    PluginController *pc = PluginController.sharedInstance;
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
    NSLog(@"tag: %d", (int) _options.selectedItem.tag);
    [self.window orderOut:self];
    }

@end
