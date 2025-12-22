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

@class SBSignal;

@interface SBEvent : NSObject

/*****************************************************************************\
|* Set the designated initialiser
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithType:(EventType)type at:(uint64_t)when;
- (instancetype) initWithType:(EventType)type delay:(float)percentOfClockPeriod;

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withAbsoluteTime:(uint64_t)ns;
+ (instancetype) withRelativeTime:(uint64_t)ns;
+ (instancetype) afterNextClockHi:(float)percentOfClockPeriod;
+ (instancetype) afterNextClockLo:(float)percentOfClockPeriod;
+ (instancetype) beforeNextClockHi:(float)percentOfClockPeriod;
+ (instancetype) beforeNextClockLo:(float)percentOfClockPeriod;
+ (instancetype) onSignalChange:(NSArray<NSString *> *)signals;

/*****************************************************************************\
|* Properties
\*****************************************************************************/

// The type of event this is
@property(assign, nonatomic) EventType                              type;

// The time-value of the event, in nanoseconds
@property(assign, nonatomic) uint64_t                               when;

// The delay of the event, as a fraction of a clock period. Note
// that the type of event dictates how the delay is interpreted
@property(assign, nonatomic) float                                  delay;

// The plugin that should process this event
@property(strong, nonatomic) id<SBPlugin>                           plugin;

// The signal to which this event refers
@property(strong, nonatomic) SBSignal *                             signal;

// A simple tag for a plugin to use to recognise this event
@property(assign, nonatomic) NSInteger                              tag;

// A dictionary of info that a plugin can use within an event
@property(strong, nonatomic) NSMutableDictionary<NSString *, id> *  info;

// The list of signals for an on-change type of event
@property(strong, nonatomic, nullable) NSArray<SBSignal *> *        signals;
@end

NS_ASSUME_NONNULL_END
