//
//  SignalsItem.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

#import "PluginProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalsItem : NSCollectionViewItem

/*****************************************************************************\
|* Set the plugin instance and configure the view
\*****************************************************************************/
- (void) setPlugin:(id<Plugin>)plugin;

/*****************************************************************************\
|* Return the size that a given item's view should be
\*****************************************************************************/
- (NSSize) calculatedViewSize;

@end

NS_ASSUME_NONNULL_END
