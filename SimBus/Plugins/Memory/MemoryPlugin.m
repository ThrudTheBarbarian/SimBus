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
                                                 type:SIGNAL_ADDRESS];
        [_signals addObject:sig];
        
        // Data bus
        sig             = [_engine makeSignalWithName:@"data"
                                              ofWidth:8
                                                 type:SIGNAL_DATA];
        [_signals addObject:sig];
        
        // R/W signal
        sig             = [_engine makeSignalWithName:@"R/W"
                                              ofWidth:1
                                                 type:SIGNAL_INPUT];
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
|* Tell the plugin we're about to run a simulation, so it can do any per-run
|* initialisation
\*****************************************************************************/
- (void) beginSimulation
    {}

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
|* Add events to be called this clock period in the simulation. The memory
|* plugin processes events asynchronously, and responds to any of the
|* signals {address, data, r/w} changing
|*
|* - if R/W is hi (R) then after <delay> ns, propagate mem[address] to data
|* - if R/W is lo (W) then after <delay> ns, read data to mem[address]
\*****************************************************************************/
- (void) addEventsTo:(NSMutableArray<SBEvent *> *)list
    {
    SBEvent *memIO      = [SBEvent onSignalChange:_signals];
    memIO.plugin        = self;
    [SBEngine.sharedInstance addAsynchronousListenerFor:memIO];
    }
    
/*****************************************************************************\
|* Tell the plugin to process the events that it previously added
\*****************************************************************************/
- (void) process:(SBEvent *)event
     withSignals:(NSArray<SBSignal *> *)signals
         persist:(BOOL)storeValues
    {
    NSLog(@"signal %@ changed from %02x to %02x",
        event.signal.name, (int) event.lastValue, (int) event.signal.currentValue);
    
    #if 0
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
    #endif
    }


@end
