//
//  SignalsItemView.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignalsItemView : NSView

@property (strong, nonatomic) id<SBPlugin>            plugin;
@end

NS_ASSUME_NONNULL_END
