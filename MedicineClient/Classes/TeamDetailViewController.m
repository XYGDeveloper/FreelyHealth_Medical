//
//  TeamDetailViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "TeamDetalModel.h"
#import "TeamDetailApi.h"
#import "UIView+PS.h"
#import "GetTeamDetailRequest.h"
#import "TypeTableViewCell.h"
#import "ExpertInfoTableViewCell.h"
#import <UShareUI/UShareUI.h>
#import "LSProgressHUD.h"
#import "ConversationViewController.h"
#import "YQWaveButton.h"
#import "UIView+AnimationProperty.h"
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "ZJImageMagnification.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "GetAuthStateManager.h"
#import "MyProfileViewController.h"
#define kFetchTag 2000

@interface TeamDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
{
    CGFloat _lastPosition;
}
//@property (nonatomic,strong)PSBottomBar * bottomBar;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UILabel * nikeNameLabel;
@property (nonatomic,strong)UILabel * jopNameLabel;
@property (nonatomic,strong)UILabel * hotelNameLabel;
@property (nonatomic,strong)JGProgressHUD *hud;

@property (nonatomic,strong)UIView * headBackView;

@property (nonatomic,strong)UIImageView * headImageView;

@property (nonatomic,strong)YQWaveButton * backButton;

@property (nonatomic,strong)UILabel * titleView;

@property (nonatomic,strong)YQWaveButton * shareButton;

@property (nonatomic,strong)TeamDetailApi * api;

@property (nonatomic,strong)TeamDetalModel * model;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation TeamDetailViewController

- (TeamDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[TeamDetailApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    [_hud dismissAnimated:YES];
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [_hud dismissAnimated:YES];
    
    self.model = responsObject;
    
    self.nikeNameLabel.text = self.model.name ? self.model.name:@"";
    
    weakify(self);
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]
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
    self.jopNameLabel.text = self.model.dname ? [NSString stringWithFormat:@"%@ | %@",self.model.dname,self.model.job]:[NSString stringWithFormat:@"%@",@""];
    self.hotelNameLabel.text = self.model.hname ?self.model.hname:@"";
    
    [self.tableview reloadData];
    
    
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
        
        _titleView.text = @"";
        
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenNavigationControllerBar:YES];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.hud = [Public hudWhenRequest];

    //请求签名
    teamDetailHeader *header = [[teamDetailHeader alloc]init];
    
    header.target = @"noTokenDControl";
    
    header.method = @"mainDoctorsDetail";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    teamDetailBody *bodyer = [[teamDetailBody alloc]init];
    
    bodyer.id = self.ID;
    
    GetTeamDetailRequest *requester = [[GetTeamDetailRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self.api getTeamDetailList:requester.mj_keyValues.mutableCopy];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hiddenNavigationControllerBar:NO];
    
    //    [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:1]];
    
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = self.model.facepath;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:self.model.introduction thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.model.shareurl;
    
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
                UMSocialLogInfo(@"response message is %@",resp.message);
                [Utils postMessage:@"分享成功！" onView:self.view];
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
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(shareAction)];

    [self.tableview registerClass:[ExpertInfoTableViewCell class] forCellReuseIdentifier:@"time"];

    [self.tableview registerClass:[ExpertInfoTableViewCell class] forCellReuseIdentifier:@"ExpertInfoTableViewCell"];
   
    [self resetHeaderView];
    
    self.tableview.tableHeaderView = self.headBackView;
    
    self.tableview.backgroundColor = DefaultBackgroundColor;
    self.chatButton.backgroundColor = AppStyleColor;
    [self.tableview registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TypeTableViewCell class])];
    
    if (self.isPersonCenter == YES) {
        
        self.chatButton.hidden = NO;
        
    }else if(self.isShow == YES){

        self.chatButton.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.model.menzhen.length >0) {
        return 2;
    }else{
        return 1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 14;
    }else{
        return 0.00001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        UIView *sectionVoiew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 14)];
        
        sectionVoiew.backgroundColor = DefaultBackgroundColor;
        
        return sectionVoiew;
        
    }else{
        
        UIView *sectionVoiew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)];
        
        sectionVoiew.backgroundColor = DefaultBackgroundColor;
        
        return sectionVoiew;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.model.menzhen.length > 0) {
        if (indexPath.section == 0) {
            
            ExpertInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell refreshWirthModeltime:self.model];
            
            return cell;
            
        }else{
            
            ExpertInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertInfoTableViewCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell refreshWirthModel:self.model];
            return cell;
            
        }
    }else{
        
        ExpertInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertInfoTableViewCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshWirthModel:self.model];
        return cell;
        
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.model.menzhen.length > 0) {
        
        if (indexPath.section == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"time" cacheByIndexPath:indexPath configuration:^(id cell) {
                
                [cell refreshWirthModeltime:self.model];
                
            }];
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"ExpertInfoTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                
                [cell refreshWirthModel:self.model];
                
            }];
            
        }
        
    }else{
        
        return [tableView fd_heightForCellWithIdentifier:@"ExpertInfoTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            
            [cell refreshWirthModel:self.model];
            
        }];
        
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
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        self.backButton.hidden = NO;
        self.shareButton.hidden = NO;
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
        [self hiddenNavigationControllerBar:YES];

    }
    else
    {
        self.backButton.hidden = YES;
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
            [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]];
            [self setNavigationtitleView:bgView];
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
        if ([event isEqualToString:@"重新认证"]) {
                MyProfileViewController *profile = [[MyProfileViewController alloc]init];
                profile.title = @"我的资料";
                [self.navigationController pushViewController:profile animated:YES];
        }else{
            
        }
    }
    [messageView hide];
    
}
- (IBAction)ChatWithMecherAction:(id)sender {
    
    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
        if ([auth isEqualToString:@"3"]) {
            ConversationViewController*conversation = [[ConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:self.model.id];
            conversation.targetId = self.model.id;
            conversation.title = self.model.name;
            conversation.isPrivateCon = YES;
            conversation.displayUserNameInCell = YES;
            conversation.enableNewComingMessageIcon = YES; //开启消息提醒
            conversation.enableUnreadMessageIcon = YES;
            [self.navigationController pushViewController:conversation animated:YES];
        }else{
            NSString *content = @"认证任务失败,请尝试重新认证.";
            [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
        }
    }];
 
}



@end
