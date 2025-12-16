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

@property (strong, nonatomic) SBEngine *                    engine;
@end

NS_ASSUME_NONNULL_END
