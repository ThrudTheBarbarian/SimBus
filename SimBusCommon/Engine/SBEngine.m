//
//  SBEngine.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "SBEngine.h"
#import "SBNotifications.h"
#import "SBPluginController.h"
#import "SBPluginProtocol.h"
#import "SBSignal.h"
#import "SBValues.h"

@interface SBEngine()
// The list of plugins, in order
@property(strong, nonatomic) NSMutableArray<id<SBPlugin>> *           plugins;
@end

@implementation SBEngine

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _plugins = [NSMutableArray new];
        
        // Run through the plugins (which are loaded by now) and see if there
        // are any that provide a clk-src type signal. If so, load that plugin
        // into the engine
        NSNotificationCenter *nc    = NSNotificationCenter.defaultCenter;
        NSArray<Class> *list        = SBPluginController.sharedInstance.classes;
        for (Class klass in list)
            {
            id<SBPlugin>instance = [klass new];
            for (SBSignal *signal in instance.signals)
                if (signal.type == SIGNAL_CLOCK_SRC)
                    [nc postNotificationName:kAddItemNotification
                                      object:instance];
            }
        }
    return self;
    }
    
/*****************************************************************************\
|* Create the shared instance of the engine
\*****************************************************************************/
+ (instancetype) sharedInstance
    {
    static SBEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
        ^{
        engine = [SBEngine new];
        
        
        });
    return engine;
    }

/*****************************************************************************\
|* Add a plugin to the engine
\*****************************************************************************/
- (void) addPlugin:(id<SBPlugin>)plugin;
    {
    [_plugins addObject:plugin];
    
    [plugin setEngine:self];
    }

/*****************************************************************************\
|* Return a list of signals
\*****************************************************************************/
- (NSArray<SBSignal *> *) signals
    {
    NSMutableArray<SBSignal *> *signals = NSMutableArray.new;
    for (id<SBPlugin> plugin in _plugins)
        for (SBSignal *signal in plugin.signals)
            [signals addObject:signal];
    return signals;
    }
    
/*****************************************************************************\
|* Find the signal for a given name by iterating through the list
\*****************************************************************************/
- (nullable SBSignal *) signalForName:(NSString *)name
    {
    for (id<SBPlugin> plugin in _plugins)
        for (SBSignal *signal in plugin.signals)
            if ([name isEqualToString:signal.name])
                return signal;
    return nil;
    }

@end
