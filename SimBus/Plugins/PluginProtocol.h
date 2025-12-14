//
//  PluginProtocol.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>
#import <Common/Common.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Plugin <NSObject>

/*****************************************************************************\
|* Return the name to use for this plugin, both instance and class
\*****************************************************************************/
+ (NSString *) pluginName;
- (NSString *) pluginName;

/*****************************************************************************\
|* Return a list of signals of interest to this plugin
\*****************************************************************************/
- (NSArray<SBSignal *> *) signals;

/*****************************************************************************\
|* Tell the plugin which engine it is associated with
\*****************************************************************************/
- (void) setEngine:(SBEngine *)engine;

@end

NS_ASSUME_NONNULL_END
