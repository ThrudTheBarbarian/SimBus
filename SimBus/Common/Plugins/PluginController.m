//
//  PluginController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "PluginController.h"
#import "PluginProtocol.h"

@interface PluginController()
@end

@implementation PluginController


/*****************************************************************************\
|* Make this a singleton
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _classes = NSMutableArray.new;
        }
    return self;
    }
    
+ (instancetype) sharedInstance
    {
    static dispatch_once_t onceToken;
    static PluginController *instance = nil;
    
    dispatch_once(&onceToken,
        ^{
        instance = PluginController.new;
        });
        
    return instance;
    }


/*****************************************************************************\
|* Load all the plugins
\*****************************************************************************/
- (void) loadPlugins
	{
	/**********************************************************************\
	|* Register and load all the plugins
	\**********************************************************************/	
	NSString* path = [[NSBundle mainBundle] builtInPlugInsPath];
	//NSLog(@"Looking in %@ for plugins", path);
	
	if (path)
		{
		NSArray *list = [NSBundle pathsForResourcesOfType:@"sb"
                                              inDirectory:path];
		for (NSString *plugin in list)
			{
			//NSLog(@"Activating: %@", plugin);
			[self _activatePluginBundle:plugin];
			}
		}	
	}

	
/******************************************************************************\
|* Activate a bundle 
\******************************************************************************/
- (void) _activatePluginBundle:(NSString *)path
	{
    NSBundle* pBundle = [NSBundle bundleWithPath:path];

	if (pBundle) 
        {
        NSDictionary* pDict = [pBundle infoDictionary];
		NSString *pName = [pDict objectForKey:@"NSPrincipalClass"];
		if (pName)
            {
			Class pClass = [pBundle principalClass];
			if ([pClass conformsToProtocol:@protocol(Plugin)])
                [_classes addObject:pClass];
            else
                NSLog(@"Class %@ does not conform to plugin protocol", pName);
            }
        else
            NSLog(@"Cannot find NSPrincipalClass in bundle %@", path);
        }
    else
        NSLog(@"Cannot form bundle for %@", path);
	}

@end
