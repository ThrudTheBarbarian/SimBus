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

/*****************************************************************************\
|* Property: The link to the engine
\*****************************************************************************/
@property (strong, nonatomic) SBEngine *                    engine;

/*****************************************************************************\
|* Property: The absolute time of the simulation. Use int64_t not uint64_t for
|* ease of maths
\*****************************************************************************/
@property(assign, nonatomic) int64_t                        cron;
@end

NS_ASSUME_NONNULL_END
