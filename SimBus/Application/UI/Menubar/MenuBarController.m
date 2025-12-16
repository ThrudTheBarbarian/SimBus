//
//  MenuBarController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "AddItemController.h"
#import "AppDelegate.h"
#import "MenuBarController.h"
#import "SettingsViewController.h"

@interface MenuBarController()
@property (strong, nonatomic) AddItemController *           add;
@property (strong, nonatomic) SettingsViewController *      svc;
@property (strong, nonatomic) NSPopover *                   pop;
@end

@implementation MenuBarController

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)resetButtonWasClicked:(id)sender
    {
    [[SBEngine sharedInstance] reset];
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
    [[SBEngine sharedInstance] run];
    }

/*****************************************************************************\
|* Toolbar item clicked: add item
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

/*****************************************************************************\
|* Toolbar item clicked: configure engine
\*****************************************************************************/
- (IBAction)settingsButtonWasClicked:(id)sender
    {
    if (_pop == nil)
        _pop = [NSPopover new];
    
    if (_svc == nil)
        {
        _svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController"
                                                        bundle:[NSBundle mainBundle]];
        [_svc view];
        }
    _svc.popover = _pop;
    [_svc populateFields];
    
    _pop.contentSize = NSMakeSize(480, 392);
    _pop.contentViewController = _svc;
    _pop.animates = YES;
    
    NSButton *btn       = (NSButton *)sender;
    NSView *superview   = btn.superview;
    [_pop showRelativeToRect:btn.frame ofView:superview preferredEdge:NSMinYEdge];
    }
@end
