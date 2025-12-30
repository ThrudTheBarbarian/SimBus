//
//  SignalsView.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 17/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>

#import "ColouredPath.h"
#import "Defines.h"
#import "SBNotifications.h"
#import "SignalExpansionController.h"
#import "SignalsView.h"

@interface SignalsView()

// Size of a half-period of the clock signal
@property(assign, nonatomic) int                            dT;

// Y-size of a signal
@property(assign, nonatomic) int                            dY;

// X-offset for drawing
@property(assign, nonatomic) int                            xOff;

// Y-offset due to scrolling
@property(assign, nonatomic) int                            yOff;

// How we control where we are looking at
@property(strong, nonatomic) IBOutlet NSSlider *            slider;

// The maximum range of the signals we could display
@property(assign, nonatomic) SBExtent                       range;

// Are we marking clocks or time
@property(assign, nonatomic) BOOL                           displayClocks;

// Direct methods
- (NSArray<ColouredPath *> *) _pathsFor1BitSignalAt:(int)y
                                              using:(SBSignal *)signal
                                             forBit:(uint32_t)bit
                                              __attribute__((objc_direct));

- (NSArray<ColouredPath *> *) _pathsForMultiBitSignalAt:(int)y
                                                  using:(SBSignal *)signal
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
             
    [nc addObserver:self
           selector:@selector(_interfaceNeedsUpdate:)
               name:kSignalExpansionNotification
             object:nil];
             
    [nc addObserver:self
           selector:@selector(_scrolled:)
               name:NSScrollViewDidLiveScrollNotification
             object:nil];
             
    _dT             = 20;
    _dY             = SIGNAL_VSPACE - 7;
    _displayClocks  = NO;
    _xOff           = 5;
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
    
    int Y = 48 - _yOff;
    SBEngine *engine = SBEngine.sharedInstance;
    SignalExpansionController *sep = SignalExpansionController.sharedInstance;
    
    for (id<SBPlugin> plugin in engine.plugins)
        {
        for (SBSignal *signal in plugin.signals)
            {
            NSArray<ColouredPath *> *paths;
            if (signal.width == 1)
                paths = [self _pathsFor1BitSignalAt:Y using:signal forBit:1];
            else
                {
                paths = [self _pathsForMultiBitSignalAt:Y using:signal];
                if ([sep isExpanded:signal])
                    Y += signal.width * SIGNAL_VSPACE;
                }
            
            for (ColouredPath *path in paths)
                [path stroke];
                
            Y += SIGNAL_VSPACE;
            }
        Y += MODULE_VSPACE;
        }
    }


#pragma mark - Direct methods

/*****************************************************************************\
|* Label for a string using the most appropriate unit
\*****************************************************************************/
- (NSString *)_labelForNs:(int64_t)ns
    {
    NSString *result = nil;
    
    if (ns < 1000)
        result = [NSString stringWithFormat:@"%lld ns", ns];
    else if ((ns < 1000000) && (ns % 1000 == 0))
        result = [NSString stringWithFormat:@"%lld us", ns / 1000];
    else if (ns < 1000000)
        result = [NSString stringWithFormat:@"%.3f us", (float)(ns) / 1000.0f];
    else if ((ns < 1000000000) && (ns % 1000000 == 0))
        result = [NSString stringWithFormat:@"%lld ms", ns / 1000000];
    else if ((ns < 1000000000) && (ns % 1000 == 0))
        result = [NSString stringWithFormat:@"%lld us", ns / 1000];
    else if (ns < 1000000000)
        result = [NSString stringWithFormat:@"%.6f ms", ns / 1000000.0f];
    else
        result = [NSString stringWithFormat:@"%f s", ns / 1000000000.0f];
        
    return result;
    }
    
/*****************************************************************************\
|* Create the path to draw for a 1-bit pattern
\*****************************************************************************/
- (NSArray<ColouredPath *> *) _pathsFor1BitSignalAt:(int)y
                                              using:(SBSignal *)signal
                                             forBit:(uint32_t)bit;
    {
    NSMutableArray<ColouredPath *> *paths = NSMutableArray.new;
    
    CGFloat period      = SBEngine.sharedInstance.period;
    float H             = self.frame.size.height;
    float W             = self.frame.size.width;

    // 'to' and 'from' are expressed as being in the range 0..1 and represent
    // a range where 1.0 maps to the last entry in the values array and 0.0
    // maps to the first entry.
    
    CGFloat from        = _slider.floatValue;
    int64_t minNS       = from * (_range.last - _range.first);
    
    NSInteger clocks    = 1 + W / (_dT * 2);
    int64_t maxNS       = minNS + clocks * period;
 
    float scale         = W / ((float)(maxNS - minNS));

    NSInteger num       = 0;
    NSInteger start     = 0;
    Value128 *data      = [signal.values subsetFrom:minNS
                                                 to:maxNS
                                              count:&num
                                                 at:&start];
    
    ColouredPath *path  = ColouredPath.new;
    path.colour         = signal.colour;
    if (num > 0)
        {
        // Move to the starting position
        [path.path moveToPoint:NSMakePoint(_xOff, H-y)];
        for (NSInteger x = 0; x < num; x++)
            {
            //int v = data->value;
            CGFloat px  = _xOff + (data->cron - minNS ) * scale;
            CGFloat py  = H - (y - _dY * data->value);
            [path.path lineToPoint:NSMakePoint(px,  py)];
            
            if (x < num-1)
                {
                data ++;
                CGFloat px2 = _xOff + (data->cron - minNS ) * scale;
                [path.path lineToPoint:NSMakePoint(px2, py)];
                }
            //NSLog(@"x:%5lld px:%5f py:%5f, val:%d", (int64_t)x, px, py, v);
            }
        }
    [paths addObject:path];
    return paths;
    }

/*****************************************************************************\
|* Create the path to draw for a multi-bit pattern
\*****************************************************************************/
- (NSArray<ColouredPath *> *) _pathsForMultiBitSignalAt:(int)y
                                                  using:(SBSignal *)signal
    {
    NSMutableArray<ColouredPath *> *paths = NSMutableArray.new;
    
    CGFloat period      = SBEngine.sharedInstance.period;
    CGFloat H           = self.frame.size.height;
    CGFloat W           = self.frame.size.width;
    NSInteger count     = signal.values.count;

    CGFloat from        = 0; //_slider.floatValue;
    CGFloat clocks      = (_range.last - _range.first) / period;
    
    float to            = from + W / (1 + clocks * _dT);
    if (to >= 1.0)
        to = 1.0;
        
    int64_t start      = (int64_t)(from * count);
    int64_t end        = (int64_t)(to * count) - 1;
    if (end < start)
        end = start;
        
    Value128 *data      = (Value128 *) (signal.values.data.bytes);
    ColouredPath *path  = ColouredPath.new;
    path.colour         = signal.colour;
    
    [path.path moveToPoint:NSMakePoint(0, H-y)];
    for (uint64_t x = start; x <= end; x++)
        {
        CGFloat px = (x-start) * _dT;
        CGFloat py = H - (y + _dY * data[x].value);
        [path.path lineToPoint:NSMakePoint(px, py)];
        [path.path lineToPoint:NSMakePoint(px+_dT, py)];
        }
        
    [paths addObject:path];
    return paths;
    }

/*****************************************************************************\
|* Draw the lines that form the horizontal scale.
\*****************************************************************************/
- (void) _displayHorizontalScale
    {
    SBEngine *engine = SBEngine.sharedInstance;
    
    SBSignal *clk       = [engine signalForType:SIGNAL_CLOCK_SRC];
    CGFloat period      = engine.period;
    CGFloat W           = self.frame.size.width;
    CGFloat H           = self.frame.size.height;
    
    CGFloat from        = _slider.floatValue;
    int64_t minNS       = from * (_range.last - _range.first);

    NSInteger clocks    = 1 + W / (_dT * 2);
    int64_t maxNS       = minNS + clocks * period;
    
    float scale         = W / ((float)(maxNS - minNS));

    NSInteger num       = 0;
    NSInteger start     = 0;
    Value128 * max      = clk.values.lastValue;
    Value128 *data      = [clk.values subsetFrom:minNS
                                              to:maxNS
                                           count:&num
                                              at:&start];
        
    NSColor *white              = [NSColor colorWithWhite:0.7 alpha:0.8];
    NSFont *font                = [NSFont systemFontOfSize:14];
    CGFloat lineHeight          = font.ascender
                                + ABS(font.descender)
                                + font.leading;
    NSDictionary *attribs       = @{NSFontAttributeName:font,
                                    NSForegroundColorAttributeName:white};
    CGFloat py                  = H - lineHeight - 3;
    NSString *lbl               = nil;


    if (num > 0)
        {
        // Find the first 'LO' value (ie: clock falling)
        while (data->value != 0)
            {
            data ++;
            minNS += period/2;
            maxNS += period/2;
            }
        
        // If start is not a multiple of 5, increment data until
        // we find a multiple of 5
        NSInteger remainder = start % 10;
        if (remainder != 0)
            data += (10-remainder);
            
        ColouredPath *path  = ColouredPath.new;
        path.colour         = white;

        for (NSInteger x = 0; x < num; x++)
            {
            CGFloat px  = _xOff + (data->cron - minNS ) * scale;
            CGPoint at  = CGPointMake(px+2, py);
            int64_t ck  = (int64_t)(data->cron / period);
            
            if (_displayClocks)
                lbl = [NSString stringWithFormat:@"%lld ck", ck];
            else
                lbl = [self _labelForNs:data->cron];
                
            [lbl drawAtPoint:at withAttributes:attribs];

            [path.path moveToPoint:NSMakePoint(px, 0)];
            [path.path lineToPoint:NSMakePoint(px, H)];
            
            // Values contain both LO and HI parts of the waveform,
            // so to count clock periods we need to jump by 2 at a time
            data +=2*5;
            if (data > max)
                break;
            CGFloat nx = (data->cron - minNS ) * scale;
            
            NSInteger current = x;
            while (nx - px < 160)
                {
                if (current >= num)
                    break;
                current ++;
                data +=2*5;
                nx = (data->cron - minNS ) * scale;
                }
            if (data > max)
                break;
            }
        [path stroke];
        }
    }

#pragma mark - Events

/*****************************************************************************\
|* The user scrolled the mouse wheel
\*****************************************************************************/
- (void) scrollWheel:(NSEvent *)e
    {
    if (e.scrollingDeltaY > 0)
        {
        if (_dT > 2)
            _dT /= 2;
        }
    else
        {
        if (_dT < 2048)
            _dT *= 2;
        }
    [self _interfaceNeedsUpdate:nil];
    }

/*****************************************************************************\
|* The user clicked in the view
\*****************************************************************************/
- (void) mouseDown:(NSEvent *)e
    {
    NSPoint p = [self convertPoint:e.locationInWindow fromView:nil];
    CGFloat H = self.frame.size.height;
    if (p.y > H - 20)
        {
        _displayClocks = !_displayClocks;
        [self setNeedsDisplay:YES];
        }
    }

#pragma mark - Notifications

/*****************************************************************************\
|* The user scrolled the collection view
\*****************************************************************************/
- (void) _scrolled:(NSNotification *)n
    {
    NSScrollView *scroll = n.object;
    _yOff = scroll.documentVisibleRect.origin.y;
    [self _interfaceNeedsUpdate:nil];
    }
    
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
