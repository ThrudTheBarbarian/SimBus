//
//  SBEvent.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBEvent.h"

@implementation SBEvent

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) initWithType:(EventType)type at:(int64_t)when
    {
    if (self = [super init])
        {
        _type       = type;
        _when       = when;
        _signals    = nil;
        _delay      = 0;
        }
    return self;
    }

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) initWithType:(EventType)type delay:(float)percentOfClockPeriod
    {
    if (self = [super init])
        {
        _type       = type;
        _when       = 0;
        _signals    = nil;
        _delay      = percentOfClockPeriod;
        }
    return self;
    }

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withAbsoluteTime:(int64_t)ns
    {
    return [[SBEvent alloc] initWithType:AbsoluteTimeEvent at:ns];
    }
    
+ (instancetype) withRelativeTime:(int64_t)ns
    {
    return [[SBEvent alloc] initWithType:RelativeTimeEvent at:ns];
    }

+ (instancetype) afterNextClockHi:(float)clocks
    {
    return [[SBEvent alloc] initWithType:AfterNextClockHiEvent delay:clocks];
    }

+ (instancetype) afterNextClockLo:(float)clocks
    {
    return [[SBEvent alloc] initWithType:AfterNextClockLoEvent delay:clocks];
    }

+ (instancetype) beforeNextClockHi:(float)clocks
    {
    return [[SBEvent alloc] initWithType:BeforeNextClockHiEvent delay:clocks];
    }

+ (instancetype) beforeNextClockLo:(float)clocks
    {
    return [[SBEvent alloc] initWithType:BeforeNextClockLoEvent delay:clocks];
    }

+ (instancetype) onSignalChange:(NSArray<SBSignal *> *)signals
    {
    SBEvent *be = [[SBEvent alloc] initWithType:SignalChangeEvent at:0];
    be.signals   = signals;
    return be;
    }


@end
