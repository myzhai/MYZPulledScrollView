//
//  MYZPulledScrollView.h
//  PullPullPull
//
//  Created by zhaimengyang on 2/22/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZPulledScrollViewCell.h"

typedef enum : NSUInteger {
    PulledScrollDirectionHorizontal,
    PulledScrollDirectionVertical,
} PulledScrollDirection;

@interface MYZPulledScrollView : UIScrollView

@property (assign, readonly, nonatomic) PulledScrollDirection direction;
@property (strong, readonly, nonatomic) NSArray <MYZPulledScrollViewCell *>*pulledScrollViewCells;

- (instancetype)initWithPulledScrollDirection:(PulledScrollDirection)direction pullViews:(NSArray <UIView *>*)contentViews origin:(CGPoint)origin expectedSize:(CGSize)expectedSize;

- (void)insertPullView:(UIView *)contentView atIndex:(NSUInteger)index;

@end
