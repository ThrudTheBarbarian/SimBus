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
NSMutableDictionary<NSNumber *, NSNumber *> *                       expanded;
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
- (BOOL) isExpandedByIdentifer:(NSNumber *)sid
    {
    return [(NSNumber *)(_expanded[sid]) boolValue];
    }
    
- (BOOL) isExpanded:(SBSignal *)signal
    {
    return [self isExpandedByIdentifer:signal.identifier];
    }

/*****************************************************************************\
|* Expand a signal
\*****************************************************************************/
- (void) expandSignalByIdentifier:(NSNumber *)signalIdentifier
    {
    _expanded[signalIdentifier] = @(1);
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kSignalExpansionNotification
                      object:self
                    userInfo:@{
                            @"identifier" : signalIdentifier,
                            @"state"      : @(1)
                            }];
    }
    
- (void) expandSignal:(SBSignal *)signal
    {
    [self expandSignalByIdentifier:signal.identifier];
    }
    

/*****************************************************************************\
|* Unexpand a signal
\*****************************************************************************/
- (void) unexpandSignalByIdentifier:(NSNumber *)signalIdentifier
    {
    _expanded[signalIdentifier] = @(0);
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kSignalExpansionNotification
                      object:self
                    userInfo:@{
                            @"identifier" : signalIdentifier,
                            @"state"      : @(0)
                            }];
    }

- (void) unexpandSignal:(SBSignal *)signal;
    {
    [self unexpandSignalByIdentifier:signal.identifier];
    }

/*****************************************************************************\
|* Toggle a signal's expansion state
\*****************************************************************************/
- (void) toggleSignalByIdentifier:(NSNumber *)signalIdentifier
    {
    if ([self isExpandedByIdentifer:signalIdentifier])
        [self unexpandSignalByIdentifier:signalIdentifier];
    else
        [self expandSignalByIdentifier:signalIdentifier];
    }
    
- (void) toggleSignal:(SBSignal *)signal
    {
    [self toggleSignalByIdentifier:signal.identifier];
    }


@end
