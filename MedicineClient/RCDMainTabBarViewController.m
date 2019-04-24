//
//  RCDMainTabBarViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/30.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDMainTabBarViewController.h"
#import "TeamIndexViewController.h"
#import "TaskViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDMainTabBarViewController ()

@property NSUInteger previousIndex;

@end

@implementation RCDMainTabBarViewController

+ (RCDMainTabBarViewController *)shareInstance {
    static RCDMainTabBarViewController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setControllers];
    [self setTabBarItems];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSelectedIndex:)
                                                 name:@"ChangeTabBarIndex"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setControllers {
    
    TeamIndexViewController *chatVC = [[TeamIndexViewController alloc] init];

    TaskViewController *contactVC = [[TaskViewController alloc] init];

    MessageViewController *discoveryVC = [[MessageViewController alloc] init];

    MeViewController *meVC = [[MeViewController alloc] init];

    self.viewControllers = @[ chatVC, contactVC, discoveryVC, meVC ];
}

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

- (void)setTabBarItems {
    
    [self.viewControllers
        enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:[TeamIndexViewController class]]) {
                obj.tabBarItem.title = @"团队";
                obj.tabBarItem.image =
                    [[UIImage imageNamed:@"frum"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                obj.tabBarItem.selectedImage =
                    [[UIImage imageNamed:@"frum_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else if ([obj isKindOfClass:[TaskViewController class]]) {
                obj.tabBarItem.title = @"转诊";
                obj.tabBarItem.image =
                    [[UIImage imageNamed:@"task"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"task_sel"]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else if ([obj isKindOfClass:[MessageViewController class]]) {
                obj.tabBarItem.title = @"消息";
                obj.tabBarItem.image =
                    [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                obj.tabBarItem.selectedImage =
                    [[UIImage imageNamed:@"messdage_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else if ([obj isKindOfClass:[MeViewController class]]) {
                obj.tabBarItem.title = @"我的";
                obj.tabBarItem.image =
                    [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                obj.tabBarItem.selectedImage =
                    [[UIImage imageNamed:@"me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else {
                NSLog(@"Unknown TabBarController");
            }
        }];
}

- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController {
    NSUInteger index = tabBarController.selectedIndex;
    [RCDMainTabBarViewController shareInstance].selectedTabBarIndex = index;
    switch (index) {
    case 0: {
        if (self.previousIndex == index) {
            //判断如果有未读数存在，发出定位到未读数会话的通知
            if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoNextCoversation" object:nil];
            }
            self.previousIndex = index;
        }
        self.previousIndex = index;
    } break;

    case 1:
        self.previousIndex = index;
        break;

    case 2:
        self.previousIndex = index;
        break;

    case 3:
        self.previousIndex = index;
        break;

    default:
        break;
    }
}

- (void)changeSelectedIndex:(NSNotification *)notify {
    NSInteger index = [notify.object integerValue];
    self.selectedIndex = index;
}
@end
