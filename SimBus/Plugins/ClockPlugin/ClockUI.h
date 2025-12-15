//
//  ClockUI.h
//  Clock
//
//  Created by ThrudTheBarbarian on 15/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ClockPlugin;

@interface ClockUI : NSViewController <NSTextFieldDelegate>

// Weak reference (the plugin retains us) to the plugin so we can
// transfer any changes back to it
@property (weak, nonatomic) ClockPlugin *                 plugin;

// weak reference (the popover retains us a viewcontroller) so we
// can call actions/methods on the popover
@property (weak, nonatomic) NSPopover *                   popover;
@end

NS_ASSUME_NONNULL_END
