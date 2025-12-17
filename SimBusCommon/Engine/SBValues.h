//
//  SBValues.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*****************************************************************************\
|* We store the time at which the value changes and the value at that time.
|* Negative values correspond to undefined/error conditions
\*****************************************************************************/
typedef struct
    {
    uint64_t cron;          // Timestamp in ns
    int64_t value;          // 63-bit value
    } Value128;

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
|* Properties
\*****************************************************************************/

// The data itself
@property(strong, nonatomic) NSMutableData *        data;

@end

NS_ASSUME_NONNULL_END
