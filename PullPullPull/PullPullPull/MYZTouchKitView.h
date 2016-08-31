//
//  MYZTouchKitView.h
//  PullPullPull
//
//  Created by zhaimengyang on 2/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYZTouchKitView : UIView

@property (strong, nonatomic) UIColor *touchColor;
@property (strong, nonatomic) UIImage *fingerImage;

+ (instancetype)sharedInstance;

@end
