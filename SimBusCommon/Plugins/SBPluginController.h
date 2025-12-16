//
//  SBPluginController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBPluginController : NSObject

/*****************************************************************************\
|* Make this a singleton
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;

/*****************************************************************************\
|* Load all the plugins
\*****************************************************************************/
- (void) loadPlugins;

// The list of classes, one per plugin, that implement our protocol
@property (strong, nonatomic) NSMutableArray<Class> *           classes;
@end

NS_ASSUME_NONNULL_END
