//
//  MYZPulledScrollView.m
//  PullPullPull
//
//  Created by zhaimengyang on 2/22/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "MYZPulledScrollView.h"

@interface MYZPulledScrollView ()

@property (strong, nonatomic) NSMutableArray <MYZPulledScrollViewCell *>*cells;

@end

@implementation MYZPulledScrollView

- (instancetype)initWithPulledScrollDirection:(PulledScrollDirection)direction pullViews:(NSArray <UIView *>*)contentViews origin:(CGPoint)origin expectedSize:(CGSize)expectedSize {
    self = [super init];
    if (self) {
        _direction = direction;
        
        self.cells = [NSMutableArray array];
        for (UIView *contentView in contentViews) {
            MYZPulledScrollViewCell *cell = [[MYZPulledScrollViewCell alloc]initWithFrame:contentView.bounds];
            cell.contentView = contentView;
            [self.cells addObject:cell];
        }
        
        if (self.direction == PulledScrollDirectionHorizontal) {
            CGFloat height = [self getMaxHeight];
            CGFloat width = [self getTotalWidth];
            self.contentSize = CGSizeMake(width, height);
            CGRect frame = CGRectMake(origin.x, origin.y, expectedSize.width, height);
            self.frame = frame;
        } else {
            CGFloat width = [self getMaxWidth];
            CGFloat height = [self getTotalHeight];
            self.contentSize = CGSizeMake(width, height);
            CGRect frame = CGRectMake(origin.x, origin.y, width, expectedSize.height);
            self.frame = frame;
        }
        
        [self layoutCells];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(removeCell)
                                                    name:kMYZPulledScrollViewCellShouldRemoveFromSuperviewNotification
                                                  object:nil];
    }
    NSLog(@"%scellCount: %lu", __func__, (unsigned long)self.subviews.count);
    return self;
}

- (void)layoutCells {
    CGFloat length = 0;
    for (MYZPulledScrollViewCell *cell in self.cells) {
        CGSize size = cell.bounds.size;
        if (self.direction == PulledScrollDirectionHorizontal) {
            CGRect frame = CGRectMake(length, 0, size.width, size.height);
            cell.frame = frame;
            length += size.width;
        } else {
            CGRect frame = CGRectMake(0, length, size.width, size.height);
            cell.frame = frame;
            length += size.height;
        }
        [self addSubview:cell];
    }
}

- (void)removeCell {
    NSUInteger index = 0;
    NSUInteger count = self.cells.count;
    CGFloat length = 0;
    for (; index < count; index++) {
        MYZPulledScrollViewCell *cell = (MYZPulledScrollViewCell *)self.cells[index];
        if (cell.alpha == 0.0) {
            [cell removeFromSuperview];
            [self.cells removeObjectAtIndex:index];
            count = self.cells.count;
            break;
        }
        
        CGSize size = cell.bounds.size;
        if (self.direction == PulledScrollDirectionHorizontal) {
            length += size.width;
        } else {
            length += size.height;
        }
    }
    
    for (; index < count; index++) {
        MYZPulledScrollViewCell *cell = (MYZPulledScrollViewCell *)self.cells[index];
        CGSize size = cell.bounds.size;
        if (self.direction == PulledScrollDirectionHorizontal) {
            CGRect frame = CGRectMake(length, 0, size.width, size.height);
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = frame;
            }];
            length += size.width;
        } else {
            CGRect frame = CGRectMake(0, length, size.width, size.height);
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = frame;
            }];
            length += size.height;
        }
    }
    
    if (self.direction == PulledScrollDirectionHorizontal) {
        CGFloat height = [self getMaxHeight];
        CGFloat width = [self getTotalWidth];
        self.contentSize = CGSizeMake(width, height);
    } else {
        CGFloat width = [self getMaxWidth];
        CGFloat height = [self getTotalHeight];
        self.contentSize = CGSizeMake(width, height);
    }
    NSLog(@"%scellCount: %lu", __func__, (unsigned long)self.subviews.count);
}

- (void)insertPullView:(UIView *)contentView atIndex:(NSUInteger)index {
    MYZPulledScrollViewCell *cell = [[MYZPulledScrollViewCell alloc]initWithFrame:contentView.bounds];
    cell.contentView = contentView;
    [self.cells insertObject:cell atIndex:index];
    
    if (self.direction == PulledScrollDirectionHorizontal) {
        CGFloat height = [self getMaxHeight];
        CGFloat width = [self getTotalWidth];
        self.contentSize = CGSizeMake(width, height);
    } else {
        CGFloat width = [self getMaxWidth];
        CGFloat height = [self getTotalHeight];
        self.contentSize = CGSizeMake(width, height);
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutCells];
    }];
    
    NSLog(@"%scellCount: %lu", __func__, (unsigned long)self.subviews.count);
    for (UIView *view in self.subviews) {
        NSLog(@"%@", [view class]);
    }
}

- (CGFloat)getMaxWidth {
    CGFloat maxWidth = 0;
    for (UIView *cell in self.cells) {
        CGFloat width = cell.bounds.size.width;
        if (width >= maxWidth) {
            maxWidth = width;
        }
    }
    
    return maxWidth;
}

- (CGFloat)getTotalWidth {
    CGFloat total = 0;
    for (UIView *cell in self.cells) {
        CGFloat width = cell.bounds.size.width;
        total += width;
    }
    
    return total;
}

- (CGFloat)getTotalHeight {
    CGFloat total = 0;
    for (UIView *cell in self.cells) {
        CGFloat height = cell.bounds.size.height;
        total += height;
    }
    
    return total;
}

- (CGFloat)getMaxHeight {
    CGFloat maxHeight = 0;
    for (UIView *cell in self.cells) {
        CGFloat height = cell.bounds.size.height;
        if (height >= maxHeight) {
            maxHeight = height;
        }
    }
    
    return maxHeight;
}

- (NSArray *)pulledScrollViewCells {
    return [self.cells copy];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
