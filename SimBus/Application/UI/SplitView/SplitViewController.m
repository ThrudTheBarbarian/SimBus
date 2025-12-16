//
//  SplitViewController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>
#import "SplitViewController.h"

#define MIN_X       200.0f
#define MAX_X       350.0f

@implementation SplitViewController


/*****************************************************************************\
|* Constrain the minimum co-ordinate of a splitview pane. Called at startup
\*****************************************************************************/
- (CGFloat)  splitView:(NSSplitView *) splitView
constrainMinCoordinate:(CGFloat) proposedMinimumPosition
           ofSubviewAt:(NSInteger) dividerIndex
    {
    return MIN_X;
    }

/*****************************************************************************\
|* Constrain the maximum co-ordinate of a splitview pane
\*****************************************************************************/
- (CGFloat)  splitView:(NSSplitView *) splitView
constrainMaxCoordinate:(CGFloat) proposedMaximumPosition
           ofSubviewAt:(NSInteger) dividerIndex
    {
    return MAX_X;
    }


/*****************************************************************************\
|* Decide whether a subview can be collapsed
\*****************************************************************************/
- (BOOL)  splitView:(NSSplitView *) splitView
 canCollapseSubview:(NSView *) subview;
    {
    return YES;
    }

/*****************************************************************************\
|* Interactively check whether the co-ordinate is valid
\*****************************************************************************/
- (CGFloat) splitView:(NSSplitView *) splitView
constrainSplitPosition:(CGFloat) proposedPosition 
          ofSubviewAt:(NSInteger) dividerIndex
    {
    if (proposedPosition < MIN_X)
        proposedPosition = MIN_X;
    if (proposedPosition > MAX_X)
        proposedPosition = MAX_X;
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kSignalsWidthChangedNotification
                      object:@(proposedPosition)];
    
    return proposedPosition;
    }

/*****************************************************************************\
|* Handle constraints within a resize operation
\*****************************************************************************/
- (void)            splitView:(NSSplitView*)sv
    resizeSubviewsWithOldSize:(NSSize)oldSize
    {
    // Use default resizing behavior from NSSplitView
    [sv adjustSubviews];
    NSView* view = sv.subviews.firstObject;
    
    // Force-apply constraints afterwards
    [sv setPosition:(sv.vertical ? view.frame.size.width
                                 : view.frame.size.height) ofDividerAtIndex:0];
    }


@end
