//
//  SignalsView.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 17/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>

#import "Defines.h"
#import "SBNotifications.h"
#import "SignalsView.h"

@interface SignalsView()

// Size of a half-period of the clock signal
@property(assign, nonatomic) int                            dT;

// Y-size of a signal
@property(assign, nonatomic) int                            dY;

// How we control where we are looking at
@property(strong, nonatomic) IBOutlet NSSlider *            slider;

// The maximum range of the signals we could display
@property(assign, nonatomic) SBExtent                       range;

// Are we marking clocks or time
@property(assign, nonatomic) BOOL                           displayClocks;

// Direct methods
- (NSBezierPath *) _pathOf1BitSignalAt:(int)y using:(SBSignal *)signal
          __attribute__((objc_direct));

- (void) _displayHorizontalScale __attribute__((objc_direct));
@end

@implementation SignalsView

/*****************************************************************************\
|* Initialisation
\*****************************************************************************/
- (instancetype) initWithCoder:(NSCoder *)coder
    {
    if (self = [super initWithCoder:coder])
        [self initialise];
    return self;
    }

- (instancetype) initWithFrame:(NSRect)frameRect
    {
    if (self = [super initWithFrame:frameRect])
        [self initialise];
    return self;
    }

/*****************************************************************************\
|* Class-specific initialisation
\*****************************************************************************/
- (void) initialise
    {
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self
           selector:@selector(_interfaceNeedsUpdate:)
               name:kInterfaceShouldUpdateNotification
             object:nil];
             
    _dT             = 20;
    _dY             = SIGNAL_VSPACE - 7;
    _displayClocks  = YES;
    }

- (void) dealloc
    {
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc removeObserver:self];
    }
    
/*****************************************************************************\
|* Draw the view
\*****************************************************************************/
- (void)drawRect:(NSRect)dirtyRect
    {
    [super drawRect:dirtyRect];
    
    [NSColor.blackColor setFill];
    NSRectFill(self.bounds);
    
    // Show the scale
    [self _displayHorizontalScale];
    
    int Y = 31;
    SBEngine *engine = SBEngine.sharedInstance;
    for (id<SBPlugin> plugin in engine.plugins)
        {
        for (SBSignal *signal in plugin.signals)
            {
            NSBezierPath *path;
            [signal.colour set];
            
            if (signal.width == 1)
                {
                path = [self _pathOf1BitSignalAt:Y using:signal];
                [path stroke];
                }
            
            Y += SIGNAL_VSPACE;
            }
        Y += MODULE_VSPACE;
        }
    }


#pragma mark - Direct methods

/*****************************************************************************\
|* Create the path to draw for a 1-bit pattern
\*****************************************************************************/
- (NSBezierPath *) _pathOf1BitSignalAt:(int)y using:(SBSignal *)signal
    {
    CGFloat period      = SBEngine.sharedInstance.period;
    
    CGFloat H           = self.frame.size.height;
    CGFloat W           = self.frame.size.width;
    NSInteger count     = signal.values.count;

    CGFloat from        = _slider.floatValue;
    CGFloat clocks      = (_range.last - _range.first) / period;
    
    float to            = from + W / (1 + clocks * _dT);
    if (to >= 1.0)
        to = 1.0;
        
    int64_t start      = (int64_t)(from * count);
    int64_t end        = (int64_t)(to * count) - 1;
    if (end < start)
        end = start;
        
    Value128 *data      = (Value128 *) (signal.values.data.bytes);
    NSBezierPath *path  = NSBezierPath.new;
    [path moveToPoint:NSMakePoint(0, H-y)];
    
    for (uint64_t x = start; x <= end; x++)
        {
        CGFloat px = (x-start) * _dT;
        CGFloat py = H - (y + _dY * data[x].value);
        [path lineToPoint:NSMakePoint(px, py)];
        [path lineToPoint:NSMakePoint(px+_dT, py)];
        //NSLog(@"x:%5lld px:%5f py:%5f", x, px, py);
        }
        
    return path;
    }

/*****************************************************************************\
|* Draw the lines that form the horizontal scale.
\*****************************************************************************/
- (void) _displayHorizontalScale
    {
    SBEngine *engine = SBEngine.sharedInstance;
    
    if (_displayClocks)
        {
        SBSignal *clk       = [engine signalForType:SIGNAL_CLOCK_SRC];
        CGFloat period      = engine.period;
        CGFloat W           = self.frame.size.width;
        CGFloat H           = self.frame.size.height;
        CGFloat from        = _slider.floatValue;
        CGFloat clocks      = (_range.last - _range.first) / period;
        NSInteger count     = clk.values.count;
    
        float to            = from + W / (1 + clocks * _dT);
        if (to >= 1.0)
            to = 1.0;

        int64_t start      = (int64_t)(from * count);
        int64_t end        = (int64_t)(to * count) - 1;
        if (end < start)
            end = start;
        
        NSBezierPath *path          = NSBezierPath.new;
        NSColor *white              = [NSColor colorWithWhite:0.7 alpha:0.8];
        NSFont *font                = [NSFont systemFontOfSize:14];
        CGFloat lineHeight          = font.ascender + ABS(font.descender) + font.leading;
        NSDictionary *attribs       = @{NSFontAttributeName:font,
                                        NSForegroundColorAttributeName:white};
        CGFloat py                  = H - lineHeight - 3;
        NSString *lbl               = nil;
        
        for (int64_t x = start-10 ; x <= end; x++)
            {
            if (x%10 == 0)
                {
                CGFloat px  = (x-start) * _dT;
                CGPoint at  = CGPointMake(px+2, py);
                lbl         = [NSString stringWithFormat:@"%llu ck", x/2];
                
                [lbl drawAtPoint:at withAttributes:attribs];
                
                [path moveToPoint:NSMakePoint(px, 0)];
                [path lineToPoint:NSMakePoint(px, H)];
                }
            }
        [path stroke];
        }
    }

#pragma mark - Notifications

/*****************************************************************************\
|* The UI should be updated
\*****************************************************************************/
- (void) _interfaceNeedsUpdate:(NSNotification *)n
    {
    SBEngine *engine    = SBEngine.sharedInstance;

    // Find the extents of the signals in each plugin
    _range = SBMakeExtent(UINT64_MAX,0);
    
    int64_t maxCount  = 0;
    
    for (id<SBPlugin> plugin in engine.plugins)
        {
        for (SBSignal *signal in plugin.signals)
            {
            SBExtent extent = signal.extent;
            if (_range.first > extent.first)
                _range.first = extent.first;
            if (_range.last < extent.last)
                _range.last = extent.last;
            
            if (signal.values.count > maxCount)
                maxCount = signal.values.count;
            }
        }
    
    // Make the slider end-position match up
    CGFloat W           = self.frame.size.width;
    CGFloat width       = maxCount * _dT;
    CGFloat maxFrac     = 1.0 - W / width;
    if (maxFrac < 0.0f)
        maxFrac = 0.0f;
    if (maxFrac > 1.0f)
        maxFrac = 1.0f;
    [_slider setMaxValue:maxFrac];
    
    [self setNeedsDisplay:YES];
    }

#pragma mark - Actions

- (IBAction)sliderChanged:(id)sender
    {
    [self setNeedsDisplay:YES];
    }
@end
