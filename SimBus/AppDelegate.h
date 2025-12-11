//
//  AppDelegate.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Cocoa/Cocoa.h>

@class SignalsDataSource;
@class PluginController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

// The object that handles plugins
@property (strong, nonatomic) PluginController *            pluginController;

// The object managing the busItems in the signals list
@property (strong, nonatomic) IBOutlet SignalsDataSource *  signalsDataSource;
@end

