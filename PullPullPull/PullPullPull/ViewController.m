//
//  ViewController.m
//  PullPullPull
//
//  Created by zhaimengyang on 2/21/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ViewController.h"
//#import "PullView.h"
#import "MYZPulledScrollView.h"

#import "MYZTouchOverlayWindow.h"

@interface ViewController ()<UITableViewDataSource>

//@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) MYZPulledScrollView *pulledScrollView;
@property (strong, nonatomic) MYZPulledScrollView *pulledScrollView_2;

@property (strong, nonatomic) NSMutableArray <UIView *>*pullViews;
@property (strong, nonatomic) NSMutableArray <UIView *>*pullViews_2;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    UIButton *view1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view1 setTitle:@"我、、你" forState:UIControlStateNormal];
    [view1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [view1 sizeToFit];
    view1.backgroundColor = [UIColor brownColor];
    
    UILabel *view2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    view2.text = @"我爱心泛滥";
    view2.backgroundColor = [UIColor orangeColor];
    
    UITableView *view3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    view3.dataSource = self;
    self.tableView = view3;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UISegmentedControl *view4 = [[UISegmentedControl alloc]initWithItems:@[@"1", @"2"]];
    [view4 sizeToFit];
    [view4 addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventValueChanged];
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    view5.backgroundColor = [UIColor yellowColor];
    
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    view6.backgroundColor = [UIColor grayColor];
    
    UIView *view7 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 100)];
    view7.backgroundColor = [UIColor blueColor];
    
    
    UIButton *view8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view1 setTitle:@"我、、你" forState:UIControlStateNormal];
    [view1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view1 sizeToFit];
    view1.backgroundColor = [UIColor brownColor];
    
    UILabel *view9 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    view2.text = @"我爱心泛滥";
    view2.backgroundColor = [UIColor orangeColor];
    
    
    UIView *view12 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    view12.backgroundColor = [UIColor yellowColor];
    
    UIView *view13 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    view13.backgroundColor = [UIColor grayColor];
    
    UIView *view14 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    view14.backgroundColor = [UIColor blueColor];
    
    UILabel *view15 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    view15.text = @"我爱心泛滥";
    view15.backgroundColor = [UIColor purpleColor];

    
    
    self.pullViews = [NSMutableArray array];
    [self.pullViews addObjectsFromArray:@[view1, view2, view3, view4, view5, view6, view7]];
    
    self.pullViews_2 = [NSMutableArray array];
    [self.pullViews_2 addObjectsFromArray:@[view12, view13, view14, view15]];

    
//    self.pulledScrollView = [[MYZPulledScrollView alloc]initWithPulledScrollDirection:PulledScrollDirectionHorizontal pullViews:self.pullViews origin:CGPointMake(10, 70) expectedSize:CGSizeMake(300, 300)];
//    self.pulledScrollView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.pulledScrollView];
    
//        self.pulledScrollView_2 = [[MYZPulledScrollView alloc]initWithPulledScrollDirection:PulledScrollDirectionHorizontal pullViews:self.pullViews_2 origin:CGPointMake(10, 400) expectedSize:CGSizeMake(200, 0)];
//    self.pulledScrollView_2.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.pulledScrollView_2];
    
    
    self.pulledScrollView = [[MYZPulledScrollView alloc]initWithPulledScrollDirection:PulledScrollDirectionHorizontal pullViews:self.pullViews origin:CGPointMake(10, 70) expectedSize:CGSizeMake(300, 0)];
    self.pulledScrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.pulledScrollView];
    
    self.pulledScrollView_2 = [[MYZPulledScrollView alloc]initWithPulledScrollDirection:PulledScrollDirectionVertical pullViews:self.pullViews_2 origin:CGPointMake(10, 380) expectedSize:CGSizeMake(0, 100)];
    self.pulledScrollView_2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.pulledScrollView_2];

    NSLog(@"%ssubviewsCount: %lu", __func__, (unsigned long)self.view.subviews.count);
    for (UIView *view in self.view.subviews) {
        NSLog(@"%@", [view class]);
    }
    
    BOOL isMYZClass = [[[UIApplication sharedApplication]keyWindow] isKindOfClass:[MYZTouchOverlayWindow class]];
    NSLog(@"isMYZClass = %@", isMYZClass ? @"YES" : @"NO");
    Class windowClass = [[[UIApplication sharedApplication]keyWindow]class];
    NSLog(@"windowClass: %@", NSStringFromClass(windowClass));
}

- (void)clickEvent:(UISegmentedControl *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"我打！" message:[NSString stringWithFormat:@"选择%ld", (long)sender.selectedSegmentIndex] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我去" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"哎呀index = %ld", (long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
