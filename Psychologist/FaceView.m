//
//  FaceView.m
//  Happiness
//
//  Created by Martin Mandl on 17.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

- (CGFloat)scale
{
    if (!_scale) _scale = DEFAULT_SCALE;
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (scale == _scale) return;
    _scale = scale;
    [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;    
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)r inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, r, 0, 2 * M_PI, YES);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
    
    // draw face (circle)
    CGFloat size = self.bounds.size.width / 2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5);
    [[UIColor blueColor] setStroke];
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    // draw eyes (2 circles)
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;

    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    // no nose
    // draw mouth
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 0.66;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 0.66;
    
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);

}

@end
