//
//  SBValues.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum
    {
    SIGNAL_ASSERT       = 1,        // The signal is being driven
    SIGNAL_DEASSERT     = 2,        // The signal is being driven low
    SIGNAL_UNDEFINED    = 4,        // The value is undefined
    SIGNAL_CONFLICT     = 8,        // The value has multiple drivers
    };

/*****************************************************************************\
|* We store the time at which the value changes and the value at that time.
|* Negative values correspond to undefined/error conditions
\*****************************************************************************/
typedef struct
    {
    int64_t cron;           // Timestamp in ns
    uint32_t value;         // 32-bit value
    uint32_t flags;         // Flags for this signal value
    } Value128;

typedef struct
    {
    int64_t first;          // The first cron timestamp
    int64_t last;           // The last cron timestamp
    } SBExtent;
    
NS_INLINE SBExtent SBMakeExtent(int64_t start, int64_t end)
    {
    SBExtent e;
    e.first  = start;
    e.last   = end;
    return e;
    }

NS_INLINE int64_t SBRange(SBExtent extent)
    {
    return extent.last - extent.first;
    }
    
@interface SBValues : NSObject

/*****************************************************************************\
|* Designated initialiser for the class
\*****************************************************************************/

/*****************************************************************************\
|* Determine how many entries we have in the data
\*****************************************************************************/
- (NSUInteger) count;

/*****************************************************************************\
|* Add a 32-bit record
\*****************************************************************************/
- (void) append:(Value128)sample;

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear;

/*****************************************************************************\
|* Return a pointer to the last value in the set
\*****************************************************************************/
- (Value128 *) lastValue;

/*****************************************************************************\
|* Return a subset of the data
\*****************************************************************************/
- (nullable Value128 *) subsetFrom:(int64_t)from
                                to:(int64_t)to
                             count:(NSInteger *)num
                                at:(NSInteger *)at;

#pragma mark - Properties

/*****************************************************************************\
|* Property: The data itself
\*****************************************************************************/
@property(strong, nonatomic) NSMutableData *        data;

/*****************************************************************************\
|* Property: The first timestamp of data
\*****************************************************************************/
@property(assign, nonatomic) int64_t               firstTimestamp;

/*****************************************************************************\
|* Property: The last timestamp of data
\*****************************************************************************/
@property(assign, nonatomic) int64_t               lastTimestamp;

/*****************************************************************************\
|* Property: The most-recent timestamp of data
\*****************************************************************************/
@property(assign, nonatomic) int64_t               currentTimestamp;

@end

NS_ASSUME_NONNULL_END
