//
//  SBValues.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBValues.h"

typedef enum
    {
    STATE_FIND_MIN  = 0,
    STATE_FIND_MAX
    } SearchState;

@implementation SBValues

/*****************************************************************************\
|* Designated initialiser for the class
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        // Allocate space for 1,000,000 samples per signal to start with
        _data = [[NSMutableData alloc] initWithCapacity:1024*1024*128];
        
        // Set up the timestamp caches to their initial value
        _firstTimestamp     = 0;
        _lastTimestamp      = 0;
        _currentTimestamp   = 0;
        }
    return self;
    }

/*****************************************************************************\
|* Determine how many items there are in the data-store
\*****************************************************************************/
- (NSUInteger) count
    {
    return _data.length / sizeof(Value128);
    }
            
/*****************************************************************************\
|* Add a 128-bit record
\*****************************************************************************/
- (void) append:(Value128)sample
    {
    if (_data.length == 0)
        _firstTimestamp = sample.cron;
    _currentTimestamp = sample.cron;
    if (_lastTimestamp < _currentTimestamp)
        _lastTimestamp = _currentTimestamp;
        
    [_data appendBytes:&sample length:sizeof(Value128)];
    }

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear
    {
    _data.length = 0;
    }

/*****************************************************************************\
|* Return a subset of the data
\*****************************************************************************/
- (nullable Value128 *) subsetFrom:(uint64_t)from
                                to:(uint64_t)to
                             count:(NSInteger *)num
    {
    NSInteger first     = -1;
    NSInteger last      = -1;
    SearchState state   = STATE_FIND_MIN;
    
    Value128 *current   = (Value128 *) _data.bytes;
    NSInteger count     = 0;
    NSInteger quantum   = sizeof(Value128);
    NSInteger max       = _data.length;
    BOOL exitLoop       = NO;
    
    while (count < max)
        {
        switch (state)
            {
            case STATE_FIND_MIN:
                if (current->cron >= from)
                    {
                    first = (count == 0) ? 0 : count - quantum;
                    state = STATE_FIND_MAX;
                    }
                break;
            case STATE_FIND_MAX:
                if (current->cron >= to)
                    {
                    last        = count;
                    count       = max;
                    exitLoop    = YES;
                    }
                break;
            }
        
        if (exitLoop)
            break;
            
        last = count;
        count += quantum;
        current ++;
        }

    if (first < 0)
        {
        // Couldn't find any items
        *num = 0;
        return nil;
        }
    
    *num = (last - first) / quantum;
    return (Value128 *) (_data.bytes + first);
    }


@end
