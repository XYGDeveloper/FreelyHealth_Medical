//
//  MessageListViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MessageListViewController.h"
#import "SegmentContainer.h"
#import "MessageViewController.h"
#import "GlistViewController.h"
#import "MyinviteViewController.h"
#import "MyGroupDetailViewController.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
#import "RootManager.h"

@interface MessageListViewController ()<SegmentContainerDelegate,BaseMessageViewDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) MessageViewController *message;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSString *messages;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会诊";
    self.titleArray = @[@"会话消息",@"会诊消息",@"会诊邀请"];
    self.container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    self.container.parentVC = self;
    self.container.delegate = self;
    self.container.titleFont = FontNameAndSize(16);
    self.container.titleNormalColor = DefaultGrayLightTextClor;
    self.container.titleSelectedColor = AppStyleColor;
    self.container.indicatorColor = AppStyleColor;
    self.container.containerBackgroundColor = [UIColor whiteColor];
    self.container.allowGesture = NO;
    [self.view addSubview:self.container];
  
    [self setRightNavigationItemWithTitle:@"发起会诊" action:@selector(applyGroupCon)];
    
    // Do any additional setup after loading the view.
}



- (void)applyGroupCon{
    
    if ([Utils showLoginPageIfNeeded]) {} else {
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                MyGroupDetailViewController *detail = [[MyGroupDetailViewController alloc]init];
                detail.title = @"发起会诊";
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
     
    }
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

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    
    return 3;
    
}

- (void)segmentContainerDidReloadData:(SegmentContainer *)segmentContainer{
    
    
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray objectAtIndex:index];
}


- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index{
    
    if (index == 0) {
        self.message = [[MessageViewController alloc]init];
        return self.message;
        
    }else if (index == 1){
        GlistViewController *glist = [[GlistViewController alloc]init];
        return glist;
        
    }else{
        MyinviteViewController *invite = [[MyinviteViewController alloc]init];
        return invite;
        
    }
    
}


@end
