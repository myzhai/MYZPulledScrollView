//
//  MYZTouchOverlayWindow.m
//  PullPullPull
//
//  Created by zhaimengyang on 2/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "MYZTouchOverlayWindow.h"
#import "MYZTouchKitView.h"

@implementation MYZTouchOverlayWindow
{
    MYZTouchKitView *sharedView;
}

- (void)sendEvent:(UIEvent *)event {
    NSSet <UITouch *>*touches = event.allTouches;
    NSMutableSet *began = nil;
    NSMutableSet *moved = nil;
    NSMutableSet *ended = nil;
    NSMutableSet *cancelled = nil;
    
    for (UITouch *touch in touches) {
        switch (touch.phase) {
            case UITouchPhaseBegan:
                if (!began) {
                    began = [NSMutableSet set];
                }
                [began addObject:touch];
                break;
            case UITouchPhaseMoved:
                if (!moved) {
                    moved = [NSMutableSet set];
                }
                [moved addObject:touch];
                break;
            case UITouchPhaseEnded:
                if (!ended) {
                    ended = [NSMutableSet set];
                }
                [ended addObject:touch];
                break;
            case UITouchPhaseCancelled:
                if (!cancelled) {
                    cancelled = [NSMutableSet set];
                }
                [cancelled addObject:touch];
                break;
                
            default:
                break;
        }
    }
    
    if (began) {
        if (!sharedView) {
            sharedView = [MYZTouchKitView sharedInstance];
        }
        if (_beganColor) {
            sharedView.touchColor = _beganColor;
        }
        [sharedView touchesBegan:began withEvent:event];
    }
    if (moved) {
        if (!sharedView) {
            sharedView = [MYZTouchKitView sharedInstance];
        }
        if (_movedColor) {
            sharedView.touchColor = _movedColor;
        }
        [sharedView touchesMoved:moved withEvent:event];
    }
    if (ended) {
        if (!sharedView) {
            sharedView = [MYZTouchKitView sharedInstance];
        }
        if (_endedColor) {
            sharedView.touchColor = _endedColor;
        }
        [sharedView touchesEnded:ended withEvent:event];
    }
    if (cancelled) {
        if (!sharedView) {
            sharedView = [MYZTouchKitView sharedInstance];
        }
        if (_cancelledColor) {
            sharedView.touchColor = _cancelledColor;
        }
        [sharedView touchesCancelled:cancelled withEvent:event];
    }
    
    [super sendEvent:event];
}

@end
