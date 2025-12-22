//
//  PluginController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#include <stdlib.h>
#include <stdio.h>    
#include <pwd.h>
#include <unistd.h>

#import "SBPluginController.h"
#import "SBPluginProtocol.h"

#define APP_NAME    @"SimBus"
#define PLUGIN_FMT  @"%@/Library/Application Support/%@/Plugins"

@implementation SBPluginController


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
    static SBPluginController *instance = nil;
    
    dispatch_once(&onceToken,
        ^{
        instance = SBPluginController.new;
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
    [self _loadPluginsAt:path];
 
    NSString *home = nil;
    struct passwd* pwd = getpwuid(getuid());
    if (pwd)
        {
        char *homeDir   = pwd->pw_dir;
        home            = [NSString stringWithUTF8String:homeDir];
        }
        
    path = [NSString stringWithFormat:PLUGIN_FMT, home, APP_NAME];
    [self _loadPluginsAt:path];
	}

	
/******************************************************************************\
|* Load plugins found at a specified path
\******************************************************************************/
- (void) _loadPluginsAt:(NSString *)path
    {
	NSLog(@"Looking in %@ for plugins", path);
	
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
			if ([pClass conformsToProtocol:@protocol(SBPlugin)])
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
