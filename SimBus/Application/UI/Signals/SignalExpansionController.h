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

- (BOOL) isExpandedByIdentifer:(NSNumber *)signalIdentifier;
- (BOOL) isExpanded:(SBSignal *)signal;

- (void) expandSignalByIdentifier:(NSNumber *)signalIdentifier;
- (void) expandSignal:(SBSignal *)signal;

- (void) unexpandSignalByIdentifier:(NSNumber *)signalIdentifier;
- (void) unexpandSignal:(SBSignal *)signal;

- (void) toggleSignalByIdentifier:(NSNumber *)signalIdentifier;
- (void) toggleSignal:(SBSignal *)signal;

- (void) reset;
@end

NS_ASSUME_NONNULL_END
