//
//  MYZPulledScrollViewCell.h
//  PullPullPull
//
//  Created by zhaimengyang on 2/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMYZPulledScrollViewCellShouldRemoveFromSuperviewNotification @"kMYZPulledScrollViewCellShouldRemoveFromSuperviewNotification"
//#define kMYZPulledScrollViewCellDidRemoveFromSuperviewNotification @"kMYZPulledScrollViewCellDidRemoveFromSuperviewNotification"

@interface MYZPulledScrollViewCell : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contentView;

@end
