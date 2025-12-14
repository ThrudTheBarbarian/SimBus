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
       
        sig = [BusSignal withName:@"clk.sink"
                                          width:1
                                           type:SIGNAL_CLOCK_SINK
                                       expanded:NO];
        [_signals addObject:sig];
       
        sig = [BusSignal withName:@"address"
                                          width:16
                                           type:SIGNAL_ADDRESS
                                       expanded:NO];
        [_signals addObject:sig];
        sig = [BusSignal withName:@"data"
                                          width:8
                                           type:SIGNAL_DATA
                                       expanded:NO];
        sig.expandedStem = @"D";
        [_signals addObject:sig];
       
          sig = [BusSignal withName:@"bus"
                                          width:1
                                           type:SIGNAL_BUS
                                       expanded:NO];
        [_signals addObject:sig];
        sig = [BusSignal withName:@"input"
                                          width:1
                                           type:SIGNAL_INPUT
                                       expanded:NO];
        [_signals addObject:sig];
        sig = [BusSignal withName:@"output"
                                          width:1
                                           type:SIGNAL_OUTPUT
                                       expanded:NO];
        [_signals addObject:sig];
       
        sig = [BusSignal withName:@"io"
                                          width:1
                                           type:SIGNAL_IO
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
