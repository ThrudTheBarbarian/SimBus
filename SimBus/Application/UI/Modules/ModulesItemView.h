//
//  ModulesItemView.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModulesItemView : NSView

/*****************************************************************************\
|* Get and set the plugin
\*****************************************************************************/
- (void) setPlugin:(id<SBPlugin>)plugin;
- (id<SBPlugin>) itemPlugin;

@end

NS_ASSUME_NONNULL_END
