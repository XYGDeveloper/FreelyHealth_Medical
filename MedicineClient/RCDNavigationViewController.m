//
//  RCDNavigationViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/25.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDNavigationViewController.h"
#import "UIColor+RCColor.h"
@interface RCDNavigationViewController ()

@end

@implementation RCDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"0099ff" alpha:1.0f]];
    __weak RCDNavigationViewController *weakSelf = self;

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;

        self.delegate = weakSelf;

        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] && self.viewControllers.count > 1 &&
        [self.visibleViewController isEqual:[self.viewControllers lastObject]]) {
        //判断当导航堆栈中存在页面，并且可见视图如果不是导航堆栈中的最后一个视图时，就会屏蔽掉滑动返回的手势。此设置是为了避免页面滑动返回时因动画存在延迟所导致的卡死。
        return YES;
    } else {
        return NO;
    }
}

@end
