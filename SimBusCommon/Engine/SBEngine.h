//
//  SBEngine.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SBPluginProtocol.h>
#import <SimBusCommon/SBSignal.h>

extern NSString * _Nonnull const kAutomaticInstantiation;

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
- (void) addPlugin:(id<SBPlugin>)plugin autoAdd:(BOOL)autoAdd;
- (void) addPlugin:(id<SBPlugin>)plugin;

/*****************************************************************************\
|* Get a signal for a given name, or return nil
\*****************************************************************************/
- (nullable SBSignal *) signalForName:(NSString *)name;

/*****************************************************************************\
|* Get a signal for a given type, or return nil
\*****************************************************************************/
- (nullable SBSignal *) signalForType:(SignalType)type;

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
|* Check any trigger conditions for an event
\*****************************************************************************/
- (BOOL) shouldTriggerWith:(SBEvent *)event during:(SBOperation *)op;

/*****************************************************************************\
|* Request creation of a signal - if the name already exists, the existing
|* object will be returned. This will return nil if a signal of the same
|* name already exists, but has different parameters
\*****************************************************************************/
- (nullable SBSignal *) makeSignalWithName:(NSString *)name
                                   ofWidth:(int)width
                                      type:(SignalType)type;

/*****************************************************************************\
|* Return the next event after a specified one, where nil indicates the first
\*****************************************************************************/
- (nullable SBEvent *) eventFollowing:(nullable SBEvent *)event;

/*****************************************************************************\
|* Allow registration of asynchronous events on a per-plugin basis
\*****************************************************************************/
- (void) addAsynchronousListenerFor:(SBEvent *)event;

/*****************************************************************************\
|* Handle asynchronous signal change events. These aren't based purely on time
\*****************************************************************************/
- (void) signal:(SBSignal *)signal changedFrom:(int64_t)oldValue;

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
    
@property (assign, nonatomic) double                        termAfterCount;
@property (assign, nonatomic) SimUnit                       termAfterUnit;

/*****************************************************************************\
|* Runtime
\*****************************************************************************/
// List of plugins
@property(strong, nonatomic) NSMutableArray<id<SBPlugin>> * plugins;

// The current clock period in ns
@property(assign, nonatomic) uint32_t                       period;

// The timestamp at which the trigger happened
@property(assign, nonatomic) int64_t                        triggerBase;

// The current list of events to process. It is allowable to add to
// this list while the event-processing is happening, as long as the
// list remains sorted. The list must never be shortened, or 'lastEventIndex'
// will not be a valid starting position
@property(strong, nonatomic) NSMutableArray<SBEvent *> *    currentEvents;

// The index into the list of events, of the event we last processed.
@property(assign, nonatomic) NSInteger                      lastEventIndex;

// Whether the engine is currently simulating (and therefore storing
// data to the signal values)
@property(assign, nonatomic) BOOL                           inSimulation;
@end

NS_ASSUME_NONNULL_END
