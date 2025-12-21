//
//  SBSignal.m
//  Common
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "SBSignal.h"
#import "SBValues.h"

@implementation SBSignal

/*****************************************************************************\
|* Convenience initialisers
\*****************************************************************************/
+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                     type:(SignalType)type
                 expanded:(BOOL)expanded
    {
    SBSignal *signal    = [SBSignal _create:name ofType:type andWidth:width];
    signal.expanded     = expanded;
    return signal;
    }



+ (instancetype) withName:(NSString *)name
                    width:(uint32_t)width
                  andType:(SignalType)type;
    {
    SBSignal *signal    = [SBSignal _create:name ofType:type andWidth:width];
    signal.expanded     = NO;
    return signal;
    }

+ (instancetype) withName:(NSString *)name andType:(SignalType)type
    {
    SBSignal *signal    = [SBSignal _create:name ofType:type andWidth:1];
    signal.expanded     = NO;
    return signal;
    }

+ (SBSignal *) _create:(NSString *)name
                ofType:(SignalType)type
              andWidth:(int)width
    {
    SBSignal *signal    = SBSignal.new;
    signal.values       = SBValues.new;
    signal.name         = name;
    signal.width        = width;
    signal.type         = type;

    return signal;
    }
    
/*****************************************************************************\
|* Reset the values to an empty state
\*****************************************************************************/
- (void) resetValues
    {
    [_values clear];
    _hiCount        = 0;
    _loCount        = 0;
    _changeCount    = 0;
    }

/*****************************************************************************\
|* Return the extent (start, end) of the signal in terms of time (cron)
\*****************************************************************************/
- (SBExtent) extent
    {
    if (_values.count > 0)
        {
        uint64_t first = _values.firstTimestamp;
        uint64_t last  = _values.currentTimestamp;
        
        return SBMakeExtent(first, last);
        }
    return SBMakeExtent(0,0);
    }

/*****************************************************************************\
|* Change a value
\*****************************************************************************/
- (void) update:(uint32_t)value
             at:(uint64_t)cron
      withFlags:(int)flags
        persist:(BOOL)storeData;
    {
    _currentValue = value;
    if (value > 0)
        _hiCount ++;
    else
        _loCount ++;
    _changeCount ++;

    if (storeData)
        {
        Value128 datum =
            {
            .value  = value,
            .cron   = cron,
            .flags  = flags
            };
        [_values append:datum];
        }
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
