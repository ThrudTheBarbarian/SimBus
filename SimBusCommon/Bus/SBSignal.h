//
//  SBSignal.h
//  Common
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <AppKit/AppKit.h>
#import <SimBusCommon/SBValues.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum
    {
    SIGNAL_CLOCK_SINK,      // bus-clock derived from some other module
    SIGNAL_CLOCK_SRC,       // generated bus clock
    SIGNAL_ADDRESS,         // address bus
    SIGNAL_DATA,            // data-bus
    SIGNAL_BUS,             // some other generic bus
    SIGNAL_INPUT,           // input signal
    SIGNAL_OUTPUT,          // output signal
    SIGNAL_IO,              // input/output signal
    SIGNAL_MAX              // Maximum signal value
    } SignalType;

@interface SBSignal : NSObject

/*****************************************************************************\
|* Convenience initialisers 
\*****************************************************************************/
+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                     type:(SignalType)type;

+ (instancetype) withName:(NSString *)name
                  andType:(SignalType)type;

/*****************************************************************************\
|* Set the value of the signal. This also increments counts so use these, don't
|* modify _values directly. Persist will be true after triggering, and false
|* before
\*****************************************************************************/
- (void) update:(uint32_t)value
             at:(int64_t)cron
      withFlags:(int)flags
        persist:(BOOL)storeData;

/*****************************************************************************\
|* Return the extent (start, length) of the signal
\*****************************************************************************/
- (SBExtent) extent;

#pragma mark - Properties

/*****************************************************************************\
|* Property: unique identifier for a signal
\*****************************************************************************/
@property (strong, nonatomic) NSNumber *                identifier;

/*****************************************************************************\
|* Property: bit width of the signal
\*****************************************************************************/
@property (assign, nonatomic) uint32_t                  width;

/*****************************************************************************\
|* Property: name of the signal
\*****************************************************************************/
@property (strong, nonatomic) NSString *                name;

/*****************************************************************************\
|* Property: stem of an expanded signal
\*****************************************************************************/
@property (strong, nonatomic, nullable) NSString *      expandedStem;

/*****************************************************************************\
|* Property: type of this signal
\*****************************************************************************/
@property (assign, nonatomic) SignalType                type;

/*****************************************************************************\
|* Property: colour to draw this signal in
\*****************************************************************************/
@property (strong, nonatomic, nullable) NSColor *       colour;

/*****************************************************************************\
|* Property: historic signal values
\*****************************************************************************/
@property (assign, nonatomic) int64_t                  currentValue;

/*****************************************************************************\
|* Property: historic signal values
\*****************************************************************************/
@property (strong, nonatomic) SBValues *                values;


/*****************************************************************************\
|* Property: Number of times a 1-bit signal has been set high
\*****************************************************************************/
@property(assign, nonatomic) int64_t                    hiCount;

/*****************************************************************************\
|* Property: Number of times a 1-bit signal has been set low
\*****************************************************************************/
@property(assign, nonatomic) int64_t                    loCount;

/*****************************************************************************\
|* Property: Number of times a 1-bit signal has toggled (high *or* low), or a
|* multi-bit signal has changed
\*****************************************************************************/
@property(assign, nonatomic) int64_t                    changeCount;

@end

NS_ASSUME_NONNULL_END
