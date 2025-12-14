//
//  BusSignal.h
//  Common
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <AppKit/AppKit.h>

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

@interface BusSignal : NSObject

/*****************************************************************************\
|* Convenience initialisers 
\*****************************************************************************/
+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                     type:(SignalType)type
                 expanded:(BOOL)expanded;

+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                  andType:(SignalType)type;

+ (instancetype) withName:(NSString *)name
                  andType:(SignalType)type;

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
|* Property: whether the signal is currently expanded if is > 1bit
\*****************************************************************************/
@property (assign, nonatomic) bool                      expanded;

/*****************************************************************************\
|* Property: colour to draw this signal in
\*****************************************************************************/
@property (strong, nonatomic, nullable) NSColor *       colour;
@end

NS_ASSUME_NONNULL_END
