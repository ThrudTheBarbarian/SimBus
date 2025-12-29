//
//  ExerciserPlugin.h
//  Exerciser
//
//  Created by ThrudTheBarbarian on 29/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

enum
    {
    OP_READ    = 0,
    OP_WRITE
    };

@interface ExerciserPlugin : NSObject <SBPlugin>

/*****************************************************************************\
|* Property: List of signals in the plugin
\*****************************************************************************/
@property (strong, nonatomic) NSMutableArray<SBSignal *> *      signals;

/*****************************************************************************\
|* Property: The engine that the plugin uses
\*****************************************************************************/
@property (strong, nonatomic) SBEngine *                        engine;


/*****************************************************************************\
|* Property: The address to start reading/writing from/to
\*****************************************************************************/
@property (assign, nonatomic) int                               addrStart;

/*****************************************************************************\
|* Property: The increment for addressing
\*****************************************************************************/
@property (assign, nonatomic) int                               addrIncr;

/*****************************************************************************\
|* Property: The number of operations (if there are sufficient clocks)
\*****************************************************************************/
@property (assign, nonatomic) int                               opCount;

/*****************************************************************************\
|* Property: The initial value to write
\*****************************************************************************/
@property (assign, nonatomic) int                               writeValue;

/*****************************************************************************\
|* Property: The increment for the value to write
\*****************************************************************************/
@property (assign, nonatomic) int                               writeIncr;

/*****************************************************************************\
|* Property: The number of clocks to delay by
\*****************************************************************************/
@property (assign, nonatomic) int                               delay;

/*****************************************************************************\
|* Property: The type of operation (OP_WRITE, OP_READ)
\*****************************************************************************/
@property (assign, nonatomic) int                               type;

@end

NS_ASSUME_NONNULL_END
