//
//  SBEngine.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>
#import <Common/Common.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBEngine : NSObject

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;

/*****************************************************************************\
|* Add a plugin to the engine
\*****************************************************************************/
- (void) addPlugin:(id<Plugin>)plugin;

@end

NS_ASSUME_NONNULL_END
