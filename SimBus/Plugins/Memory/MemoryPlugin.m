//
//  MemoryPlugin.m
//  Memory
//
//  Created by ThrudTheBarbarian on 22/12/2025.
//

#import "MemoryPlugin.h"
#import "MemoryUI.h"

#define PLUGIN_NAME         @"Memory map"

enum
    {
    MEM_READ = 0,
    MEM_WRITE,
    };

@interface MemoryPlugin()
@property (assign, nonatomic) int                               clk;
@property (strong, nonatomic) MemoryUI *                        vc;
@end


@implementation MemoryPlugin

/*****************************************************************************\
|* Initialise an instance of this plugin
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _signals        = [NSMutableArray new];
        _engine         = SBEngine.sharedInstance;
        _mem            = [NSMutableData dataWithCapacity:128*1024];
        
        uint8_t *mem    = _mem.mutableBytes;
        for (int i=0; i<65535; i++)
            mem[65535-i] = i & 0xFF;
            
        // Address bus
        SBSignal *sig   = [_engine makeSignalWithName:@"address"
                                              ofWidth:16
                                                 type:SIGNAL_ADDRESS
                                             expanded:NO];
        [_signals addObject:sig];
   
        
        // Data bus
        sig             = [_engine makeSignalWithName:@"data"
                                              ofWidth:8
                                                 type:SIGNAL_DATA
                                             expanded:NO];
        [_signals addObject:sig];
        
        // R/W signal
        sig             = [_engine makeSignalWithName:@"R/W"
                                              ofWidth:1
                                                 type:SIGNAL_INPUT
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

/*****************************************************************************\
|* Give the plugin a reference to the popover used for any configuration and
|* make it perform the open-popover configuration action
\*****************************************************************************/
- (NSViewController *)uiViewControllerForPopover:(NSPopover *)popover;
    {    
    // Create the view controller for the NSPopover if needed
    if (_vc == nil)
        {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _vc = [[MemoryUI alloc] initWithNibName:@"MemoryUI" bundle:bundle];
        [_vc setPlugin:self];
        [_vc view];
       }
        
    [popover setContentSize:NSMakeSize(319, 216)];
    [_vc setPopover:popover];
    return _vc;
    }

/*****************************************************************************\
|* Add events to be called this clock period in the simulation. The memory bus
|* has the following timings:
|*
|* - if R/W is hi (R) then read at 87% of the clock-cycle and update memory
|* - if R/W is lo (W) then write to Data bus at 73% of the clock-cycle
\*****************************************************************************/
- (void) addEventsTo:(NSMutableArray<SBEvent *> *)list
    {
    SBSignal *addr      = [_signals objectAtIndex:0];
    
    SBEvent *memRd      = [SBEvent beforeNextClockHi:0.13];
    memRd.signal        = addr;
    memRd.plugin        = self;
    memRd.tag           = MEM_READ;
    [list addObject:memRd];
    
    SBEvent *memWr      = [SBEvent beforeNextClockHi:0.27];
    memWr.signal        = addr;
    memWr.plugin        = self;
    memWr.tag           = MEM_WRITE;
    [list addObject:memWr];
    }
    
/*****************************************************************************\
|* Tell the plugin to process the events that it previously added
\*****************************************************************************/
- (void) process:(SBEvent *)event
     withSignals:(NSArray<SBSignal *> *)signals
         persist:(BOOL)storeValues
    {
    SBSignal *addr      = [_signals objectAtIndex:0];
    SBSignal *data      = [_signals objectAtIndex:1];
    SBSignal *rw        = [_signals objectAtIndex:2];
    
    if (event.tag == MEM_READ)
        {
        if (rw.currentValue == 1)
            {
            uint16_t address    = addr.currentValue;
            uint8_t *mem        = (uint8_t *) _mem.mutableBytes;
            
            [data update:mem[address]
                      at:event.when
               withFlags:SIGNAL_ASSERT
                 persist:storeValues];
            NSLog(@"read  0x%02llx at 0x%04x", data.currentValue, address);
            }
        }
    else if (event.tag == MEM_WRITE)
        {
        if (rw.currentValue == 0)
            {
            uint16_t address    = addr.currentValue;
            uint8_t *mem        = (uint8_t *) _mem.mutableBytes;
            mem[address]        = data.currentValue;
            NSLog(@"wrote 0x%02llx to 0x%04x", data.currentValue, address);
            }
        }
    }


@end
