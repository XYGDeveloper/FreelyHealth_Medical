//
//  CutomTabbarViewController.m
//  MedicineClient
//
//  Created by L on 2018/1/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CutomTabbarViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MessageViewController.h"
@interface CutomTabbarViewController ()

@end

@implementation CutomTabbarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewControllers
     enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
         if ([obj isKindOfClass:[MessageViewController class]]) {
             MessageViewController *chatListVC = (MessageViewController *)obj;
             [chatListVC updateBadgeValueForTabBarItem];
         }
     }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.selectedIndex != index) {
//        [self animationWithIndex:index];
//        [self playSound];//点击时音效
    }
    
}


// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
    self.selectedIndex = index;
    
}


-(void) playSound{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"caf"];
    SystemSoundID soundID;
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

@end
