//
//  SettingsViewController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 15/12/2025.
//

#import <Cocoa/Cocoa.h>
#import <Common/Common.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : NSViewController

/*****************************************************************************\
|* Populate the signals into the UI
\*****************************************************************************/
- (void)populateFields;

// Link to the popup so we can terminate it
@property (weak, nonatomic) NSPopover *                    popover;
@end

NS_ASSUME_NONNULL_END
