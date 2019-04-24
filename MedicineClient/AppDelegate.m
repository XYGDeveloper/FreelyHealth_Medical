//
//  AppDelegate.m
//  MedicineClient
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "RootManager.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "FHConst.h"
#import "Url.h"
#import "AgentViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#define RCIM_APPKEY   @"qd46yzrfqel8f"
#import <UMSocialCore/UMSocialCore.h>
#import "Udesk_WHC_HttpManager.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import "UpdateControlManager.h"
#import "AlertView.h"
#import "LoginViewController.h"
#import "RootManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <RongIMKit/RongIMKit.h>
#import "MessageListViewController.h"
#import "TeamIndexViewController.h"
#import "TaskViewController.h"
#import "MessageListViewController.h"
#import "MeViewController.h"
#define LOG_EXPIRE_TIME -7 * 24 * 60 * 60
#define kFetchTag 1000
#import "LYZAdView.h"
#import "AlertView.h"
#import "FFToast.h"
#import "WailtHZViewController.h"
#import "WailtHandleViewController.h"
#import "NottendHzViewController.h"
#import "CancelledHZViewController.h"
#import "FinishHZViewController.h"
#import "NoticeListViewController.h"
#import "RootManager.h"
static NSString *appKey = @"f11fde01629bfc6f71b08680";
static NSString *channel = @"AppStore";
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,UIAlertViewDelegate,BaseMessageViewDelegate,UITabBarDelegate,UITabBarControllerDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,ApiRequestDelegate>
@property(nonatomic,strong)FFToast *popView;
@property(nonatomic,assign)int count;

@end

@implementation AppDelegate


- (GetIMtokenApi *)getAllGroupsApi
{
    if (!_getAllGroupsApi) {
        _getAllGroupsApi = [[GetIMtokenApi alloc]init];
        _getAllGroupsApi.delegate = self;
    }
    return _getAllGroupsApi;
}

- (void)refreshAllgroup{
    getTokenHeader *head = [[getTokenHeader alloc]init];
    head.target = @"doctorHuizhenControl";
    head.method = @"findAllGroups";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    getTokenBody *body = [[getTokenBody alloc]init];
    GetImTokenRequest *request = [[GetImTokenRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.getAllGroupsApi getToken:request.mj_keyValues.mutableCopy];
    
}

- (void)refreshMessagecount{
    
    myMessageHeader *head = [[myMessageHeader alloc]init];
    
    head.target = @"doctorMsgControl";
    
    head.method = @"queryDoctorMsgCounts";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    myMessageBody *body = [[myMessageBody alloc]init];
    
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.listApi getUnreadMessageCounts:request.mj_keyValues.mutableCopy];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _listApi) {
            NSNumber *unreadMessagecount = responsObject[@"doctorMsgCounts"];
            int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                                  getUnreadCount:@[
                                                   @(ConversationType_PRIVATE),
                                                   @(ConversationType_GROUP)
                                                   ]];
        int udeskMessageCOunt = (int)[UdeskManager getLocalUnreadeMessagesCount];
        self.count = unreadMsgCount + udeskMessageCOunt + [unreadMessagecount intValue];
        if(self.count > 0){
            [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",self.count];
        }
    }
    
    if (api == _getAllGroupsApi) {
        NSArray *arr = [GroupInfoModel mj_objectArrayWithKeyValuesArray:responsObject[@"groups"]];
        self.getAllGroups = arr;
        for (GroupInfoModel *model in arr) {
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = model.groupid;
            group.groupName = model.groupname;
            group.portraitUri = model.groupfacepath;
            [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:model.groupid];
        }
    }
    
    //    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:[NSString stringWithFormat:@"您有%d新会诊或转诊消息送达，请点击查看消息",self.count] iconImage:[UIImage imageNamed:@"aboutus"]];
    //    toast.toastType = FFToastTypeSuccess;
    //    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
    //    [toast show:^{
    //        NoticeListViewController *detail = [NoticeListViewController new];
    //        detail.title = @"消息通知";
    //        MyNavigationController *navi =  [RootManager sharedManager].tabbarController.viewControllers[[RootManager sharedManager].tabbarController.selectedIndex];
    //        [navi pushViewController:detail animated:YES];
    //    }];
}

- (getUnreadMessageCounts *)listApi{
    if (!_listApi) {
        _listApi = [[getUnreadMessageCounts alloc]init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"-----------------%@",[User LocalUser].kefu);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 版本更新.
    [[UpdateControlManager sharedUpdate] updateVersion];
    self.window.rootViewController = [RootManager sharedManager].tabbarController;
    [self refreshAllgroup];
    //是否默认进入到控制器
    [[RootManager sharedManager].tabbarController setSelectedIndex:0];
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_CHATROOM),
                                                                         @(ConversationType_GROUP),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_SYSTEM)]];
        dispatch_async(dispatch_get_main_queue(),^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
            [self refreshMessagecount];
        });
    [self makeConfiguration];
    [[RCIM sharedRCIM] initWithAppKey:RCIM_APPKEY];
    [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
        NSLog(@"融云登陆成功：%@",userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云登陆错误：%ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"融云token错误：");
    }];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =
    @[ @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP) ];
    [self setUmeng];
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enableMessageAttachUserInfo =YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[User LocalUser].id name:[User LocalUser].name portrait:[User LocalUser].facepath];

    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"freelyhealth.udesk.cn" appKey:@"e96116c884c1ed66d56dfe6013f20b41" appId:@"6b81c756059b61d3"];
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = [User LocalUser].token;
    customer.nickName = [User LocalUser].name;
    customer.email = [NSString stringWithFormat:@"%@@163.com",[User LocalUser].phone];
    customer.cellphone = [User LocalUser].phone;
    customer.customerDescription = @"医生信息描述";
    [UdeskManager initWithOrganization:organization customer:customer];
    
    UdeskCustomerCustomField *textField = [UdeskCustomerCustomField new];
    textField.fieldKey = @"TextField_20157";
    textField.fieldValue = @"暂无留言";
    UdeskCustomerCustomField *keshiField = [UdeskCustomerCustomField new];
    keshiField.fieldKey = @"TextField_21228";
    keshiField.fieldValue = [User LocalUser].dname;
    
    UdeskCustomerCustomField *tField = [UdeskCustomerCustomField new];
    tField.fieldKey = @"TextField_21230";
    tField.fieldValue = [User LocalUser].tname;
    UdeskCustomerCustomField *hosField = [UdeskCustomerCustomField new];
    hosField.fieldKey = @"TextField_21229";
    hosField.fieldValue = [User LocalUser].hname;
    
    UdeskCustomerCustomField *zhichengField = [UdeskCustomerCustomField new];
    zhichengField.fieldKey = @"TextField_21231";
    zhichengField.fieldValue = [User LocalUser].pname;
    
    UdeskCustomerCustomField *selectField = [UdeskCustomerCustomField new];
    selectField.fieldKey = @"SelectField_10248";
    
    if ([[User LocalUser].sex isEqualToString:@"男"]) {
        selectField.fieldValue = @[@"0"];
    }else{
        selectField.fieldValue = @[@"1"];
    }
    
    customer.customField = @[textField,keshiField,hosField,tField,zhichengField,selectField];
    [UdeskManager updateCustomer:customer];
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        NSLog(@"客服用户自定义字段：%@",responseObject);
    }];
    
    [self.window makeKeyAndVisible];
    
    BOOL isProduction = YES;
#ifdef DEBUG
    NSLog(@"debug");
#else
    
    isProduction = NO;
    
#endif
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            [UdeskManager registerDeviceToken:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [self setJSPushWithToken:[User LocalUser].token];

    [[Udesk_WHC_HttpManager shared]registerNetworkStatusMoniterEvent];

     [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
     [UMConfigure initWithAppkey:@"599fb95f677baa60050017ad" channel:@"App Store"];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toAuth:) name:@"auScuess" object:nil];
    return YES;
}

- (void)setJSPushWithToken:(NSString *)token{
    [JPUSHService setAlias:token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", iResCode, iAlias, seq);
    } seq:1];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)toAuth:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"auScuess"]) {
        if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
            AdViewMessageObject *messageObject = MakeAdViewObject(@"", @"",@"",NO);
            [LYZAdView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:1101];
        }
    }
}

- (void)setUmeng{

    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"599fb93ee88bad50fb000449"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

}

- (void)confitUShareSettings
{
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1wx2193c49f3da9e6b6
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2193c49f3da9e6b6" appSecret:@"8974e4bdac597987ac7e619547023e84" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106299367"/*设置QQ平台的appID*/  appSecret:@"QDppMR28lzvNMrkM" redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"423116775"  appSecret:@"7c8eb9f4c6af9c906308b638d2c573b3" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark --- 配置文件
-(void)makeConfiguration
{
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    
    //所有服务启动前，需要确保执行createUtility
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //appid;
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

}

//设置群组通知消息没有提示音
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCount" object:nil];
        [self refreshMessagecount];
    });
    //当应用处于前台运行，收到消息不会有提示音。
    //  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
    return NO;
    //  }
    //  return NO;
}

- (void)setRcim:(NSString *)rcimAppkey secreat:(NSString *)secreat{
    
    [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        [User LocalUser].id = userId;
        
        [User saveToDisk];
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"登陆的错误码为:%ld", status);
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [User clearLocalUser];
//        [[RCIMClient sharedRCIMClient] disconnect];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
        NSString *content = @"您的帐号在其他手机设备中登录,此设备账号登录被迫下线，需要重新登录账号";
        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"重新登录" rightBtnTitle:@"退出" tag:kFetchTag];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
    }else if (status == ConnectionStatus_DISCONN_EXCEPTION){
//        [[RCIMClient sharedRCIMClient] disconnect];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号被封禁"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
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
        if ([event isEqualToString:@"重新登录"]) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginVC];
            [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
        }
    }
    [messageView hide];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
 
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[@(ConversationType_PRIVATE),
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_CHATROOM),
                                               @(ConversationType_GROUP),
                                               @(ConversationType_APPSERVICE),
                                               @(ConversationType_SYSTEM)]];
        if (unreadMsgCount > 0) {
            application.applicationIconBadgeNumber = unreadMsgCount;
        };
    }
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
        [self insertSharedMessageIfNeed];
    }
    //上线操作，拉取离线消息
    [UdeskManager setupCustomerOnline];
    [application setApplicationIconBadgeNumber:0];
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                          @(ConversationType_DISCUSSION),
                                                                          @(ConversationType_CHATROOM),
                                                                          @(ConversationType_GROUP),
                                                                          @(ConversationType_APPSERVICE),
                                                                          @(ConversationType_SYSTEM)]];
    if (unreadMsgCount > 0) {
        dispatch_async(dispatch_get_main_queue(),^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
            [self refreshMessagecount];
        });
    }
}


//插入分享消息
- (void)insertSharedMessageIfNeed {
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    
    NSArray *sharedMessages = [shareUserDefaults valueForKey:@"sharedMessages"];
    if (sharedMessages.count > 0) {
        for (NSDictionary *sharedInfo in sharedMessages) {
            RCRichContentMessage *richMsg = [[RCRichContentMessage alloc] init];
            richMsg.title = [sharedInfo objectForKey:@"title"];
            richMsg.digest = [sharedInfo objectForKey:@"content"];
            richMsg.url = [sharedInfo objectForKey:@"url"];
            richMsg.imageURL = [sharedInfo objectForKey:@"imageURL"];
            richMsg.extra = [sharedInfo objectForKey:@"extra"];
            RCMessage *message = [[RCIMClient sharedRCIMClient]
                                  insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue]
                                  targetId:[sharedInfo objectForKey:@"targetId"]
                                  sentStatus:SentStatus_SENT
                                  content:richMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCDSharedMessageInsertSuccess" object:message];
        }
        [shareUserDefaults removeObjectForKey:@"sharedMessages"];
        [shareUserDefaults synchronize];
    }
}

//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList =
    [[RCIMClient sharedRCIMClient] getConversationList:@[ @(ConversationType_PRIVATE), @(ConversationType_GROUP) ]];
    
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            } else if (conversation.conversationType == ConversationType_GROUP) {
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager]
                        containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}

- (void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    [self removeExpireLogFiles:documentDirectory];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
- (void)removeExpireLogFiles:(NSString *)logPath {
    //删除超过时间的log文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:logPath error:nil]];
    NSDate *currentDate = [NSDate date];
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:LOG_EXPIRE_TIME];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *fileComp = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    fileComp = [calendar components:unitFlags fromDate:currentDate];
    for (NSString *fileName in fileList) {
        // rcMMddHHmmss.log length is 16
        if (fileName.length != 16) {
            continue;
        }
        if (![[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"rc"]) {
            continue;
        }
        int month = [[fileName substringWithRange:NSMakeRange(2, 2)] intValue];
        int date = [[fileName substringWithRange:NSMakeRange(4, 2)] intValue];
        if (month > 0) {
            [fileComp setMonth:month];
        } else {
            continue;
        }
        if (date > 0) {
            [fileComp setDay:date];
        } else {
            continue;
        }
        NSDate *fileDate = [calendar dateFromComponents:fileComp];
        
        if ([fileDate compare:currentDate] == NSOrderedDescending ||
            [fileDate compare:expireDate] == NSOrderedAscending) {
            [fileManager removeItemAtPath:[logPath stringByAppendingPathComponent:fileName] error:nil];
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_CHATROOM),
                                                                         @(ConversationType_GROUP),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_SYSTEM)]];
    if (unreadMsgCount > 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        [self refreshMessagecount];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_CHATROOM),
                                                                         @(ConversationType_GROUP),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_SYSTEM)]];
    if (unreadMsgCount > 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        [self refreshMessagecount];
    }
    
    [[UpdateControlManager sharedUpdate] updateVersion];

//    [self playSound];
}

- (void)playSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
    AudioServicesPlaySystemSound(1007);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""] stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@",[JPUSHService registrationID]);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    //    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
        [application setApplicationIconBadgeNumber:1];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        /**
         * 统计推送打开率2
         */
        [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
        /**
         * 获取融云推送服务扩展字段2
         */
        NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
        if (pushServiceData) {
            NSLog(@"该远程推送包含来自融云的推送服务");
            for (id key in [pushServiceData allKeys]) {
                NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
            }
        } else {
            NSLog(@"该远程推送不包含来自融云的推送服务");
        }
        if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
            //        [rootViewController addNotificationCount];
        }
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    NSLog(@"%@",notification.alertBody);
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        if ([userInfo[@"forWardTarget"] isEqualToString:@"0001"]) {
                WailtHZViewController *detail = [WailtHZViewController new];
                detail.title = @"会诊详情";
                detail.huizhenid = userInfo[@"mdtid"];
                MyNavigationController *navi =  [RootManager sharedManager].tabbarController.viewControllers[[RootManager sharedManager].tabbarController.selectedIndex];
                [navi pushViewController:detail animated:YES];
          
//            "_j_business" = 1;
//            "_j_msgid" = 1658713880;
//            "_j_uid" = 6921562015;
//            aps =     {
//                alert = "会诊提示：会诊主题：测试1会诊专家：是的等待,崔一,林俊杰,普通医生,。用户：null。会诊时间：2018-05-29 10:00:00。  参会医生需提前半个小时报报道。请登录直医，关注相关进展。如有疑问请咨询客服 /致电400-900-1169。";
//                badge = 5;
//                category = "直医";
//                sound = "";
//            };
//            dstatus = 1;
//            forWardTarget = 0001;
//            mdtid = 289a946b041647e88c710ba4a17545cc;
//            msgid = 2573d51e6f694601bd2f36f7ef403522;
        }

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知-------:%@", [self logDic:userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCount" object:nil];
        //推送送达---------------
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
}

#endif

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
//    for (GroupInfoModel *model in self.getAllGroups) {
//        completion([[RCGroup alloc]initWithGroupId:model.groupid groupName:model.groupname portraitUri:model.groupfacepath]);
//    }
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    
}


@end
