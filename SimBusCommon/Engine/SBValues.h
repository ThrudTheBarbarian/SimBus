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
    uint64_t cron;          // Timestamp in ns
    uint32_t value;         // 32-bit value
    uint32_t flags;         // Flags for this signal value
    } Value128;

typedef struct
    {
    uint64_t first;         // The first cron timestamp
    uint64_t last;          // The last cron timestamp
    } SBExtent;
    
NS_INLINE SBExtent SBMakeExtent(uint64_t start, uint64_t end)
    {
    SBExtent e;
    e.first  = start;
    e.last   = end;
    return e;
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
|* The first timestamp of data
\*****************************************************************************/
- (uint64_t) firstTimestamp;

/*****************************************************************************\
|* The most-recent timestamp of data
\*****************************************************************************/
- (uint64_t) currentTimestamp;

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear;


/*****************************************************************************\
|* Properties
\*****************************************************************************/

// The data itself
@property(strong, nonatomic) NSMutableData *        data;

// The first timestamp of data
@property(assign, nonatomic) uint64_t               firstTimestamp;

// The most-recent timestamp of data
@property(assign, nonatomic) uint64_t               currentTimestamp;

@end

NS_ASSUME_NONNULL_END
