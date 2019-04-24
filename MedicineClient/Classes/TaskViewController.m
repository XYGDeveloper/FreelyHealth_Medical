//
//  TaskViewController.m
//  MedicineClient
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TaskViewController.h"
#import "SegmentContainer.h"
#import "ApplyTaskViewController.h"
#import "SpreadDropMenu.h"
#import "OrderListViewController.h"
#import "UpdateControlManager.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
static NSString const * statusKey = @"status";
static NSString const * statusNameKey = @"name";

@interface TaskViewController ()<SegmentContainerDelegate,BaseMessageViewDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) NSArray *orderStatusArray;

@end

@implementation TaskViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UpdateControlManager sharedUpdate] updateVersion];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转诊";
    [self configOrderStatus];
    [self.view addSubview:self.container];
    [self selectOrderStatus];
    [self setRightNavigationItemWithTitle:@"申请转诊" action:@selector(applyTrement)];
    
}


#pragma mark - Helper
- (void)configOrderStatus {
    self.orderStatusArray = @[@{statusKey:OrderReqStatusWaitRece, statusNameKey:@"待接受"},
                              @{statusKey:OrderReqStatusReceived, statusNameKey:@"进行中"},
                              @{statusKey:OrderReqStatusFinished, statusNameKey:@"已完成"},
                              ];
    
}

- (void)selectOrderStatus {
    if (!self.orderStatus || self.orderStatus.length <= 0) {
        self.orderStatus = OrderReqStatusWaitRece;
    }
    
    for (NSDictionary *dic in self.orderStatusArray) {
        NSString *status = [dic objectForKey:statusKey];
        if ([status isEqualToString:self.orderStatus]) {
            NSUInteger index = [self.orderStatusArray indexOfObject:dic];
            [self.container setSelectedIndex:index withAnimated:YES];
        }
    }
}


#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
            _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight+10)];
            _container.parentVC = self;
            _container.delegate = self;
            _container.titleFont = FontNameAndSize(17);
            _container.titleNormalColor = DefaultGrayLightTextClor;
            _container.titleSelectedColor = AppStyleColor;
            _container.indicatorColor = AppStyleColor;
            _container.containerBackgroundColor = [UIColor whiteColor];
    }
    return _container;
}

#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.orderStatusArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    return [dic objectForKey:statusNameKey];
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    OrderListViewController *listVC = [[OrderListViewController alloc] initWithOrderStatus:[dic objectForKey:statusKey]];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
}

-(void)showScanMessageTitle:(NSString *)title content:(NSString *)content leftBtnTitle:(NSString *)left rightBtnTitle:(NSString *)right tag:(NSInteger)tag{
    NSArray  *buttonTitles;
    if (left && right) {
        buttonTitles   =  @[AlertViewNormalStyle(left),AlertViewRedStyle(right)];
    }else{
        buttonTitles = @[AlertViewRedStyle(left)];
    }
    AlertViewMessageObject *messageObject = MakeAlertViewMessageObject(title,content, buttonTitles);
    [AlertView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:tag];
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 8000) {
        if ([event isEqualToString:@"重新认证"]){
            MyProfileViewController *profile = [[MyProfileViewController alloc]init];
            profile.title = @"我的资料";
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
    [messageView hide];
}

- (void)applyTrement{

    if ([Utils showLoginPageIfNeeded]) {} else {
        
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                ApplyTaskViewController *apply = [ApplyTaskViewController new];
                apply.isFill = YES;
                apply.title = @"申请转诊";
                [self.navigationController pushViewController:apply animated:YES];
            }else{

                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
     
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
