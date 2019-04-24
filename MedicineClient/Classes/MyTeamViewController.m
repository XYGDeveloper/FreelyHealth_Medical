//
//  MyTeamViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.

#import "MyTeamViewController.h"
#import "MyTeamModel.h"
#import "MyTeamApi.h"
#import "MyTeamListRequest.h"
#import "TeamDesTableViewCell.h"
#import "TeamListTableViewCell.h"
#import "TeamDetailViewController.h"
#import "LSProgressHUD.h"
#import "ConversationViewController.h"
#import "JoinTeamApi.h"
#import "JoinTeamRequest.h"
#import "IsJoinApi.h"
#import "IsJoinTeamRequest.h"
#import "YQAlertView.h"
#import "ConversationViewController.h"
#import "LoginViewController.h"
#import "RootManager.h"
#import "YQWaveButton.h"
#import "UIView+AnimationProperty.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "ZJImageMagnification.h"
#import "AlertView.h"
#import "LYZAdView.h"
#define kFetchTag 3000
#define kFetchTag1 4000
#define kFetchTag2 5000
#define kFetchTag5 6000
#import "MyProfileViewController.h"
#import "UdeskTicketViewController.h"
#import "GetAuthStateManager.h"
@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
{
    CGFloat _lastPosition;
}
//@property (nonatomic,strong)PSBottomBar * bottomBar;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UILabel * nikeNameLabel;
@property (nonatomic,strong)UILabel * jopNameLabel;
@property (nonatomic,strong)UILabel * hotelNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)UIView * headBackView;

@property (nonatomic,strong)UIImageView * headImageView;

@property (nonatomic,strong)YQWaveButton * backButton;

@property (nonatomic,strong)UILabel * titleView;

@property (nonatomic,strong)YQWaveButton * shareButton;

@property (nonatomic,strong)MyTeamApi * api;

@property (nonatomic,strong)MyTeamModel * model;

@property (nonatomic,strong)NSMutableArray * listArr;

@property (nonatomic,strong)UIButton *JoinTeamButton;
@property (nonatomic,strong)UIButton *chatWithCustomerButton;
@property (nonatomic,strong)UIButton *chatButton;
//加入团队

@property (nonatomic,strong)JoinTeamApi* joinApi;

//判断是否加入过团队

@property (nonatomic,strong)IsJoinApi * isjoinApi;

@property (nonatomic,strong)YQAlertView * alertview;

@property (nonatomic,strong)IsJoinApi * isjoinApi1;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSString *gid;

@end

@implementation MyTeamViewController

- (UIButton *)JoinTeamButton{
    if (!_JoinTeamButton) {
        _JoinTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_JoinTeamButton setTitle:@"加入" forState:UIControlStateNormal];
        [_JoinTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _JoinTeamButton.titleLabel.font = Font(16);
        _JoinTeamButton.backgroundColor = AppStyleColor;
    }
    return _JoinTeamButton;
}

- (UIButton *)chatWithCustomerButton{
    if (!_chatWithCustomerButton) {
        _chatWithCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatWithCustomerButton setTitle:@"咨询" forState:UIControlStateNormal];
        [_chatWithCustomerButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _chatWithCustomerButton.titleLabel.font = Font(16);
        _chatWithCustomerButton.backgroundColor = [UIColor whiteColor];
    }
    return _chatWithCustomerButton;
}

- (UIButton *)chatButton{
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setTitle:@"团队群聊" forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _chatButton.titleLabel.font = Font(16);
        _chatButton.backgroundColor = AppStyleColor;
    }
    return _chatButton;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self hiddenNavigationControllerBar:YES];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (self.isPersonCenter == NO) {
        
        isjoinHeader *header = [[isjoinHeader alloc]init];
        
        header.target = @"teamDControl";
        
        header.method = @"queryJoinTeam";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        isjoinBody *bodyer = [[isjoinBody alloc]init];
        
        bodyer.id = self.teamID;
        
        IsJoinTeamRequest *requester = [[IsJoinTeamRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.isjoinApi1 Isjopin:requester.mj_keyValues.mutableCopy];

    }

}

- (NSMutableArray *)listArr
{

    if (!_listArr) {
        
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;

}

- (MyTeamApi *)api
{

    if (!_api) {
        
        _api = [[MyTeamApi alloc]init];
        
        _api.delegate = self;
        
    }

    return _api;
    
}


- (JoinTeamApi *)joinApi
{

    if (!_joinApi) {
        
        _joinApi = [[JoinTeamApi alloc]init];
        
        _joinApi.delegate  = self;
        
    }
    
    return _joinApi;

}

- (IsJoinApi *)isjoinApi
{

    if (!_isjoinApi) {
        
        _isjoinApi = [[IsJoinApi alloc]init];
        
        _isjoinApi.delegate  =self;
        
    }
    
    return _isjoinApi;
    

}

- (IsJoinApi *)isjoinApi1
{
    
    if (!_isjoinApi1) {
        
        _isjoinApi1 = [[IsJoinApi alloc]init];
        
        _isjoinApi1.delegate  =self;
        
    }
    
    return _isjoinApi1;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    
    [Utils postMessage:command.response.msg onView:self.view];

    if ([command.response.code isEqualToString:@"30008"]) {
        
        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
    if ([command.response.msg isEqualToString:@"token失效"]) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        
        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginVC];
        
        [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
        
    }
    
    [self.hud hide:YES];

    if (api == _isjoinApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
    
    if (api == _joinApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];

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
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"确认"]){
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
                        if ([auth isEqualToString:@"3"]) {
                            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            joinHeader *header = [[joinHeader alloc]init];
                            header.target = @"teamDControl";
                            header.method = @"joinTeam";
                            header.versioncode = Versioncode;
                            header.devicenum = Devicenum;
                            header.fromtype = Fromtype;
                            header.token = [User LocalUser].token;
                            joinBody *bodyer = [[joinBody alloc]init];
                            bodyer.id = self.teamID;
                            JoinTeamRequest *requester = [[JoinTeamRequest alloc]init];
                            requester.head = header;
                            requester.body = bodyer;
                            NSLog(@"%@",requester);
                            [self.joinApi getTeamJpin:requester.mj_keyValues.mutableCopy];
                        }else{
                            NSString *content = @"认证任务失败,请尝试重新认证.";
                            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
                        }
                    }];
                });
            }
        }else{
            
        }
    }
    if (messageView.tag == kFetchTag1) {
        if ([event isEqualToString:@"知道了"]){
        }
    }
    if (messageView.tag == kFetchTag2) {
        if ([event isEqualToString:@"知道了"]){
        }
    }
    if (messageView.tag == kFetchTag5) {
        if ([event isEqualToString:@"知道了"]){
        }
    }
    if (messageView.tag == 8000) {
        if ([event isEqualToString:@"重新认证"]){
            MyProfileViewController *profile = [[MyProfileViewController alloc]init];
            profile.title = @"我的资料";
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
    [messageView hide];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    [self.hud hide:YES];

    if (api == _api) {
        
        self.model = responsObject;
        
        self.listArr = [memberModel mj_objectArrayWithKeyValuesArray:self.model.members];
        self.nikeNameLabel.text = self.model.name ? self.model.name:@"";
        weakify(self);
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.model.lfacepath]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   strongify(self);
                                   self.avatarView.image = image;
                                   self.avatarView.alpha = 0;
                                   self.avatarView.scale = 1.1f;
                                   [UIView animateWithDuration:0.5f animations:^{
                                       self.avatarView.alpha = 1.f;
                                       self.avatarView.scale = 1.f;
                                   }];
                               }];
        self.jopNameLabel.text = self.model.lname ? [NSString stringWithFormat:@"带头人：%@",self.model.lname]:[NSString stringWithFormat:@"%@",@""];
        self.hotelNameLabel.text = self.model.ljob && self.model.lhname ? [NSString stringWithFormat:@"%@ %@",self.model.lhname,self.model.ljob]:[NSString stringWithFormat:@"%@ %@",@"",@""];
        
        [self.tableview reloadData];

    }
    
    if (api== _isjoinApi) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responsObject[@"type"]isEqualToString:@"1"]) {
                NSString *content = @"确定申请加入团队？";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"取消" rightBtnTitle:@"确认" tag:kFetchTag];
            }else if ([responsObject[@"type"]isEqualToString:@"2"]){
                NSString *content = @"申请已提交，3个工作日内有复核结果，有问题请咨询客服(400-900-1169)";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"知道了" rightBtnTitle:nil tag:kFetchTag1];
            }else if([responsObject[@"type"]isEqualToString:@"3"]){
                NSString *groupid = responsObject[@"gid"];
                if (groupid.length<=0) {
                    NSString *content = @"您已经是某团队的成员了，不能再申请加入其他团队";
                    [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"知道了" rightBtnTitle:nil tag:kFetchTag2];
                }else{
                    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
                        if ([auth isEqualToString:@"3"]) {
                            [User LocalUser].tgroupid = groupid;
                            [User LocalUser].tname = self.model.name;
                            [User LocalUser].mdtgroupfacepath = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
                            [User saveToDisk];
//                            NSUserDefaults *TeamgroupObject = [NSUserDefaults standardUserDefaults];
//                            NSDictionary *dic = @{
//                                                  @"targetid":groupid,
//                                                  @"name":self.model.name
//                                                  };
//                            [TeamgroupObject setObject:dic forKey:groupid];
                            ConversationViewController *conver = [[ConversationViewController alloc]init];
                            conver.targetId = groupid;
                            conver.conversationType = ConversationType_GROUP;
                            conver.title = self.model.name;
                            [self.navigationController pushViewController:conver animated:YES];
                        }else{
                            NSString *content = @"认证任务失败,请尝试重新认证.";
                            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
                        }
                    }];
                }
            }
        });
    }
    
    if (api== _joinApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
    if (api == _isjoinApi1) {
        
        if ([responsObject[@"type"]isEqualToString:@"1"] || [responsObject[@"type"]isEqualToString:@"2"]) {
        
            [self.view addSubview:self.chatWithCustomerButton];
            [self.view addSubview:self.JoinTeamButton];
            [self.chatWithCustomerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(0);
                make.width.mas_equalTo(kScreenWidth/2);
                make.height.mas_equalTo(49);
            }];
            [self.JoinTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(0);
                make.width.mas_equalTo(kScreenWidth/2);
                make.height.mas_equalTo(49);
            }];
            [self.JoinTeamButton addTarget:self action:@selector(appGroupAction) forControlEvents:UIControlEventTouchUpInside];
            [self.chatWithCustomerButton addTarget:self action:@selector(tochatWithcustomer) forControlEvents:UIControlEventTouchUpInside];
        }else if ([responsObject[@"type"]isEqualToString:@"3"]){
            self.gid = responsObject[@"gid"];
            [self.view addSubview:self.chatButton];
            [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.height.mas_equalTo(49);
            }];
            [self.chatButton addTarget:self action:@selector(toChat:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}


- (void)tochatWithcustomer{
    
    if ([Utils showLoginPageIfNeeded]) {} else {
        UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
        [UdeskManager setupCustomerOnline];
        //设置头像
        [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
        [manager pushUdeskInViewController:self completion:nil];
        //点击留言回调
        [manager leaveMessageButtonAction:^(UIViewController *viewController){
            UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
            [viewController presentViewController:offLineTicket animated:YES completion:nil];
        }];
    }
}


- (void)dealloc
{
    _headBackView = nil;
    _headImageView = nil;
}


- (YQWaveButton *)backButton
{

    if (!_backButton) {
        
        _backButton = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
    }

    return _backButton;

}

- (UILabel *)titleView
{

    if (!_titleView) {
        
        _titleView = [[UILabel alloc]init];
        
        _titleView.backgroundColor = [UIColor clearColor];
        
        _titleView.textColor = [UIColor whiteColor];
        
        _titleView.text = @"我的团队";
        
        _titleView.font =  Font(16);
        
        _titleView.textAlignment = NSTextAlignmentCenter;
    }

    return _titleView;
    
}


- (YQWaveButton *)shareButton
{

    if (!_shareButton) {
        
        _shareButton = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _shareButton.titleLabel.font = Font(14);
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        
    }

    return _shareButton;
    
}


- (UIView*)headBackView
{
    if (!_headBackView) {
        _headBackView = [UIView new];
        _headBackView.userInteractionEnabled = YES;
        _headBackView.frame = CGRectMake(0, 0, kScreenWidth,230);
    }
    return _headBackView;
}

- (UIImageView*)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [UIImageView new];
        _headImageView.image = [UIImage imageNamed:@"me_bg"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.backgroundColor = [UIColor orangeColor];
    }
    return _headImageView;
}

- (UIImageView*)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.image = [UIImage imageNamed:@"me_header"];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.size = CGSizeMake(80, 80);
        _avatarView.userInteractionEnabled = YES;
        [_avatarView setLayerWithCr:_avatarView.width / 2];
    }
    return _avatarView;
}

- (UILabel*)nikeNameLabel
{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [UILabel new];
        _nikeNameLabel.textAlignment = NSTextAlignmentCenter;
        _nikeNameLabel.font = FontNameAndSize(16);
        _nikeNameLabel.textColor = DefaultBlackLightTextClor;
        
    }
    return _nikeNameLabel;
}

- (UILabel*)jopNameLabel
{
    if (!_jopNameLabel) {
        _jopNameLabel = [UILabel new];
        _jopNameLabel.textAlignment = NSTextAlignmentCenter;
        _jopNameLabel.font = FontNameAndSize(16);
        _jopNameLabel.textColor = DefaultGrayTextClor;
    }
    return _jopNameLabel;
}

- (UILabel*)hotelNameLabel
{
    if (!_hotelNameLabel) {
        _hotelNameLabel = [UILabel new];
        _hotelNameLabel.textAlignment = NSTextAlignmentCenter;
        _hotelNameLabel.font = FontNameAndSize(16);
        _hotelNameLabel.textColor = DefaultGrayTextClor;
        
    }
    return _hotelNameLabel;
}

#pragma mark --

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self hiddenNavigationControllerBar:NO];
        
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)resetHeaderView
{

    self.headImageView.frame = self.headBackView.bounds;
    [self.headBackView addSubview:self.headImageView];
    
    self.avatarView.centerX = self.headBackView.centerX;
    self.avatarView.centerY = self.headBackView.centerY -  HalfF(20);
    [self.headBackView addSubview:self.avatarView];
    
    self.nikeNameLabel.y = CGRectGetMaxY(self.avatarView.frame) + HalfF(10);
    self.nikeNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.nikeNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.nikeNameLabel];
  
    self.jopNameLabel.y = CGRectGetMaxY(self.nikeNameLabel.frame) + HalfF(5);
    self.jopNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.jopNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.jopNameLabel];
    
 
    self.hotelNameLabel.y = CGRectGetMaxY(self.jopNameLabel.frame) + HalfF(5);
    self.hotelNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.hotelNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.hotelNameLabel];
    
    [self.headBackView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(24);
        
    }];
    
    UIButton *backOver = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.headBackView addSubview:backOver];
    
    [backOver mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    
    [backOver addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headBackView addSubview:self.titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.centerX.mas_equalTo(self.avatarView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(16);
        
    }];
    
    [self.headBackView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.right.mas_equalTo(-14);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
    }];
    
    
    UIButton *shareOver = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.headBackView addSubview:shareOver];
    
    [shareOver mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    
    [shareOver addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.avatarView addGestureRecognizer:tap];
}

- (void)tapAction{
    [ZJImageMagnification scanBigImageWithImageView:self.avatarView alpha:1.0f];
}

- (void)backAction{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)shareAction{

    if ([Utils showLoginPageIfNeeded]) {} else {
        
        if (![QQApiInterface isQQInstalled]) {
            [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_QQ];
            [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_Qzone];
        }
        if (![WXApi isWXAppInstalled]) {
            [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession];
            [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatFavorite];
            [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine];
        }
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
        }
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_WechatTimeLine)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
        }];
        
    }
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = self.model.lfacepath;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:self.model.introduction thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@&userid=%@",self.model.shareurl,[User LocalUser].id];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                [Utils postMessage:@"分享成功！" onView:self.view];
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
        }
        
//        [Utils postMessage:error.description onView:self.view];
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.isPersonCenter == YES) {
        
        self.JoinTeamButton.hidden = YES;
        self.chatWithCustomerButton.hidden = YES;
        teamHeader *header = [[teamHeader alloc]init];
        
        header.target = @"ownDControl";
        
        header.method = @"myTeamsDetail";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        teamBody *bodyer = [[teamBody alloc]init];
        
        bodyer.id = [User LocalUser].id;
        
        MyTeamListRequest *requester = [[MyTeamListRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getTeamList:requester.mj_keyValues.mutableCopy];
        
    }else{
    
        self.JoinTeamButton.hidden = NO;
        self.chatWithCustomerButton.hidden = NO;
        teamHeader *header = [[teamHeader alloc]init];
        
        header.target = @"noTokenDControl";
        
        header.method = @"mainTeamsDetail";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        teamBody *bodyer = [[teamBody alloc]init];
        
        bodyer.id = self.teamID;
        
        MyTeamListRequest *requester = [[MyTeamListRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getTeamList:requester.mj_keyValues.mutableCopy];

    }
   
    [self.tableview registerClass:[TeamDesTableViewCell class] forCellReuseIdentifier:@"TeamDesTableViewCell"];

    self.view.backgroundColor = DefaultBackgroundColor;
    
    [self resetHeaderView];
    
    self.tableview.tableHeaderView = self.headBackView;
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(shareAction)];
 
    [self.tableview registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    
    if (self.isPersonCenter == YES) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = AppStyleColor;
        button.titleLabel.font = FontNameAndSize(16);
        [button setTitle:@"团队群聊" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(toChat:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)toChat:(UIButton *)button{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                [User LocalUser].tgroupid = self.gid;
                [User LocalUser].tname = self.model.name;
                [User LocalUser].mdtgroupfacepath = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
                [User saveToDisk];
                ConversationViewController *conver = [[ConversationViewController alloc]init];
                conver.targetId = self.gid;
                conver.conversationType = ConversationType_GROUP;
                conver.title = self.model.name;
                [self.navigationController pushViewController:conver animated:YES];
                NSLog(@"群组ID：%@",self.model.groupid);
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
    });
   
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.listArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        TeamDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamDesTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshSubviewWithModel:self.model];
        return cell;
        
    }else{
        
        TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        memberModel *model = [self.listArr objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:@"TeamDesTableViewCell" cacheByIndexPath:indexPath configuration: ^(TeamDesTableViewCell *cell) {
            [cell refreshSubviewWithModel:self.model];
        }];
        
    }else{
        return 94;
    
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        
        TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];

        memberModel *model = [self.listArr objectAtIndex:indexPath.row];

        if (self.isPersonCenter == YES) {
            
            detail.isPersonCenter = YES;
            
        }else{
        
            detail.isPersonCenter = NO;
            
        }
        
        detail.ID = model.id;
        
        detail.title = @"团队详情";
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    NSLog(@"上下偏移量 OffsetY:%f ->",offset_Y);
    
    //1.处理图片放大
    CGFloat imageH = self.headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    
    //下拉
    if (offset_Y < 0)
    {
        self.backButton.hidden=  NO;
        self.shareButton.hidden = NO;
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;        
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
        [self hiddenNavigationControllerBar:YES];
   
    }else
    {
        self.backButton.hidden=  YES;
        self.shareButton.hidden = YES;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UIImageView *headImage = [[UIImageView alloc]init];
        [bgView addSubview:headImage];
        
        UILabel *nikeName = [[UILabel alloc]init];
        nikeName.textColor = [UIColor whiteColor];
        nikeName.font = Font(14);
        nikeName.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:nikeName];
        [nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.right.mas_equalTo(0);
        }];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.right.mas_equalTo(nikeName.mas_left).mas_equalTo(-5);
            make.width.height.mas_equalTo(30);
        }];
        headImage.layer.cornerRadius = 15;
        headImage.layer.masksToBounds = YES;
        [self hiddenNavigationControllerBar:NO];
        [UIView animateWithDuration:0.3 animations:^{
            self.headImageView.frame = self.headBackView.bounds;
            nikeName.text = self.model.name;
            [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.lfacepath]];
            [self setNavigationtitleView:bgView];
        }];
    }
    
}

- (void)appGroupAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                isjoinHeader *header = [[isjoinHeader alloc]init];
                header.target = @"teamDControl";
                header.method = @"queryJoinTeam";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                isjoinBody *bodyer = [[isjoinBody alloc]init];
                bodyer.id = self.teamID;
                IsJoinTeamRequest *requester = [[IsJoinTeamRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                NSLog(@"%@",requester);
                [self.isjoinApi Isjopin:requester.mj_keyValues.mutableCopy];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
    });
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
            return CGFLOAT_MIN;
    }else{
            return CGFLOAT_MIN;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
    }else{
        
        return nil;
    }
}




@end
