//
//  ClockPlugin.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Common/Common.h>
#import "ClockPlugin.h"

#define PLUGIN_NAME         @"Clock source"

@interface ClockPlugin()
@property (assign, nonatomic) int                               clk;
@end

@implementation ClockPlugin

/*****************************************************************************\
|* Initialise an instance of this plugin
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _clk        = 1;
        _signals    = [NSMutableArray new];
        
        BusSignal *sig = [BusSignal withName:@"clk.src"
                                          width:1
                                           type:SIGNAL_CLOCK_SRC
                                       expanded:NO];
        [_signals addObject:sig];
        }
    return self;
    }

/*****************************************************************************\
|* Return the name to use for this plugin
\*****************************************************************************/
+ (NSString *) pluginName
    {
    return PLUGIN_NAME;
    }

/*****************************************************************************\
|* Return the name to use for this plugin
\*****************************************************************************/
- (NSString *) pluginName
    {
    return PLUGIN_NAME;
    }


@end
