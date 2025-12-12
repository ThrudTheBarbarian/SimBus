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
    BusSignal *signal  = BusSignal.new;
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
    BusSignal *signal  = BusSignal.new;
    signal.name         = name;
    signal.width        = width;
    signal.type         = type;
    signal.expanded     = NO;
    return signal;
    }

+ (instancetype) withName:(NSString *)name andType:(SignalType)type
    {
    BusSignal *signal  = BusSignal.new;
    signal.name         = name;
    signal.width        = 1;
    signal.type         = type;
    signal.expanded     = NO;
    return signal;
    }

@end
