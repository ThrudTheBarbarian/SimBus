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
- (instancetype) initAsType:(ValueSize)type
    {
    if (self = [super init])
        {
        _data = [[NSMutableData alloc] initWithCapacity:1024*1024];
        _type = type;
        }
    return self;
    }

/*****************************************************************************\
|* Determine how many items there are in the data-store
\*****************************************************************************/
- (NSUInteger) count
    {
    int size = (_type == Value_1bit) ? sizeof(uint32_t) : sizeof(Value32Bit);
    return _data.length / size;
    }
    
/*****************************************************************************\
|* Add a 1-bit record
\*****************************************************************************/
- (void) append1Bit:(uint32_t)sample
    {
    [_data appendBytes:&sample length:sizeof(uint32_t)];
    }
        
/*****************************************************************************\
|* Add a 32-bit record
\*****************************************************************************/
- (void) append32Bit:(Value32Bit)sample
    {
    [_data appendBytes:&sample length:sizeof(Value32Bit)];
    }

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear
    {
    _data.length = 0;
    }

@end
