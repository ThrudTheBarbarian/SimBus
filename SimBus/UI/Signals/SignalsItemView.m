//
//  SignalsItemView.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import "SignalsItemView.h"

@implementation SignalsItemView

/*****************************************************************************\
|* Draw the background
\*****************************************************************************/
- (void)drawRect:(NSRect)dirtyRect
    {
    NSRect b    = self.bounds;
    float x     = 5;
    float y     = 5;
    float x2    = b.size.width;
    float y2    = b.size.height;
    float r     = 15;
    
    [NSColor.clearColor setFill];
    NSRectFill(b);

//    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x, y, x2-x, y2-y) xRadius:15 yRadius:15];
    NSBezierPath *path = NSBezierPath.new;
    [path moveToPoint:CGPointMake(x+r, y)];
    [path lineToPoint:CGPointMake(x2, y)];
    [path lineToPoint:CGPointMake(x2, y2)];
    [path lineToPoint:CGPointMake(x+r, y2)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(x+r, y2 - r)
                  radius:r
              startAngle:270
                endAngle:180];
    [path lineToPoint:CGPointMake(x, y+r)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(x+r, y+r)
                  radius:r
              startAngle:180
                endAngle:90];
   
    [path setClip];
    NSGradient *gradient =
        [[NSGradient alloc]
            initWithColorsAndLocations:
                [NSColor colorWithCalibratedWhite:0.55 alpha:1.0], 0.0,
                [NSColor colorWithCalibratedWhite:0.85 alpha:1.0], 1.0,
                nil];
    [gradient drawFromPoint:NSMakePoint(x2, y2)
                    toPoint:NSMakePoint(x,y)
                    options:0];
    }
    
@end
