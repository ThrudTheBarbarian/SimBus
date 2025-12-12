//
//  SignalsItemView.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "PluginProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalsItemView : NSView

@property (strong, nonatomic) id<Plugin>            plugin;
@end

NS_ASSUME_NONNULL_END
