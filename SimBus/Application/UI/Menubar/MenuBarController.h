//
//  MenuBarController.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuBarController : NSObject

/*****************************************************************************\
|* Toolbar item clicked: reset
\*****************************************************************************/
- (IBAction)resetButtonWasClicked:(id)sender;

/*****************************************************************************\
|* Toolbar item clicked: pause
\*****************************************************************************/
- (IBAction)pauseButtonWasClicked:(id)sender;

/*****************************************************************************\
|* Toolbar item clicked: run
\*****************************************************************************/
- (IBAction)runButtonWasClicked:(id)sender;

/*****************************************************************************\
|* Toolbar item clicked: add
\*****************************************************************************/
- (IBAction)addButtonWasClicked:(id)sender;


@end

NS_ASSUME_NONNULL_END
