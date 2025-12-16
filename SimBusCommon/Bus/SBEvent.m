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
        }
    return self;
    }

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withAbsoluteTime:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:AbsoluteTimeEvent at:ns];
    }
    
+ (instancetype) withRelativeTime:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:RelativeTimeEvent at:ns];
    }

+ (instancetype) afterNextClockHi:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:AfterNextClockHiEvent at:ns];
    }

+ (instancetype) afterNextClockLo:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:AfterNextClockLoEvent at:ns];
    }

+ (instancetype) beforeNextClockHi:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:BeforeNextClockHiEvent at:ns];
    }

+ (instancetype) beforeNextClockLo:(uint64_t)ns
    {
    return [[SBEvent alloc] initWithType:BeforeNextClockLoEvent at:ns];
    }

+ (instancetype) onSignalChange:(NSArray<NSString *> *)signals
    {
    SBEvent *be = [[SBEvent alloc] initWithType:SignalChangeEvent at:0];
    be.signals   = signals;
    return be;
    }


@end
