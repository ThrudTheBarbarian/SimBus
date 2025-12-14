//
//  SBEvent.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>

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

@interface SBEvent : NSObject

/*****************************************************************************\
|* Set the designated initialiser
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithType:(EventType)type at:(int64_t)when;

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withAbsoluteTime:(uint64_t)ns;
+ (instancetype) withRelativeTime:(uint64_t)ns;
+ (instancetype) afterNextClockHi:(uint64_t)ns;
+ (instancetype) afterNextClockLo:(uint64_t)ns;
+ (instancetype) beforeNextClockHi:(uint64_t)ns;
+ (instancetype) beforeNextClockLo:(uint64_t)ns;
+ (instancetype) onSignalChange:(NSArray<NSString *> *)signals;

/*****************************************************************************\
|* Properties
\*****************************************************************************/

// The type of event this is
@property(assign, nonatomic) EventType                              type;

// The time-value of the event, in nanoseconds
@property(assign, nonatomic) uint64_t                               when;

// The list of signals for an on-change type of event
@property(strong, nonatomic, nullable) NSArray<NSString *> *        signals;
@end

NS_ASSUME_NONNULL_END
