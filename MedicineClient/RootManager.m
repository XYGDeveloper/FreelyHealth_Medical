//
//  RootManager.m
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "RootManager.h"
//废弃
//#import "ForumViewController.h"
#import "TaskViewController.h"
#import "MessageListViewController.h"
#import "MeViewController.h"
#import "TaskViewController.h"
#import "MessageListViewController.h"
#import "MeViewController.h"
#import "TeamIndexViewController.h"
#import "HZViewController.h"
@interface RootManager ()<UITabBarControllerDelegate>
@property (nonatomic, strong, readwrite) UITabBarController *tabbarController;
@end

@implementation RootManager

+ (instancetype)sharedManager {
    static RootManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RootManager alloc] init];
    });
    return __manager;
    
}

- (void)dealloc {
    [self.tabbarController removeObserver:self forKeyPath:@"selectedIndex"];
}

- (id)init {
    if (self = [super init]) {
        [self initTabbarController];
        [self.tabbarController addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        NSUInteger oldIndex = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        UIViewController *vc = [self.tabbarController.viewControllers safeObjectAtIndex:oldIndex];
        UINavigationController *nav = (UINavigationController *)vc;
        if (nav.viewControllers.count > 1) {
            nav.viewControllers = @[nav.viewControllers.firstObject];
        }
    }
}

- (void)initTabbarController {
    //团队
    TeamIndexViewController *forum = [[TeamIndexViewController alloc] init];
//    [forum refreshTeamPage];
    [self addTabWithController:forum title:@"团队" image:[UIImage imageNamed:@"frum"] selectedImage:[UIImage imageNamed:@"frum_sel"] bageValue:nil];
    //任务
     TaskViewController * task = [[TaskViewController alloc]init];
    [self addTabWithController:task title:@"转诊" image:[UIImage imageNamed:@"task"] selectedImage:[UIImage imageNamed:@"task_sel"] bageValue:nil];
//    MessageListViewController *ms = [[MessageListViewController alloc] init];
//            [self addTabWithController:ms title:@"会诊" image:[UIImage imageNamed:@"message"] selectedImage:[UIImage imageNamed:@"messdage_sel"] bageValue:nil];
        HZViewController *ms = [[HZViewController alloc] init];
                [self addTabWithController:ms title:@"会诊" image:[UIImage imageNamed:@"message"] selectedImage:[UIImage imageNamed:@"messdage_sel"] bageValue:nil];
    //我的
    MeViewController *myVC = [[MeViewController alloc] init];
    [self addTabWithController:myVC title:@"我的" image:[UIImage imageNamed:@"me"] selectedImage:[UIImage imageNamed:@"me_sel"] bageValue:nil];
    
}

- (void)addTabWithController:(UIViewController *)controller
                       title:(NSString *)title
                       image:(UIImage *)image
               selectedImage:(UIImage *)selectedImage
                   bageValue:(NSString *)bageValue{
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    nav.tabBarItem.badgeValue = bageValue;
    nav.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic safeSetObject:AppStyleColor forKey:NSForegroundColorAttributeName];
    [dic safeSetObject:FontNameAndSize(14) forKey:NSFontAttributeName];
    [nav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.tabbarController addChildViewController:nav];
    
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *rootVC = [nav.viewControllers firstObject];
    }
    
    return YES;
}


#pragma mark - Properties
- (UITabBarController *)tabbarController {
    if (!_tabbarController ) {
        _tabbarController = [[CutomTabbarViewController alloc] init];
        _tabbarController.delegate = self;
    }
    return _tabbarController;
}

@end
#import "MessageViewController.h"
@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:2];
    [attributes setObject:Font(18) forKey:NSFontAttributeName];
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = attributes;
    self.interactivePopGestureRecognizer.enabled=NO;
    self.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[MessageListViewController class]]) {
//            MessageViewController *chatListVC = (MessageViewController *)obj;
//            [chatListVC updateBadgeValueForTabBarItem];
//        }
//        NSLog(@"\\\\\\\\\\\\\\\\\\\%@",obj);
    }];
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhh   %@",[self.viewControllers lastObject]);
//    if ([[self.viewControllers lastObject] isMemberOfClass:[QqwPersonalViewController class]]) {
//        [self setNavigationBarHidden:YES animated:animated];
//    }else{
//        [self setNavigationBarHidden:NO];
//    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
