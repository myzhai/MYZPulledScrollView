//
//  MYZTouchOverlayWindow.h
//  PullPullPull
//
//  Created by zhaimengyang on 2/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYZTouchOverlayWindow : UIWindow

@property (strong, nonatomic) UIColor *beganColor;
@property (strong, nonatomic) UIColor *movedColor;
@property (strong, nonatomic) UIColor *endedColor;
@property (strong, nonatomic) UIColor *cancelledColor;

@property (strong, nonatomic) UIImage *fingerImage;

@end
