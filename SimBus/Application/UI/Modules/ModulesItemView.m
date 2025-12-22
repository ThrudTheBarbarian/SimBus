//
//  ModulesItemView.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 12/12/2025.
//

#import "Box.h"
#import "Defines.h"
#import "SBSignal.h"
#import "ModulesItemView.h"

@interface ModulesItemView()

// The relationship mapping between the location and the signal
@property(strong, nonatomic) NSMutableDictionary<Box *, SBSignal*> *    map;

// The configuration button in the top right
@property(strong, nonatomic) IBOutlet NSButton *                        cfgBtn;

// The popover controller
@property(strong, nonatomic) IBOutlet NSPopover *                       popup;
@end

@implementation ModulesItemView

/*****************************************************************************\
|* Initialise the instance
\*****************************************************************************/
- (instancetype) initWithCoder:(NSCoder *)coder
    {
    if (self = [super initWithCoder:coder])
        {
        [self _initialise];
        }
    return self;
    }
    
- (instancetype) initWithFrame:(NSRect)frameRect
    {
    if (self = [super initWithFrame:frameRect])
        {
        [self _initialise];
        }
    return self;
    }
   
/*****************************************************************************\
|* Initialise the specific instance vars
\*****************************************************************************/
 - (void) _initialise
    {
    _map = [NSMutableDictionary new];
    }
    
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
                [NSColor colorWithCalibratedWhite:0.15 alpha:1.0], 0.0,
                [NSColor colorWithCalibratedWhite:0.55 alpha:1.0], 1.0,
                nil];
    [gradient drawFromPoint:NSMakePoint(x2, y2)
                    toPoint:NSMakePoint(x,y)
                    options:0];
    
    if (_plugin)
        {
        [_map removeAllObjects];
        NSTextField *tf = self.subviews[0];
        [tf sizeToFit];
        NSRect lbl = tf.frame;
        
        CGFloat x = lbl.origin.x;
        CGFloat y = lbl.origin.y;
        CGFloat w = lbl.size.width;
        
        CGFloat W = self.frame.size.width;
        
        // Draw a line underneath the text
        [NSColor.whiteColor set];
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
        NSArray<SBSignal *> * signals = _plugin.signals;
        CGFloat Y           = y-5;
        CGFloat lastY       = 0;
        CGFloat X           = x + 4;
        NSSize size         = NSMakeSize(SIGNAL_VSPACE, SIGNAL_VSPACE);
        
        for (SBSignal *signal in signals)
            {
            CGFloat triangle    = 0;
            attribs = @{NSForegroundColorAttributeName:signal.colour,
                        NSFontAttributeName:font};
            
            // Draw the text
            NSString *text  = signal.name;
            if (signal.width > 1)
                {
                text = [NSString stringWithFormat:@"%@ [%d]",
                                 signal.name, signal.width];
                triangle = SIGNAL_VSPACE;
                }
                
            CGRect textRect = [text boundingRectWithSize:maximumSize
                                                 options:opts
                                              attributes:attribs
                                                 context:nil];
            CGFloat tx = W -textRect.size.width - 8 - triangle;
            CGFloat ty = Y - textRect.size.height;
            [text drawAtPoint:CGPointMake(tx, ty) withAttributes:attribs];
            
            // Draw the line back to the group name
            lastY       = Y - textRect.size.height/2;
            [signal.colour set];
            
            path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(X, lastY)];
            [path lineToPoint:NSMakePoint(tx-3, lastY)];
            [path stroke];
            
            // If we have a triangle, draw it based on whether the plugin
            // is expanded or not
            if (triangle)
                {
                NSPoint p   = NSMakePoint(W-3-triangle, Y-SIGNAL_VSPACE+4);
                Box *box    = [Box boxAt:p size:size];
                _map[box]   = signal;
                
                [signal.colour setFill];
                NSBezierPath *tri = [box triangle:signal.expanded];
                [tri fill];
                }
            
            // If the signal is currently expanded, draw the individual labels
            if (signal.expanded)
                {
                CGFloat lastX = tx - 20;
                if (lastX < X)
                    lastX = X;
                
                path = [NSBezierPath bezierPath];
                for (int idx =0; idx<signal.width; idx++)
                    {
                    // Draw the text
                    Y -= SIGNAL_VSPACE;
                    NSString *stem  = signal.expandedStem
                                    ? signal.expandedStem
                                    : signal.name;
                    text = [NSString stringWithFormat:@"%@:%d", stem, idx];
                    textRect = [text boundingRectWithSize:maximumSize
                                                  options:opts
                                               attributes:attribs
                                                  context:nil];
                    tx = W - textRect.size.width - 4;
                    ty = Y - textRect.size.height;
                    [text drawAtPoint:CGPointMake(tx, ty)
                       withAttributes:attribs];
                       
                    // Draw the connecting lines
                    [path moveToPoint:NSMakePoint(lastX, lastY)];
                    
                    lastY = Y - textRect.size.height/2;
                    [path lineToPoint:NSMakePoint(lastX, lastY)];
                    [path lineToPoint:NSMakePoint(tx-4, lastY)];
                    }
                [path stroke];
                }
            Y -= SIGNAL_VSPACE;
            }
        
        [NSColor.whiteColor set];
        path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(X, y-1)];
        [path lineToPoint:NSMakePoint(X, lastY)];
        [path stroke];
        }
    }
        
/*****************************************************************************\
|* Handle the configuration button being clicked
\*****************************************************************************/
- (IBAction)configurationButtonClicked:(id)sender
    {
    if ([sender isKindOfClass:[NSButton class]])
        {
        NSButton *btn        = (NSButton *)sender;
        NSViewController *vc = [_plugin uiViewControllerForPopover:_popup];
        
        [_popup setContentViewController:vc];
        [_popup showRelativeToRect:[btn frame]
                            ofView:btn.superview
                     preferredEdge:NSMaxXEdge];
       }
    }

/*****************************************************************************\
|* We got a mouse-click
\*****************************************************************************/
- (void) mouseDown:(NSEvent *)e
    {
    NSPoint p 	= [self convertPoint:[e locationInWindow] fromView:nil];
    
    for (Box *box in _map)
        if ([box contains:p])
            {
            BOOL expanded       = _map[box].expanded;
            _map[box].expanded  = !expanded;
            
            NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
            [nc postNotificationName:kModulesReconfiguredNotification
                              object:self];
            }
    }
@end
