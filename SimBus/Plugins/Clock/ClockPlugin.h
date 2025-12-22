//
//  ClockPlugin.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockPlugin : NSObject <SBPlugin>

/*****************************************************************************\
|* Update the clock parameters and tell the world
\*****************************************************************************/
- (void) setDuty:(int)duty withPeriod:(int)period;


#pragma mark - Properties

/*****************************************************************************\
|* Property: List of signals in the clock plugin
\*****************************************************************************/
@property (strong, nonatomic) NSMutableArray<SBSignal *> *      signals;

/*****************************************************************************\
|* Property: The engine that the clock plugin uses
\*****************************************************************************/
@property (strong, nonatomic) SBEngine *                        engine;

/*****************************************************************************\
|* Property: Properties for the plugin
\*****************************************************************************/
@property(assign, nonatomic) int                                period;
@property(assign, nonatomic) int                                duty;

@end

NS_ASSUME_NONNULL_END
