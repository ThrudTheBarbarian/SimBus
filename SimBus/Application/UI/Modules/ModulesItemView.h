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

#pragma mark - Properties

/*****************************************************************************\
|* Property: the plugin for which we are a module
\*****************************************************************************/
@property (strong, nonatomic) id<SBPlugin>            plugin;
@end

NS_ASSUME_NONNULL_END
