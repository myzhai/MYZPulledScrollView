//
//  AppDelegate.h
//  PullPullPull
//
//  Created by zhaimengyang on 2/21/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#define USES_TOUCHKIT 1

#import <UIKit/UIKit.h>

#if USES_TOUCHKIT
#define WINDOW_CLASS MYZTouchOverlayWindow
#import "MYZTouchOverlayWindow.h"
#else
#define WINDOW_CLASS UIWindow
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) WINDOW_CLASS *window;


@end

