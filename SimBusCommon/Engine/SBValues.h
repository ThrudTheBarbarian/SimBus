//
//  SBValues.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
    {
    Value_1bit      = 1,
    Value_multi     = 2
    } ValueSize;

/*****************************************************************************\
|* For multi-bit values we store the time at which the value changes and the
|* value at that time. There is an implicit value of 'undefined' at the start
|* of the simulation until the value is driven to either 0 or 1. If a plugin
|* has a pull-up/down assigned to a signal, it will drive from time 0. Note
|* that due to padding, there's no advantage in doing 8 or 16-bit variants of
|* the multi-bit structure
\*****************************************************************************/
typedef struct
    {
    uint32_t cron;          // Timestamp in ns
    uint32_t value;         // 32-bit value
    } Value32Bit;



@interface SBValues : NSObject


/*****************************************************************************\
|* Designated initialiser for the class
\*****************************************************************************/
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initAsType:(ValueSize)type;

/*****************************************************************************\
|* Determine how many entries we have in the data
\*****************************************************************************/
- (NSUInteger) count;

/*****************************************************************************\
|* For 1-bit values we just store the time at which the value changes. There
|* is an implicit value of 'undefined' at the start of the simulation until
|* the value is driven to either 0 or 1. If a plugin has a pull-up/down
|* assigned to a signal, it will drive from time 0
\*****************************************************************************/
- (void) append1Bit:(uint32_t)when;

/*****************************************************************************\
|* Add a 32-bit record
\*****************************************************************************/
- (void) append32Bit:(Value32Bit)sample;

/*****************************************************************************\
|* Clear all the values
\*****************************************************************************/
- (void) clear;


/*****************************************************************************\
|* Properties
\*****************************************************************************/

// Which type of values we store. Used to figure out how to parse the data
@property(assign, nonatomic) ValueSize              type;

// The data itself
@property(strong, nonatomic) NSMutableData *        data;

@end

NS_ASSUME_NONNULL_END
