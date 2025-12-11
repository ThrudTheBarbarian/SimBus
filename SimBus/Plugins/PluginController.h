//
//  PluginController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PluginController : NSObject

/*****************************************************************************\
|* Make this a singleton
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;

/*****************************************************************************\
|* Load all the plugins
\*****************************************************************************/
- (void) loadPlugins;

@end

NS_ASSUME_NONNULL_END
