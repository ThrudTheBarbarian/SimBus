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

- (void) setPlugin:(id<SBPlugin>)plugin;


#pragma mark - Properties

/*****************************************************************************\
|* Property: Whether a given signal in this view is expanded, each key of
|* signal.identifier will be 0|1
\*****************************************************************************/
@property(strong, nonatomic)
NSMutableDictionary<NSNumber *, NSNumber *> *                       expanded;

@end

NS_ASSUME_NONNULL_END
