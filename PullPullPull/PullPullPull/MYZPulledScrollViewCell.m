//
//  MYZPulledScrollViewCell.m
//  PullPullPull
//
//  Created by zhaimengyang on 2/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "MYZPulledScrollViewCell.h"
#import "MYZPulledScrollView.h"


//#if 0
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif

typedef enum : NSUInteger {
    TouchUnknown,
    TouchSwipeLeft,
    TouchSwipeRight,
    TouchSwipeUp,
    TouchSwipeDown,
} SwipeTypes;

@implementation MYZPulledScrollViewCell
{
    CGPoint startPoint;
    SwipeTypes touchType;
    BOOL gestureWasHandled;
    
    //    DragView *dragView;
    MYZPulledScrollViewCell *cell;
    BOOL independent;
    
    BOOL canMoveIntoScrollView;
    
    MYZPulledScrollViewCell *parent;
    MYZPulledScrollView *pulledScrollView;
}

const NSInteger kSwipeDragMin = 16;
const NSInteger kDragLimitMax = 12;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        pan.delegate = self;
        self.gestureRecognizers = @[pan];
        
        independent = NO;
        canMoveIntoScrollView = NO;
        parent = nil;
        pulledScrollView = nil;
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (![self.superview isKindOfClass:[UIScrollView class]]) {
        CGPoint location = [pan locationInView:self.superview];
        self.center = location;
        
        UIScrollView *scrollView = (UIScrollView *)[(MYZPulledScrollViewCell *)(self->parent) superview];
        if (canMoveIntoScrollView) {
            
            if (CGRectContainsPoint(pulledScrollView.frame, self.center)) {
                
                if (pan.state == UIGestureRecognizerStateEnded) {
                    //ShouldAddToScrollView
                    NSArray *cells = pulledScrollView.pulledScrollViewCells;
                    NSUInteger count = cells.count;
                    for (NSUInteger index = 0; index < count; index++) {
                        MYZPulledScrollViewCell *cell = cells[index];
                        CGPoint convertedCenter = [self.superview convertPoint:self.center toView:pulledScrollView];
                        
                        if (((pulledScrollView.direction == PulledScrollDirectionHorizontal) && (convertedCenter.x < cell.center.x)) || ((pulledScrollView.direction == PulledScrollDirectionVertical) && (convertedCenter.y < cell.center.y))) {
                            UIView *contentView = self.contentView;
                            [pulledScrollView insertPullView:contentView atIndex:index];
                            
                            [self removeFromSuperview];
                            
                            break;
                        }
                        
                        if (index == count -1) {
                            UIView *contentView = self.contentView;
                            [pulledScrollView insertPullView:contentView atIndex:count];
                            
                            [self removeFromSuperview];
                        }
                    }//End for
                }//End if (pan.state == UIGestureRecognizerStateEnded)
            }//End if (CGRectContainsPoint(pulledScrollView.frame, self.center))
        }//End if (canMoveIntoScrollView)
        else {
            BOOL shouldRemoveParent = (scrollView.frame.origin.y - self.frame.origin.y) > self.frame.size.height || (self.frame.origin.y- scrollView.frame.origin.y) > scrollView.frame.size.height;
            if ([(MYZPulledScrollView *)scrollView direction] == PulledScrollDirectionVertical) {
                shouldRemoveParent = (scrollView.frame.origin.x - self.frame.origin.x) > self.frame.size.width || (self.frame.origin.x- scrollView.frame.origin.x) > scrollView.frame.size.width;
            }
            if (shouldRemoveParent) {
                scrollView.scrollEnabled = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:kMYZPulledScrollViewCellShouldRemoveFromSuperviewNotification object:self->parent];
                canMoveIntoScrollView = YES;
                pulledScrollView = (MYZPulledScrollView *)scrollView;
            }
        }
        
        return;
    }//End if (![self.superview isKindOfClass:[UIScrollView class]])
    
    
    UIView *super_super = self.superview.superview;
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    CGPoint location = [pan locationInView:super_super];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            startPoint = location;
            touchType = TouchUnknown;
            gestureWasHandled = NO;
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat dx = location.x - startPoint.x;
            CGFloat dy = location.y - startPoint.y;
            
            BOOL finished = YES;
            if ((dx > kSwipeDragMin) && (ABS(dy) < kDragLimitMax)) //right
                touchType = TouchSwipeRight;
            else if ((-dx > kSwipeDragMin) && (ABS(dy) < kDragLimitMax)) //left
                touchType = TouchSwipeLeft;
            else if ((dy > kSwipeDragMin) && (ABS(dx) < kDragLimitMax)) //down
                touchType = TouchSwipeDown;
            else if ((-dy > kSwipeDragMin) && (ABS(dx) < kDragLimitMax)) //up
                touchType = TouchSwipeUp;
            else finished = NO;
            
            BOOL isHorizontal = [(MYZPulledScrollView *)scrollView direction] == PulledScrollDirectionHorizontal ? YES : NO;
            BOOL touchTypeCorrect = isHorizontal ? (touchType == TouchSwipeDown || touchType == TouchSwipeUp) : (touchType == TouchSwipeLeft || touchType == TouchSwipeRight);
            if (!gestureWasHandled && finished && touchTypeCorrect) {
                if (!cell) {
                    cell = [[MYZPulledScrollViewCell alloc]initWithFrame:self.bounds];
                }
                cell.contentView = self.contentView;
                cell->parent = self;
                cell.center = location;
                cell->independent = YES;
                gestureWasHandled = YES;
                scrollView.scrollEnabled = NO;
                [super_super addSubview:cell];
            } else if (gestureWasHandled) {
                cell.center = location;
                if (self.alpha > 0.5) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.alpha = 0.5;
                    }];
                }
                
                BOOL shouldRemoveSelf = (scrollView.frame.origin.y - cell.frame.origin.y) > cell.frame.size.height ||
                (cell.frame.origin.y- scrollView.frame.origin.y) > scrollView.frame.size.height;
                if (!isHorizontal) {
                    shouldRemoveSelf = (scrollView.frame.origin.x - cell.frame.origin.x) > cell.frame.size.width ||
                    (cell.frame.origin.x- scrollView.frame.origin.x) > scrollView.frame.size.width;
                }
                
                if (shouldRemoveSelf) {
                    cell->canMoveIntoScrollView = YES;
                    cell->pulledScrollView = (MYZPulledScrollView *)[(MYZPulledScrollViewCell *)(cell->parent) superview];
                    
                    [UIView animateWithDuration:9.0 animations:^{
                        self.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        scrollView.scrollEnabled = YES;
                        [[NSNotificationCenter defaultCenter]postNotificationName:kMYZPulledScrollViewCellShouldRemoveFromSuperviewNotification object:self];
                    }];
                }//End if (shouldRemoveSelf)
            }//End else if (gestureWasHandled)
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            if (gestureWasHandled) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.alpha = 0.0;
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (independent) {
        [self.superview bringSubviewToFront:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    [self addSubview:contentView];
}

@end
