//
//  SBEngine.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SBPluginProtocol.h>
#import <SimBusCommon/SBSignal.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
    {
    TriggerNone     = 0,
    TriggerOnce,
    TriggerWhen,
    TriggerAfter
    } TriggerMode;

typedef enum
    {
    TermOnce        = 0,
    TermWhen,
    TermAfter
    } TermMode;

typedef enum
    {
    ConditionHi     = 0,
    ConditionLo,
    ConditionChanged
    } SimCondition;

typedef enum
    {
    UnitClocks = 0,
    UnitSeconds
    } SimUnit;

@class SBOperation;

@interface SBEngine : NSObject

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;

/*****************************************************************************\
|* Add a plugin to the engine
\*****************************************************************************/
- (void) addPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Get a signal for a given name, or return nil
\*****************************************************************************/
- (nullable SBSignal *) signalForName:(NSString *)name;

/*****************************************************************************\
|* Return a list of signals
\*****************************************************************************/
- (NSArray<SBSignal *> *) signals;

/*****************************************************************************\
|* Reset the engine for a new run
\*****************************************************************************/
- (void) reset;

/*****************************************************************************\
|* Perform a simulation run
\*****************************************************************************/
- (void) run;

/*****************************************************************************\
|* Check any termination conditions for an event
\*****************************************************************************/
- (BOOL) shouldTerminateWith:(SBEvent *)event during:(SBOperation *)op;

/*****************************************************************************\
|* Request creation of a signal - if the name already exists, the existing
|* object will be returned. This will return nil if a signal of the same
|* name already exists, but has different parameters
\*****************************************************************************/
- (nullable SBSignal *) makeSignalWithName:(NSString *)name
                                   ofWidth:(int)width
                                      type:(SignalType)type
                                  expanded:(BOOL)startExpanded;

#pragma mark - Properties

/*****************************************************************************\
|* Settings
\*****************************************************************************/
@property (assign, nonatomic) TriggerMode                   triggerMode;
@property (assign, nonatomic) TermMode                      termMode;
    
@property (strong, nonatomic, nullable) SBSignal *          triggerOnceSignal;
@property (assign, nonatomic) SimCondition                  triggerOnceCondition;
@property (assign, nonatomic) NSInteger                     triggerOnceCount;
    
@property (strong, nonatomic, nullable) SBSignal *          triggerWhenSignal;
@property (assign, nonatomic) NSInteger                     triggerWhenValue;
    
@property (assign, nonatomic) double                        triggerAfterCount;
@property (assign, nonatomic) SimUnit                       triggerAfterUnit;
    
    
@property (strong, nonatomic, nullable) SBSignal *          termOnceSignal;
@property (assign, nonatomic) SimCondition                  termOnceCondition;
@property (assign, nonatomic) NSInteger                     termOnceCount;
    
@property (strong, nonatomic, nullable) SBSignal *          termWhenSignal;
@property (assign, nonatomic) NSInteger                     termWhenValue;
    
@property (assign, nonatomic) NSInteger                     termAfterCount;
@property (assign, nonatomic) SimUnit                       termAfterUnit;

/*****************************************************************************\
|* Runtime
\*****************************************************************************/
// List of plugins
@property(strong, nonatomic) NSMutableArray<id<SBPlugin>> * plugins;

// The current clock period in ns
@property(assign, nonatomic) uint32_t                       period;

@end

NS_ASSUME_NONNULL_END
