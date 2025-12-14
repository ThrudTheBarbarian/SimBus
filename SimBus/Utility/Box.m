//
//  Box.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 13/12/2025.
//

#import "Box.h"

@implementation Box

/*****************************************************************************\
|* Convenience initialiser
\*****************************************************************************/
+ (instancetype) boxAt:(NSPoint)topLeft size:(NSSize)size
    {
    Box *box = Box.new;
    box.x   = topLeft.x;
    box.y   = topLeft.y;
    box.w   = size.width;
    box.h   = size.height;
    return box;
    }

/*****************************************************************************\
|* Is a point inside the box
\*****************************************************************************/
- (BOOL) contains:(NSPoint)p
    {
    if ((_x <= p.x) && (_x + _w >= p.x))
        if ((_y <= p.y) && (_y + _h >= p.y))
            return YES;
    return NO;
    }


/*****************************************************************************\
|* Return as an NSRect
\*****************************************************************************/
- (NSRect) asRect
    {
    return NSMakeRect(_x, _y, _w, _h);
    }

/*****************************************************************************\
|* Return a path for a triangle within, facing up or down
\*****************************************************************************/
- (NSBezierPath *) triangle:(BOOL)facingUp
    {
    #define INSET 6
    NSBezierPath *path = [NSBezierPath new];
    if (facingUp)
        {
        [path moveToPoint:NSMakePoint(_x+INSET, _y + INSET)];
        [path lineToPoint:NSMakePoint(_x + _w - INSET, _y + INSET)];
        [path lineToPoint:NSMakePoint(_x + _w/2, _y + _h - INSET)];
        [path closePath];
        }
    else
        {
        [path moveToPoint:NSMakePoint(_x+INSET, _y + _h - INSET)];
        [path lineToPoint:NSMakePoint(_x + _w - INSET, _y + _h - INSET)];
        [path lineToPoint:NSMakePoint(_x + _w/2, _y + INSET)];
        [path closePath];
        }
    return path;
    }

#pragma mark - NSCopying

/*****************************************************************************\
|* Copy a box
\*****************************************************************************/
- (id) copyWithZone:(NSZone *)zone
    {
    Box *box = Box.new;
    box.x = _x;
    box.y = _y;
    box.w = _w;
    box.h = _h;
    return box;
    }


#pragma mark - NSDictionary requirements

/*****************************************************************************\
|* Does this box equal another
\*****************************************************************************/
- (BOOL) isEqual:(id)object
    {
    if ([object isKindOfClass:[Box class]])
        {
        Box *box = (Box *)object;
        if ((box.x == _x) && (box.y == _y) && (box.w == _w) && (box.h == _h))
            return YES;
        }
    return NO;
    }
  
/*****************************************************************************\
|* Do a hash based on the x,y,w,h
\*****************************************************************************/
- (NSUInteger) hash
    {
    NSString *info = [NSString stringWithFormat:@"%x:%x:%x:%x", _x, _y, _w, _h];
    return info.hash;
    }

#pragma mark - Debugging

/*****************************************************************************\
|* Produce a description
\*****************************************************************************/
- (NSString *) description
    {
    return [NSString stringWithFormat:@"Box: %d,%d +-> %d,%d", _x, _y, _w, _h];
    }
@end
