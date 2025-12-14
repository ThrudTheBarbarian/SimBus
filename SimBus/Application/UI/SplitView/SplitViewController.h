//
//  SplitViewController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SplitViewController : NSObject <NSSplitViewDelegate>

/*****************************************************************************\
|* Constrain the minimum co-ordinate of a splitview pane on launch
\*****************************************************************************/
- (CGFloat)  splitView:(NSSplitView *) splitView
constrainMinCoordinate:(CGFloat) proposedMinimumPosition
           ofSubviewAt:(NSInteger) dividerIndex;

/*****************************************************************************\
|* Constrain the maximum co-ordinate of a splitview pane on launch
\*****************************************************************************/
- (CGFloat)  splitView:(NSSplitView *) splitView
constrainMaxCoordinate:(CGFloat) proposedMaximumPosition
           ofSubviewAt:(NSInteger) dividerIndex;

/*****************************************************************************\
|* Interactively check whether the co-ordinate is valid
\*****************************************************************************/
- (CGFloat) splitView:(NSSplitView *) splitView
constrainSplitPosition:(CGFloat) proposedPosition 
          ofSubviewAt:(NSInteger) dividerIndex;

/*****************************************************************************\
|* Handle constraints within a resize operation
\*****************************************************************************/
- (void)            splitView:(NSSplitView*)sv
    resizeSubviewsWithOldSize:(NSSize)oldSize;

/*****************************************************************************\
|* Decide whether a subview can be collapsed
\*****************************************************************************/
- (BOOL)  splitView:(NSSplitView *) splitView
 canCollapseSubview:(NSView *) subview;
 
@end

NS_ASSUME_NONNULL_END
