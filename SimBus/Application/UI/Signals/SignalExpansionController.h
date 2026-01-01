//
//  SignalExpansionController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 28/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignalExpansionController : NSObject

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;

/*****************************************************************************\
|* Is a signal in a plugin expanded ?
\*****************************************************************************/
- (BOOL) isExpanded:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Set a signal in a plugin to be expanded
\*****************************************************************************/
- (void) expandSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Set a signal in a plugin to be not expanded
\*****************************************************************************/
- (void) unexpandSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Toggle the expanded state of a signal in a plugin
\*****************************************************************************/
- (void) toggleSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Clear all records
\*****************************************************************************/
- (void) reset;
@end

NS_ASSUME_NONNULL_END
