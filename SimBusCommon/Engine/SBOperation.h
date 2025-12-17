//
//  SBOperation.h
//  SimBusCommon
//
//  Created by ThrudTheBarbarian on 16/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SBEngine;

@interface SBOperation : NSOperation

/*****************************************************************************\
|* Pause a simulation
\*****************************************************************************/
- (void) pause;


#pragma mark - Properties

// The link to the engine
@property (strong, nonatomic) SBEngine *                    engine;

// The absolute time of the simulation
@property(assign, nonatomic) uint64_t                       cron;
@end

NS_ASSUME_NONNULL_END
