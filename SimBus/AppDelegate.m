//
//  AppDelegate.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

/*****************************************************************************\
|* Program entry point
\*****************************************************************************/
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
    {
    // Insert code here to initialize your application
    }


/*****************************************************************************\
|* We are about to die
\*****************************************************************************/
- (void)applicationWillTerminate:(NSNotification *)aNotification
    {
    // Insert code here to tear down your application
    }

/*****************************************************************************\
|* Plug a security hole. Tell AppKit “You can use Secure Coding for saving
|* and restoring state; I’m not doing any custom stuff during that process
|* that’s incompatible with NSSecureCoding.”
\*****************************************************************************/
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
    {
    return YES;
    }

/*****************************************************************************\
|* We want to close down when the window is closed 
\*****************************************************************************/
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
    {
    return YES;
    }


@end
