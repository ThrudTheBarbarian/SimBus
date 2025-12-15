//
//  SBEngine.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 14/12/2025.
//

#import "PluginProtocol.h"
#import "SBEngine.h"
#import "SBValues.h"

@interface SBEngine()
// The list of plugins, in order
@property(strong, nonatomic) NSMutableArray<id<Plugin>> *           plugins;
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
- (void) addPlugin:(id<Plugin>)plugin;
    {
    [_plugins addObject:plugin];
    
    [plugin setEngine:self];
    }
@end
