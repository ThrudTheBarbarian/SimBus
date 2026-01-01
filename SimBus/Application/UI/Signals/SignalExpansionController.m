//
//  SignalExpansionController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 28/12/2025.
//

#import "SignalExpansionController.h"

@interface SignalExpansionController()
/*****************************************************************************\
|* Property: Whether a given signal in this view is expanded, each key of
|* signal.identifier will be 0|1
\*****************************************************************************/
@property(strong, nonatomic)
NSMutableDictionary<NSString *, NSNumber *> *                       expanded;
@end

@implementation SignalExpansionController

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _expanded = NSMutableDictionary.new;
        }
    return self;
    }
    
/*****************************************************************************\
|* Return a shared instance
\*****************************************************************************/
+ (instancetype) sharedInstance
    {
    static dispatch_once_t onceToken;
    static SignalExpansionController *instance = nil;
    dispatch_once(&onceToken,
        ^{
        instance = SignalExpansionController.new;
        });
        
    return instance;
    }

/*****************************************************************************\
|* Clear the current mappings
\*****************************************************************************/
- (void) reset
    {
    [_expanded removeAllObjects];
    }
    
/*****************************************************************************\
|* Return whether a signal is expanded or not
\*****************************************************************************/
- (BOOL) isExpanded:(SBSignal *)signal inPlugin:(nonnull id<SBPlugin>)plugin
    {
    NSString *key = [NSString stringWithFormat:@"%@:%d",
                    plugin.pluginName, signal.identifier];
    return [(NSNumber *)(_expanded[key]) boolValue];
    }

/*****************************************************************************\
|* Expand a signal
\*****************************************************************************/
- (void) expandSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin
    {
    NSString *key = [NSString stringWithFormat:@"%@:%d",
                    plugin.pluginName, signal.identifier];

    _expanded[key] = @(1);
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kSignalExpansionNotification
                      object:self
                    userInfo:@{
                            @"key"      : key,
                            @"state"    : @(1)
                            }];
    }
        

/*****************************************************************************\
|* Unexpand a signal
\*****************************************************************************/
- (void) unexpandSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin
    {
    NSString *key = [NSString stringWithFormat:@"%@:%d",
                    plugin.pluginName, signal.identifier];

    _expanded[key] = @(0);
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kSignalExpansionNotification
                      object:self
                    userInfo:@{
                            @"key"      : key,
                            @"state"    : @(0)
                            }];
    }


/*****************************************************************************\
|* Toggle a signal's expansion state
\*****************************************************************************/
- (void) toggleSignal:(SBSignal *)signal inPlugin:(id<SBPlugin>)plugin
    {
    if ([self isExpanded:signal inPlugin:plugin])
        [self unexpandSignal:signal inPlugin:plugin];
    else
        [self expandSignal:signal inPlugin:plugin];
    }
    

@end
