//
//  MYZTouchKitView.m
//  PullPullPull
//
//  Created by zhaimengyang on 2/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "MYZTouchKitView.h"

static MYZTouchKitView *shared = nil;

@implementation MYZTouchKitView
{
    NSSet *touches;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    
    shared.backgroundColor = [UIColor clearColor];
    shared.userInteractionEnabled = NO;
    shared.multipleTouchEnabled = YES;
    shared.touchColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    shared.fingerImage = nil;
    shared->touches = nil;
    
    if (!shared.superview) {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        shared.frame = window.bounds;
        [window addSubview:shared];
    }
    
    return shared;
}

- (void)touchesBegan:(NSSet<UITouch *> *)theTouches withEvent:(UIEvent *)event {
    touches = theTouches;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)theTouches withEvent:(UIEvent *)event {
    touches = theTouches;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)theTouches withEvent:(UIEvent *)event {
    touches = theTouches;
    [self setNeedsDisplay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)theTouches withEvent:(UIEvent *)event {
    touches = theTouches;
    [self setNeedsDisplay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [[UIColor clearColor]set];
    CGContextFillRect(context, self.bounds);
    
    for (UITouch *touch in touches) {
        if (_fingerImage) {
            CGPoint aPoint = [touch locationInView:self];
            CGSize size = [_fingerImage size];
            CGContextDrawImage(context, CGRectMake(aPoint.x - size.width / 2.0, aPoint.y - size.height / 2.0, size.width, size.height), [_fingerImage CGImage]);
        } else {
            CGFloat size = 25.0f;
            [[[UIColor darkGrayColor] colorWithAlphaComponent:0.5f] set];
            CGPoint aPoint = [touch locationInView:self];
            CGContextAddEllipseInRect(context, CGRectMake(aPoint.x - size, aPoint.y - size, 2 * size, 2 * size));
            CGContextFillPath(context);
            
            float dsize = 1.0f;
            [_touchColor set];
            aPoint = [touch locationInView:self];
            CGContextAddEllipseInRect(context, CGRectMake(aPoint.x - size - dsize, aPoint.y - size - dsize, 2 * (size - dsize), 2 * (size - dsize)));
            CGContextFillPath(context);
        }
    }
    
    touches = nil;
}

@end
