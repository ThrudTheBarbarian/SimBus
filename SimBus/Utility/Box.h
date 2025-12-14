//
//  Box.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 13/12/2025.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Box : NSObject <NSCopying>

/*****************************************************************************\
|* Convenience initialisation
\*****************************************************************************/
+ (instancetype) boxAt:(NSPoint)topLeft size:(NSSize)size;

/*****************************************************************************\
|* Do we contain a point
\*****************************************************************************/
- (BOOL) contains:(NSPoint)p;

/*****************************************************************************\
|* Return as an NSRect
\*****************************************************************************/
- (NSRect) asRect;

/*****************************************************************************\
|* Return a path for a triangle within, facing up or down
\*****************************************************************************/
- (NSBezierPath *) triangle:(BOOL)facingUp;

@property(assign, nonatomic) int                            x;
@property(assign, nonatomic) int                            y;
@property(assign, nonatomic) int                            w;
@property(assign, nonatomic) int                            h;



// - NSCopying
- (id) copyWithZone:(nullable NSZone *)zone;

// - Equality and hash
- (BOOL) isEqual:(id)object;
- (NSUInteger) hash;

@end

NS_ASSUME_NONNULL_END
