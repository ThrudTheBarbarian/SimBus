//
//  MenuBarController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "AddItemController.h"
#import "AppDelegate.h"
#import "MenuBarController.h"

@interface MenuBarController()
@property (strong, nonatomic) AddItemController *       add;
@end

@implementation MenuBarController

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)resetButtonWasClicked:(id)sender
    {
    NSLog(@"reset clicked!");
    }

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)pauseButtonWasClicked:(id)sender
    {
    NSLog(@"pause clicked!");
    }

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)runButtonWasClicked:(id)sender
    {
    NSLog(@"run clicked!");
    }

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)addButtonWasClicked:(id)sender
    {
    if (_add == nil)
        _add = [[AddItemController alloc] initWithWindowNibName:@"AddItemController"];

    NSRect f        = _add.window.frame;
    NSPoint mouse   = NSEvent.mouseLocation;
    NSPoint to      = NSMakePoint(mouse.x - f.size.width/2,
                                  mouse.y - f.size.height*1.5);
    [_add.window setFrameOrigin:to];
    [_add.window makeKeyAndOrderFront:nil];
    }

@end
