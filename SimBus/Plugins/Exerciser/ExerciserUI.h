//
//  ExerciserUI.h
//  Exerciser
//
//  Created by ThrudTheBarbarian on 29/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ExerciserPlugin;

@interface ExerciserUI : NSViewController

#pragma mark - Properties

/*****************************************************************************\
|* Property: Weak reference (the plugin retains us) to the plugin so we can
|* transfer any changes back to it
\*****************************************************************************/
@property (weak, nonatomic) ExerciserPlugin *               plugin;

/*****************************************************************************\
|* Property: weak reference (the popover retains us a viewcontroller) so we
|* can call actions/methods on the popover
\*****************************************************************************/
@property (weak, nonatomic) NSPopover *                     popover;


@end

NS_ASSUME_NONNULL_END
