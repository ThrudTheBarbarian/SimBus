//
//  AppDelegate.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Cocoa/Cocoa.h>

@class SBEngine;
@class ModulesDataSource;
@class SBPluginController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

// The main app window
@property (strong) IBOutlet NSWindow *window;

// The object that handles plugins
@property (strong, nonatomic) SBPluginController *          pluginController;

// The object that runs the simulation
@property (strong, nonatomic) SBEngine *                    engine;

// The object managing the busItems in the signals list
@property (strong, nonatomic) IBOutlet ModulesDataSource *  modulesDataSource;
@end

