//
//  AppDelegate.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>

#import "AppDelegate.h"


@implementation AppDelegate

/*****************************************************************************\
|* Program entry point
\*****************************************************************************/
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
    {
    // Create the engine for simulation
    _engine = [SBEngine sharedInstance];
    
    // Load the plugins, each creating a device
    _pluginController = [SBPluginController sharedInstance];
    [_pluginController loadPlugins];

    // Run through the plugins (which are loaded by now) and see if there
    // are any that provide a clk-src type signal. If so, load that plugin
    // instance into the engine
    NSNotificationCenter *nc    = NSNotificationCenter.defaultCenter;
    NSArray<Class> *list        = SBPluginController.sharedInstance.classes;
    for (Class klass in list)
        {
        id<SBPlugin>instance = [klass new];
        for (SBSignal *signal in instance.signals)
            if (signal.type == SIGNAL_CLOCK_SRC)
                [nc postNotificationName:kAddItemNotification
                                  object:instance
                                userInfo:@{
                                        kAutomaticInstantiation : @(YES)
                                        }];
        }
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
