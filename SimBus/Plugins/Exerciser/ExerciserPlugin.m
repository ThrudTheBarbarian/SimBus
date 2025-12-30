//
//  ExerciserPlugin.m
//  Exerciser
//
//  Created by ThrudTheBarbarian on 29/12/2025.
//

#define PLUGIN_NAME         @"Bus exerciser"

#import "ExerciserPlugin.h"
#import "ExerciserUI.h"

typedef enum
    {
    STATE_DELAY     = 0,
    STATE_ACTION,
    } State;

enum
    {
    OP_ADDRESS = 0,
    OP_READ_RW,
    OP_WRITE_RW,
    OP_WRITE_DATA,
    OP_WRITE_DATA_INVALID
    };
    
@interface ExerciserPlugin()

// Current iteration count
@property (assign, nonatomic) int                               iters;

// Current state
@property (assign, nonatomic) State                             state;

// Current address
@property (assign, nonatomic) uint32_t                          address;

// Current write-value
@property (assign, nonatomic) uint32_t                          toWrite;

// How many clocks we have left to wait before starting the actions
@property (assign, nonatomic) NSInteger                         wait;

// The view controller for the configuration UI
@property (strong, nonatomic) ExerciserUI *                     vc;
@end

@implementation ExerciserPlugin

/*****************************************************************************\
|* Initialise an instance of this plugin
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _signals        = [NSMutableArray new];
        _engine         = SBEngine.sharedInstance;
        
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
 
        _type       = OP_WRITE;
        _addrStart  = 0x1000;
        _addrIncr   = 0x3;
        _opCount    = 32;
        _writeValue = 0x10;
        _writeIncr  = 0x2;
        _delay      = 0;
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
        _vc = [[ExerciserUI alloc] initWithNibName:@"ExerciserUI" bundle:bundle];
        [_vc setPlugin:self];
        [_vc view];
       }
        
    [popover setContentSize:NSMakeSize(349, 341)];
    [_vc setPopover:popover];
    return _vc;
    }

/*****************************************************************************\
|* Tell the plugin we're about to run a simulation, so it can do any per-run
|* initialisation
\*****************************************************************************/
- (void) beginSimulation
    {
    if (_delay == 0)
        _state  = STATE_ACTION;
    else
        {
        _state  = STATE_DELAY;
        _wait   = _delay;
        }
        
    _iters      = _opCount;
    _address    = _addrStart;
    _toWrite    = _writeValue;
    }


/*****************************************************************************\
|* Add events to be called this clock period in the simulation.
|*
|* This is a state-machine dependent on the UI configuration
\*****************************************************************************/
- (void) addEventsTo:(NSMutableArray<SBEvent *> *)list
    {
    switch (_state)
        {
        /*********************************************************************\
        |* Wait for the required number of clocks before doing anything
        \*********************************************************************/
        case STATE_DELAY:
            _wait --;
            if (_wait == 0)
                _state = STATE_ACTION;
            break;
        
        /*********************************************************************\
        |* Start creating events of the correct type that describe the address
        |* and r/w state on the bus. The memory plugin should then correctly
        |* drive/update data
        \*********************************************************************/
        case STATE_ACTION:
            if (_type == OP_READ)
                {
                // Address changes and R/W goes high at 0.3 of the clock period,
                // or 0.2 periods prior to the next falling clock event
                SBSignal *addr      = [_signals objectAtIndex:0];
                SBSignal *rw        = [_signals objectAtIndex:2];
                
                SBEvent *e          = [SBEvent beforeNextClockHi:0.35];
                e.signal            = addr;
                e.plugin            = self;
                e.tag               = OP_ADDRESS;
                [list addObject:e];
                
                e                   = [SBEvent beforeNextClockHi:0.35];
                e.signal            = rw;
                e.plugin            = self;
                e.tag               = OP_READ_RW;
                [list addObject:e];
                }
            else
                {
                SBSignal *addr      = [_signals objectAtIndex:0];
                SBSignal *data      = [_signals objectAtIndex:1];
                SBSignal *rw        = [_signals objectAtIndex:2];
                
                SBEvent *e          = [SBEvent beforeNextClockHi:0.35];
                e.signal            = addr;
                e.plugin            = self;
                e.tag               = OP_ADDRESS;
                [list addObject:e];
                
                e                   = [SBEvent beforeNextClockHi:0.35];
                e.signal            = rw;
                e.plugin            = self;
                e.tag               = OP_WRITE_RW;
                [list addObject:e];
                
                e                   = [SBEvent afterNextClockHi:0.05];
                e.signal            = data;
                e.plugin            = self;
                e.tag               = OP_WRITE_DATA;
                [list addObject:e];
                
                e                   = [SBEvent afterNextClockLo:0.1];
                e.signal            = data;
                e.plugin            = self;
                e.tag               = OP_WRITE_DATA_INVALID;
                [list addObject:e];
                }
            break;
        }
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

    switch (event.tag)
        {
        case OP_ADDRESS:
            [addr update:_address
                      at:event.when
               withFlags:SIGNAL_ASSERT
                 persist:storeValues];
            _address += _addrIncr;
           break;
        
        case OP_READ_RW:
            [rw update:1
                    at:event.when
             withFlags:SIGNAL_ASSERT
               persist:storeValues];
            break;
        
        case OP_WRITE_RW:
            [rw update:0
                    at:event.when
             withFlags:SIGNAL_ASSERT
               persist:storeValues];
            break;
        
        case OP_WRITE_DATA:
            [data update:_toWrite
                      at:event.when
               withFlags:SIGNAL_ASSERT
                 persist:storeValues];
            _toWrite += _writeIncr;
            break;
        
        case OP_WRITE_DATA_INVALID:
            [data update:-1
                      at:event.when
               withFlags:SIGNAL_UNDEFINED
                 persist:storeValues];
            break;
        
        default:
            NSLog(@"Unknown state for event.tag");
            break;
        }
    
    }
    
@end
