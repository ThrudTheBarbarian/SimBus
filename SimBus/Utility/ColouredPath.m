//
//  ColouredPath.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 28/12/2025.
//

#import "ColouredPath.h"

@implementation ColouredPath

/*****************************************************************************\
|* Initialise an instance
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _colour = [NSColor grayColor];
        _path   = [NSBezierPath bezierPath];
        _label  = nil;
        _font   = nil;
        }
    return self;
    }

/*****************************************************************************\
|* Draw the path in the colour requested
\*****************************************************************************/
- (void) stroke
    {
    [_colour setStroke];
    [_path stroke];
    if (_label != nil)
        {
        if (_font == nil)
            _font = [NSFont systemFontOfSize:14];
        
        NSDictionary *attribs = @{NSForegroundColorAttributeName:_colour,
                                  NSFontAttributeName:_font};

        [_label drawInRect:_box withAttributes:attribs];
        }
    }
@end
