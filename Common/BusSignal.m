//
//  BusSignal.m
//  Common
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "BusSignal.h"

@implementation BusSignal

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                     type:(SignalType)type
                 expanded:(BOOL)expanded
    {
    BusSignal *signal   = BusSignal.new;
    signal.name         = name;
    signal.width        = width;
    signal.type         = type;
    signal.expanded     = expanded;
    return signal;
    }



+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                  andType:(SignalType)type;
    {
    BusSignal *signal   = BusSignal.new;
    signal.name         = name;
    signal.width        = width;
    signal.type         = type;
    signal.expanded     = NO;
    return signal;
    }

+ (instancetype) withName:(NSString *)name andType:(SignalType)type
    {
    BusSignal *signal   = BusSignal.new;
    signal.name         = name;
    signal.width        = 1;
    signal.type         = type;
    signal.expanded     = NO;
    return signal;
    }

/*****************************************************************************\
|* Determine the colour based on type or whether it's been set
\*****************************************************************************/
- (NSColor *) colour
    {
    if (_colour)
        return _colour;
    
    switch (_type)
        {
        case SIGNAL_CLOCK_SINK:
            return [NSColor colorWithDeviceRed:0 green:0.9 blue:0 alpha:1.0];
        case SIGNAL_CLOCK_SRC:
            return [NSColor colorWithDeviceRed:0 green:0.8 blue:0 alpha:1.0];
        case SIGNAL_ADDRESS:
            return [NSColor colorWithDeviceRed:1.0 green:0.988 blue:0.475 alpha:1.0];
        case SIGNAL_DATA:
            return [NSColor colorWithDeviceRed:1.0 green:0.576 blue:0 alpha:1.0];
        case SIGNAL_BUS:
            return [NSColor colorWithDeviceRed:0.831 green:0.984 blue:.475 alpha:1.0];
        case SIGNAL_INPUT:
            return [NSColor colorWithDeviceRed:0.462 green:0.839 blue:1.0 alpha:1.0];
        case SIGNAL_OUTPUT:
            return [NSColor colorWithDeviceRed:0 green:0.992 blue:1.0 alpha:1.0];
        default:
            return [NSColor colorWithDeviceRed:0 green:0.588 blue:1.0 alpha:1.0];
        }
    }
@end
