//
//  MeViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MeViewController.h"
#import "NormalTableViewCell.h"
#import "LoginOutTableViewCell.h"
#import "MyProfileViewController.h"
#import "MyPointsViewController.h"
#import "MyAuswerViewController.h"
#import "MycollectionViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "VersionAlertView.h"
#import "LoginOutApi.h"
#import "LoginOutRequest.h"
#import "MyTeamViewController.h"
#import "NextStepViewController.h"
#import "YQAlertView.h"
#import "MyTeamModel.h"
#import "MyTeamApi.h"
#import "MyTeamListRequest.h"
#import "ReferralViewController.h"
#import "UpdateControlManager.h"
#import "GroupConViewController.h"
#import "MBProgressHUD+BWMExtension.h"
#import "MyGroupConViewController.h"
#import "HClActionSheet.h"
#import "AlertView.h"
#import "LYZAdView.h"
#import "AuthenticationViewController.h"
#import "MyProfilwModel.h"
#import "MyProfileApi.h"
#import "MyProfileRequest.h"
#import "AuthenticationViewController.h"
#import "GetAuthStateManager.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "NoticeListViewController.h"
#import "MyHZViewController.h"
#define kFetchTag 2000
#import "HZDetailViewController.h"
#import "getMessageListApi.h"
#import "MymessageListRequest.h"
#import "MyMessageModel.h"
#import "RootManager.h"
#import "getUnreadMessageCounts.h"
#import "LKBadgeView.h"
#import "BadgeTableViewCell.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
{
    CGFloat _lastPosition;
}
@property (nonatomic,strong)MyProfileApi *Myprofile;
@property (nonatomic,strong)MyProfilwModel *model;
@property (nonatomic,strong)MBProgressHUD * hub;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UIImageView * authView;

@property (nonatomic,strong)UILabel * nikeNameLabel;
@property (nonatomic,strong)UILabel * jopNameLabel;
@property (nonatomic,strong)UILabel * hotelNameLabel;
@property (nonatomic,strong)UILabel * hotelTitleLabel;
@property (nonatomic,strong)UIView * headBackView;
@property (nonatomic,strong)UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)LoginOutApi *loginoutApi;
@property (nonatomic,strong)MyTeamApi * api;
@property (nonatomic,strong)HClActionSheet *loginout;
@property (nonatomic,strong)LKBadgeView *badge;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)getMessageListApi *listApi;
@property (nonatomic,strong)NSMutableArray *messageArray;
@end

@implementation MeViewController

- (MyTeamApi *)api
{
    if (!_api) {
        _api = [[MyTeamApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (MyProfileApi *)Myprofile
{
    if (!_Myprofile) {
        _Myprofile = [[MyProfileApi alloc]init];
        _Myprofile.delegate  =self;
    }
    return _Myprofile;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.tableview.mj_header endRefreshing];
    if (api == _loginoutApi) {
        [User clearLocalUser];
        [[RCIM sharedRCIM] disconnect];
        [Utils removeHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
    }

    if (api == _api) {
        
        [Utils removeHudFromView:self.view];
        if ([command.response.code isEqualToString:@"30008"]) {
            NSString *content = @"您目前没有加入到任何团队,请选择加入团队";
            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不添加" rightBtnTitle:@"加入团队" tag:kFetchTag];
        }
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
        if ([event isEqualToString:@"加入团队"]) {
            [Utils jumpToHomepage];
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
    [self.tableview.mj_header endRefreshing];

    if (api == _loginoutApi) {
        [User clearLocalUser];
        [[RCIMClient sharedRCIMClient] disconnect];
        [Utils removeAllHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
        
    }
    
    if (api == _api) {
        [Utils removeHudFromView:self.view];
        if ([command.response.code isEqualToString:@"10000"]) {
            MyTeamViewController *team = [[MyTeamViewController alloc]init];
            team.isPersonCenter = YES;
            team.title = @"我的团队";
            [self.navigationController pushViewController:team animated:YES];
       
        }else if([command.response.code isEqualToString:@"30008"]) {
            NSString *content = @"您目前没有加入到任何团队,请选择加入团队";
            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不添加" rightBtnTitle:@"加入团队" tag:kFetchTag];
        }
    }
    
    if (api == _Myprofile) {
        MyProfilwModel *model = responsObject;
        [User LocalUser].isauthenticate = model.isauthenticate;
        [User saveToDisk];
        [self resetHeaderView];
    }
    
    if (api == _listApi) {
        NSArray *array = responsObject;
        self.messageArray = [NSMutableArray array];
        [self.messageArray removeAllObjects];
        if (array.count <= 0) {
            self.count = 0;
        } else {
            for (MyMessageModel *model in array) {
                if ([model.status isEqualToString:@"0"]) {
                    [self.messageArray addObject:model];
                }
            }
        }
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE), @(ConversationType_GROUP)
                                                                             ]];
        int udeskUnreadmessagecount =  (int)[UdeskManager getLocalUnreadeMessagesCount];
        self.count = self.messageArray.count + unreadMsgCount + udeskUnreadmessagecount;
        NSLog(@"uuuu%d   %d    %d  ",unreadMsgCount,udeskUnreadmessagecount,self.count);
        [self.tableview reloadData];
        
    }
    [self.tableview reloadData];
}

- (LoginOutApi *)loginoutApi
{
    if (!_loginoutApi) {
        _loginoutApi = [[LoginOutApi alloc]init];
        _loginoutApi.delegate = self;
    }
    return _loginoutApi;
}


- (void)dealloc
{
    _headBackView = nil;
    _headImageView = nil;
}

- (UIView*)headBackView
{
    if (!_headBackView) {
        _headBackView = [UIView new];
        _headBackView.userInteractionEnabled = YES;
        _headBackView.frame = CGRectMake(0, 20, kScreenWidth,250);
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


- (UILabel*)hotelTitleLabel
{
    if (!_hotelTitleLabel) {
        _hotelTitleLabel = [UILabel new];
        _hotelTitleLabel.textAlignment = NSTextAlignmentCenter;
        _hotelTitleLabel.font = FontNameAndSize(20);
        _hotelTitleLabel.textColor = [UIColor whiteColor];
        _hotelTitleLabel.text = @"";
    }
    return _hotelTitleLabel;
}

- (UIImageView*)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _avatarView.image = [UIImage imageNamed:@"me_header"];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.userInteractionEnabled = YES;
        _avatarView.layer.cornerRadius = 40;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.backgroundColor = [UIColor whiteColor];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}
- (UIImageView *)authView{
    if (!_authView) {
        _authView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 80)];
        _authView.contentMode = UIViewContentModeScaleToFill;
        _authView.userInteractionEnabled = YES;
        _authView.backgroundColor = [UIColor whiteColor];
        _authView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _authView;
}

- (UILabel*)nikeNameLabel
{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [UILabel new];
        _nikeNameLabel.textAlignment = NSTextAlignmentCenter;
        _nikeNameLabel.font = FontNameAndSize(18);
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshMessagecount];
    [self.tableview setContentOffset:CGPointMake(0,0) animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
    //请求签名
    if ([User LocalUser].token) {
        profileHeader *header = [[profileHeader alloc]init];
        header.target = @"ownDControl";
        header.method = @"myInfos";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        profileBody *bodyer = [[profileBody alloc]init];
        MyProfileRequest *requester = [[MyProfileRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.Myprofile getProfile:requester.mj_keyValues.mutableCopy];
    }
    
}

- (getMessageListApi *)listApi{
    if (!_listApi) {
        _listApi = [[getMessageListApi alloc]init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (void)refreshMessagecount{
    
    if ([User LocalUser].token) {
        myMessageHeader *head = [[myMessageHeader alloc]init];
        
        head.target = @"doctorMsgControl";
        
        head.method = @"getDoctorMsgList";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        myMessageBody *body = [[myMessageBody alloc]init];
        
        MymessageListRequest *request = [[MymessageListRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.listApi getMessageList:request.mj_keyValues.mutableCopy];
        
    }
 
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenNavigationControllerBar:NO];
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)resetHeaderView
{
    self.headImageView.frame = self.headBackView.bounds;
    [self.headBackView addSubview:self.headImageView];
    [self.headBackView addSubview:self.hotelTitleLabel];
    [self.hotelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headBackView.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(25);
    }];
    
//    self.avatarView.centerX = self.headBackView.centerX;
//    self.avatarView.centerY = self.headBackView.centerY -  HalfF(20);
//    [self.headBackView addSubview:self.avatarView];
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    shadowView.centerX = self.headBackView.centerX;
    shadowView.centerY = self.headBackView.centerY -  HalfF(20);
    shadowView.size = CGSizeMake(80, 80);
    [self.headBackView addSubview:shadowView];
    
    shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    
    shadowView.layer.shadowOpacity = 0.95;
    
    shadowView.layer.shadowRadius = 2.0;
    
    shadowView.layer.cornerRadius = 2.0;
    
    shadowView.clipsToBounds = NO;
    
    [shadowView addSubview:self.avatarView];
    [self.headBackView addSubview:self.authView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toAuth)];
    [self.authView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLogin)];
    self.nikeNameLabel.userInteractionEnabled = YES;
    [self.nikeNameLabel addGestureRecognizer:tapLogin];
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView.mas_bottom).mas_equalTo(-15);
        make.centerX.mas_equalTo(self.headBackView.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
        self.authView.image = [UIImage imageNamed:@"me_toauth"];
    }else if ([[User LocalUser].isauthenticate isEqualToString:@"2"]){
        self.authView.image = [UIImage imageNamed:@"me_authing"];
    }else if ([[User LocalUser].isauthenticate isEqualToString:@"3"]){
        self.authView.image = [UIImage imageNamed:@"me_authed"];
    }else if ([[User LocalUser].isauthenticate isEqualToString:@"4"]){
        self.authView.image = [UIImage imageNamed:@"me_toauth"];
    }
    if (![User LocalUser].token) {
        self.authView.image = [UIImage imageNamed:@""];
        self.authView.backgroundColor = [UIColor clearColor];
        self.authView.userInteractionEnabled = YES;
    }
    if (![User LocalUser].token) {
        self.nikeNameLabel.text = @"登录";
    }else{
        NSRange range = {3,4};
        self.nikeNameLabel.text = [User LocalUser].name.length > 0 ?[User LocalUser].name:[[User LocalUser].phone stringByReplacingCharactersInRange:range withString:@"****"];
    }
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath?[User LocalUser].facepath:@"1.jpg"] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    self.nikeNameLabel.y = CGRectGetMaxY(shadowView.frame) + HalfF(10);
    self.nikeNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 25);
    self.nikeNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.nikeNameLabel];
    
    self.jopNameLabel.text = [User LocalUser].pname && [User LocalUser].dname ? [NSString stringWithFormat:@"%@  %@",[User LocalUser].dname,[User LocalUser].pname]:[NSString stringWithFormat:@"%@%@",@"",@""];
    
    self.jopNameLabel.y = CGRectGetMaxY(self.nikeNameLabel.frame) + HalfF(0);
    self.jopNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 25);
    self.jopNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.jopNameLabel];
    
    self.hotelNameLabel.text = [User LocalUser].hname ? [User LocalUser].hname:@"";
    self.hotelNameLabel.y = CGRectGetMaxY(self.jopNameLabel.frame) + HalfF(0);
    self.hotelNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 25);
    self.hotelNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.hotelNameLabel];
    
}
- (void)toAuth{
    if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
        AuthenticationViewController *auth = [AuthenticationViewController new];
        auth.title = @"认证";
        [self.navigationController pushViewController:auth animated:YES];
    }else{
        MyProfileViewController *profile =[MyProfileViewController new];
        profile.title = @"用户资料编辑";
        [self.navigationController pushViewController:profile animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self resetHeaderView];
    self.tableview.tableHeaderView = self.headBackView;
    self.tableview.backgroundColor = DefaultBackgroundColor;
    self.tableview.separatorColor = RGB(213, 231, 233);
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    footview.backgroundColor = DefaultBackgroundColor;
    self.tableview.tableFooterView = footview;
    if (@available(iOS 11.0, *)){
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //导航
//    [self.navigationController.navigationBar ps_setBackgroundColor:AppStyleColor];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"NormalTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([NormalTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"LoginOutTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LoginOutTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"NormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"message"];
    [self.tableview registerClass:[BadgeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BadgeTableViewCell class])];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableview.separatorColor = HexColorA(0xCFCFCF, 0.6);
    
    [_avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLogin)]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMe:) name:@"auScuess" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLoginOutMe:) name:@"loginOutScuess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageCount:) name:@"messageCount" object:nil];
    
}

- (void)refreshMessageCount:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"messageCount"]) {
        [self refreshMessagecount];
    }
}

- (void)refreshMe:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"auScuess"]) {
        [self resetHeaderView];
        [self.tableview reloadData];
    }
}

- (void)refreshLoginOutMe:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"loginOutScuess"]) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath] placeholderImage:[UIImage imageNamed:@"me_header"]];
        [self resetHeaderView];
        self.count = 0;
        [self.tableview reloadData];
    }
}

- (void)toLogin{
    
    if (![User hasLogin]) {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
            AuthenticationViewController *auth = [AuthenticationViewController new];
            auth.title = @"认证";
            [self.navigationController pushViewController:auth animated:YES];
        }else{
            MyProfileViewController *profile =[MyProfileViewController new];
            profile.title = @"用户资料编辑";
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([User hasLogin]) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return 3;
        }else if (section == 2){
            return 1;
        }else if (section == 3){
            return 3;
        }else{
            return 1;
        }
        
    }else{
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return 3;
        }else if (section == 2){
            return 1;
        }else if (section == 3){
            return 3;
        }else{
            return 0;
        }
    
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([User hasLogin]) {
        if (indexPath.section == 0) {
            BadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BadgeTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWith:@"" textlabeltext:@"我的消息" count:[NSString stringWithFormat:@"%d",self.count]];
            return cell;
        }else if (indexPath.section == 1) {
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"我的资料",@"我的团队",@"我的转诊"];
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            return cell;
            
        }else if (indexPath.section == 2){
            
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"邀请分享"];
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            return cell;
            
        }else if (indexPath.section == 3){
            
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"联系客服",@"检查更新",@"关于我们"];
            self.view.backgroundColor = [UIColor whiteColor];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            NSLog(@"当前应用名称：%@",appCurName);
            // 当前应用软件版本  比如：1.0.1
            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"当前应用软件版本:%@",appCurVersion);
            
            NSString *version = [NSString stringWithFormat:@"v%@",@"1.0.7"];
            
            NSArray *rightText = @[@"400-900-1169",version,@""];
            
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            cell.rightText.text = [rightText objectAtIndex:indexPath.row];
            
            return cell;
            
        }else{
            
            LoginOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LoginOutTableViewCell class])];
            cell.backgroundColor = [UIColor clearColor];
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
            
            [cell refreshWith:[User hasLogin]];
            
            cell.loginOutAc = ^{
                [self.tableview setContentOffset:CGPointMake(0,0) animated:NO];
                self.loginout = [[HClActionSheet alloc] initWithTitle:@"退出登录不会删除数据，下次登录依然使用本账号" style:HClSheetStyleWeiChat itemTitles:@[@"退出登录"]];
                self.loginout.delegate = self;
                self.loginout.tag = 100;
                self.loginout.titleTextColor = DefaultGrayLightTextClor;
                self.loginout.titleTextFont = Font(16);
                self.loginout.itemTextFont = [UIFont systemFontOfSize:16];
                self.loginout.itemTextColor = AppStyleColor;
                self.loginout.cancleTextFont = [UIFont systemFontOfSize:16];
                self.loginout.cancleTextColor = DefaultGrayTextClor;
                [self.loginout didFinishSelectIndex:^(NSInteger index, NSString *title) {
                    NSLog(@"%ld",index);
                    if (index == 0) {
                        [Utils addHudOnView:self.view withTitle:@"正在退出登录中"];
                        LoginOutHeader *header = [[LoginOutHeader alloc]init];
                        
                        header.target = @"loginDControl";
                        
                        header.method = @"logoutD";
                        
                        header.versioncode = Versioncode;
                        
                        header.devicenum = Devicenum;
                        
                        header.fromtype = Fromtype;
                        
                        header.token = [User LocalUser].token;
                        
                        LoginOutBody *bodyer = [[LoginOutBody alloc]init];
                        
                        LoginOutRequest *requester = [[LoginOutRequest alloc]init];
                        
                        requester.head = header;
                        
                        requester.body = bodyer;
                        
                        NSLog(@"%@",requester);
                        
                        [self.loginoutApi LoginOut:requester.mj_keyValues.mutableCopy];
                        self.count = 0;
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = nil;
                        
                    }
                }];
            };
            
            return cell;
            
        }
        
    }else{
        if (indexPath.section == 0) {
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"我的消息"];
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            return cell;

        }else if (indexPath.section == 1) {
            
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"我的资料",@"我的团队",@"我的转诊",@"我发起的会诊"];
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            return cell;
            
        }else if (indexPath.section == 2){
            
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *leftText = @[@"邀请分享"];
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            return cell;
            
        }
        else if (indexPath.section == 3){
            
            NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *leftText = @[@"联系客服",@"检查更新",@"关于我们"];
            
            self.view.backgroundColor = [UIColor whiteColor];
            
            NSString *version = [NSString stringWithFormat:@"v%@",@"1.0.7"];
            
            NSArray *rightText = @[@"400-900-1169",version,@""];
            
            cell.leftText.text = [leftText objectAtIndex:indexPath.row];
            cell.rightText.text = [rightText objectAtIndex:indexPath.row];
            
            return cell;
        
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
            
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([[User LocalUser].isauthenticate isEqualToString:@"4"]) {
            return 55;
        }
        return 13;
    }
    
    return (!section) ? 0.0001f : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([[User LocalUser].isauthenticate isEqualToString:@"4"]) {
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
            contentView.backgroundColor  = DefaultBackgroundColor;
            UIView *stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            [contentView addSubview:stateView];
            stateView.backgroundColor = HexColor(0xfffcdd);
            UIImageView *stateImg = [[UIImageView alloc] init];
            [stateView addSubview:stateImg];
            stateImg.image = [UIImage imageNamed:@"au_failure"];
            stateImg.userInteractionEnabled = YES;
            [stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.centerY.mas_equalTo(stateView.mas_centerY);
                make.width.height.mas_equalTo(20);
            }];
            UILabel *stateLabel = [[UILabel alloc]init];
            [stateView addSubview:stateLabel];
            stateLabel.textColor = HexColor(0xeb6100);
            stateLabel.textAlignment = NSTextAlignmentLeft;
            stateLabel.font  =FontNameAndSize(15);
            stateLabel.text = @"认证任务失败，请尝试重新认证！";
            stateLabel.userInteractionEnabled = YES;
            [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(stateImg.mas_right).mas_equalTo(13);
                make.right.mas_equalTo(-20);
                make.centerY.mas_equalTo(stateView.mas_centerY);
                make.height.mas_equalTo(40);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toAuth1)];
            [contentView addGestureRecognizer:tap];
            return contentView;
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
      
    }else{
        return nil;
    }
}

- (void)toAuth1{
    MyProfileViewController *profile =[MyProfileViewController new];
    profile.title = @"用户资料编辑";
    [self.navigationController pushViewController:profile animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
     if(section == 3){
        return 10.0f;
    }else{
        return 10;
    }
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    //1.处理图片放大
    CGFloat imageH = self.headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    //    UIView *navi =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    //    navi.backgroundColor = AppStyleColor;
    //下拉
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }else{

    }
    
    if (scrollView.contentOffset.y > 20 ) {
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        UIImage *alphaimage = [self imageByApplyingAlpha:(scrollView.contentOffset.y)/100 image:bgImg];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithPatternImage:alphaimage]] forBarMetrics:UIBarMetricsDefault];
    }else{
      
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        if ([Utils showLoginPageIfNeeded]) {} else {
            //我的消息
            NoticeListViewController *messageList = [NoticeListViewController new];
            messageList.title = @"我的消息";
            [self.navigationController pushViewController:messageList animated:YES];
        }
  
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if ([Utils showLoginPageIfNeeded]) {} else {
                    if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
                        AdViewMessageObject *messageObject = MakeAdViewObject(@"", @"",@"",NO);
                        [LYZAdView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:1101];
                    }else{
                        MyProfileViewController *profile = [[MyProfileViewController alloc]init];
                        profile.title = @"我的资料";
                        [self.navigationController pushViewController:profile animated:YES];
                    }
                }
                break;
            }
            case 1:
                
            {
                
                if ([Utils showLoginPageIfNeeded]) {} else {
                    
                    [Utils addHudOnView:self.view];
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
                    
                }
                
                break;
                
            }
            case 2:
            {
                if ([Utils showLoginPageIfNeeded]) {} else {
                    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
                        if ([auth isEqualToString:@"3"]) {
                            ReferralViewController *refre = [[ReferralViewController alloc]init];
                            refre.hidesBottomBarWhenPushed = YES;
                            refre.title = @"我的转诊";
                            [self.navigationController pushViewController:refre animated:YES];
                        }else{
                            NSString *content = @"认证任务失败,请尝试重新认证.";
                            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
                        }
                    }];
               
                }
                break;
            }
           
            default:
                break;
        }
        
    }else if (indexPath.section == 2){
        
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
    
    else if (indexPath.section == 3){
    
        switch (indexPath.row) {
            case 0:
            {
                [Utils callPhoneNumber:@"400-900-1169"];
                break;
            }
                
            case 1:
            {
                [[UpdateControlManager sharedUpdate] updateVersion];
                break;
            }
                
            case 2:
            {
                AboutUsViewController *aboutus = [[AboutUsViewController alloc]init];
                aboutus.title  =@"关于我们";
                [self.navigationController pushViewController:aboutus animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"这个App对我们太有用了" descr:@"医生间学术交流、疑难会诊、病例讨论、双向转诊的工具" thumImage:thumbURL];
    //设置网页地址
   shareObject.webpageUrl = [NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/shareDoctorAppDownload.html?userid=%@",[User LocalUser].id];    //分享消息对象设置分享内容对象
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


@end
