//
//  SignalsView.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 17/12/2025.
//

#import "SBNotifications.h"
#import "SignalsView.h"

@implementation SignalsView

/*****************************************************************************\
|* Initialisation
\*****************************************************************************/
- (instancetype) initWithCoder:(NSCoder *)coder
    {
    if (self = [super initWithCoder:coder])
        [self initialise];
    return self;
    }

- (instancetype) initWithFrame:(NSRect)frameRect
    {
    if (self = [super initWithFrame:frameRect])
        [self initialise];
    return self;
    }

/*****************************************************************************\
|* Class-specific initialisation
\*****************************************************************************/
- (void) initialise
    {
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self
           selector:@selector(_interfaceNeedsUpdate:)
               name:kInterfaceShouldUpdateNotification
             object:nil];
    }

- (void) dealloc
    {
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc removeObserver:self];
    }
    
/*****************************************************************************\
|* Draw the view
\*****************************************************************************/
- (void)drawRect:(NSRect)dirtyRect
    {
    [super drawRect:dirtyRect];
    
    [NSColor.blackColor setFill];
    NSRectFill(self.bounds);
    }


#pragma mark - Notifications

- (void) _interfaceNeedsUpdate:(NSNotification *)n
    {
    NSLog(@"info: %@", n.userInfo);
    }
@end
