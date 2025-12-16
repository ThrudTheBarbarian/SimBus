//
//  SBEngine.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SBPluginProtocol.h>

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
    ConditionToggled
    } SimCondition;

typedef enum
    {
    UnitSeconds     = 0,
    UnitClocks
    } SimUnit;
    
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

#pragma mark - Properties

/*****************************************************************************\
|* Settings
\*****************************************************************************/
@property (assign, nonatomic) TriggerMode               triggerMode;
@property (assign, nonatomic) TermMode                  termMode;

@property (strong, nonatomic, nullable) SBSignal *      triggerOnceSignal;
@property (assign, nonatomic) SimCondition              triggerOnceCondition;
@property (assign, nonatomic) NSInteger                 triggerOnceCount;

@property (strong, nonatomic, nullable) SBSignal *      triggerWhenSignal;
@property (assign, nonatomic) NSInteger                 triggerWhenValue;

@property (assign, nonatomic) NSInteger                 triggerAfterCount;
@property (assign, nonatomic) SimUnit                   triggerAfterUnit;


@property (strong, nonatomic, nullable) SBSignal *      termOnceSignal;
@property (assign, nonatomic) SimCondition              termOnceCondition;
@property (assign, nonatomic) NSInteger                 termOnceCount;

@property (strong, nonatomic, nullable) SBSignal *      termWhenSignal;
@property (assign, nonatomic) NSInteger                 termWhenValue;

@property (assign, nonatomic) NSInteger                 termAfterCount;
@property (assign, nonatomic) SimUnit                   termAfterUnit;

//
@end

NS_ASSUME_NONNULL_END
