//
//  ColouredPath.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 28/12/2025.
//

#import <AppKit/Appkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColouredPath : NSObject

/*****************************************************************************\
|* Draw the path in the colour requested
\*****************************************************************************/
- (void) stroke;

#pragma mark - Properties


/*****************************************************************************\
|* Property: the actual path
\*****************************************************************************/
@property(strong, nonatomic) NSBezierPath *                         path;

/*****************************************************************************\
|* Property: the colour to draw it in
\*****************************************************************************/
@property(strong, nonatomic) NSColor *                              colour;

/*****************************************************************************\
|* Property: any text label, generally used for the value within a multibit
|* signal
\*****************************************************************************/
@property(strong, nonatomic) NSString *                             label;
@property(assign, nonatomic) CGRect                                 box;
@property(strong, nonatomic) NSFont *                               font;
@end

NS_ASSUME_NONNULL_END
