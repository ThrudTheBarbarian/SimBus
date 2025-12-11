//
//  ClockPlugin.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Common/Common.h>

#import "ClockPlugin.h"

@interface ClockPlugin()
@property (assign, nonatomic) int                      clk;
@end

@implementation ClockPlugin

/*****************************************************************************\
|* Initialise an instance of this plugin
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _clk = 1;
        }
    return self;
    }
    
/*****************************************************************************\
|* Return a list of signals of interest to this plugin
\*****************************************************************************/
- (NSArray<BusSignal *> *) signals
    {
    return @[
            [BusSignal withName:@"clk" andType:SIGNAL_CLOCK_SRC]
            ];
    }

@end
