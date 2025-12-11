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
|* Return the name to use for this plugin
\*****************************************************************************/
+ (NSString *) pluginName;

/*****************************************************************************\
|* Return a list of signals of interest to this plugin
\*****************************************************************************/
- (NSArray<BusSignal *> *) signals;

@end

NS_ASSUME_NONNULL_END
