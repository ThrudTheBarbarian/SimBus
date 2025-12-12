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
    
    if (_plugin)
        {
        NSTextField *tf = self.subviews[0];
        [tf sizeToFit];
        NSRect lbl = tf.frame;
        
        CGFloat x = lbl.origin.x;
        CGFloat y = lbl.origin.y;
        CGFloat w = lbl.size.width;
        
        CGFloat W = self.frame.size.width;
        
        // Draw a line underneath the text
        [NSColor.blackColor set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(x, y-1)];
        [path lineToPoint:NSMakePoint(x+w, y-1)];
        [path stroke];
        
        // Get the font to use for the text
        NSFont *font                = [NSFont systemFontOfSize:14];
        NSDictionary *attribs       = @{NSFontAttributeName:font};
        CGSize maximumSize          = CGSizeMake(300.0, CGFLOAT_MAX);
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin
                                    | NSStringDrawingUsesFontLeading;
                                    
        // For each signal, get the colour for that signal and draw
        // a line up to the name of the signal
        NSArray<BusSignal *> * signals = _plugin.signals;
        CGFloat Y       = y;
        CGFloat lastY   = 0;
        CGFloat X       = x + 4;
        
        for (BusSignal *signal in signals)
            {
            attribs = @{NSForegroundColorAttributeName:signal.defaultColour,
                        NSFontAttributeName:font};
            
            // Draw the text
            NSString *text  = signal.name;
            CGRect textRect = [text boundingRectWithSize:maximumSize
                                                 options:opts
                                              attributes:attribs
                                                 context:nil];
            CGFloat tx = W -textRect.size.width - 4;
            CGFloat ty = Y - textRect.size.height;
            [text drawAtPoint:CGPointMake(tx, ty) withAttributes:attribs];
            
            // Draw the line back to the group name
            lastY       = Y - textRect.size.height/2;
            [signal.defaultColour set];
            
            path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(X, lastY)];
            [path lineToPoint:NSMakePoint(tx-3, lastY)];
            [path stroke];
            
            Y += 15;
            }
        
        [NSColor.blackColor set];
        path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(X, y-1)];
        [path lineToPoint:NSMakePoint(X, lastY)];
        [path stroke];
        }
    }
    
@end
