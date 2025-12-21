//
//  SBValues.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBValues.h"



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
    [_data appendBytes:&sample length:sizeof(Value128)];
    }

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear
    {
    _data.length = 0;
    }

@end
