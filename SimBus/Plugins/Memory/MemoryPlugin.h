//
//  MemoryPlugin.h
//  Memory
//
//  Created by ThrudTheBarbarian on 22/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryPlugin : NSObject <SBPlugin>



#pragma mark - Properties

/*****************************************************************************\
|* Property: List of signals in the memory plugin
\*****************************************************************************/
@property (strong, nonatomic) NSMutableArray<SBSignal *> *      signals;

/*****************************************************************************\
|* Property: The engine that the plugin uses
\*****************************************************************************/
@property (strong, nonatomic) SBEngine *                        engine;

/*****************************************************************************\
|* Property: The bytes that map to "memory"
\*****************************************************************************/
@property (strong, nonatomic) NSMutableData *                   mem;

@end

NS_ASSUME_NONNULL_END
