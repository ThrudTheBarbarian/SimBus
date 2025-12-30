//
//  SBEvent.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>
#import <SimBusCommon/SBPluginProtocol.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
    {
    AbsoluteTimeEvent           = 1,
    RelativeTimeEvent,
    AfterNextClockHiEvent,
    AfterNextClockLoEvent,
    BeforeNextClockHiEvent,
    BeforeNextClockLoEvent,
    SignalChangeEvent
    } EventType;

#define TAG_ASYNCHRONOUS        -1

@class SBSignal;

@interface SBEvent : NSObject

/*****************************************************************************\
|* Set the designated initialiser
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithType:(EventType)type at:(int64_t)when;
- (instancetype) initWithType:(EventType)type delay:(float)percentOfClockPeriod;

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withAbsoluteTime:(int64_t)ns;
+ (instancetype) withRelativeTime:(int64_t)ns;
+ (instancetype) afterNextClockHi:(float)percentOfClockPeriod;
+ (instancetype) afterNextClockLo:(float)percentOfClockPeriod;
+ (instancetype) beforeNextClockHi:(float)percentOfClockPeriod;
+ (instancetype) beforeNextClockLo:(float)percentOfClockPeriod;
+ (instancetype) onSignalChange:(NSArray<SBSignal *> *)signals;


#pragma mark - Properties

/*****************************************************************************\
|* Property: The type of event this is
\*****************************************************************************/
@property(assign, nonatomic) EventType                              type;

/*****************************************************************************\
|* Property: The time-value of the event, in nanoseconds
\*****************************************************************************/
@property(assign, nonatomic) int64_t                                when;

/*****************************************************************************\
|* Property: The delay of the event, as a fraction of a clock period. Note
|* that the type of event dictates how the delay is interpreted
\*****************************************************************************/
@property(assign, nonatomic) float                                  delay;

/*****************************************************************************\
|* Property: The plugin that should process this event
\*****************************************************************************/
@property(strong, nonatomic) id<SBPlugin>                           plugin;

/*****************************************************************************\
|* Property: The signal to which this event refers
\*****************************************************************************/
@property(strong, nonatomic) SBSignal *                             signal;

/*****************************************************************************\
|* Property: A simple tag for a plugin to use to recognise this event
\*****************************************************************************/
@property(assign, nonatomic) NSInteger                              tag;

/*****************************************************************************\
|* Property: The previous value of a signal on asynchronous change
\*****************************************************************************/
@property(assign, nonatomic) int64_t                                lastValue;

/*****************************************************************************\
|* Property: A dictionary of info that a plugin can use within an event
\*****************************************************************************/
@property(strong, nonatomic) NSMutableDictionary<NSString *, id> *  info;

/*****************************************************************************\
|* Property: The list of signals for an on-change type of event
\*****************************************************************************/
@property(strong, nonatomic, nullable) NSArray<SBSignal *> *        signals;
@end

NS_ASSUME_NONNULL_END
