//
//  MessageViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MessageViewController.h"
#import "GroupViewController.h"
#import "HuizhenConversationViewController.h"
#import "CustomViewController.h"
#define Service_ID    @"KEFU150539755915325"
#import "RootManager.h"
#import "EmptyManager.h"
#import "UpdateControlManager.h"
#import "Udesk.h"
#import "UdeskManager.h"
#import "UdeskTicketViewController.h"
#import "EmptyConversation.h"
#import "InvitorDetailApi.h"
#import "InvitorDetailRequest.h"
#import "InvitorDetailModel.h"
#import "NormalViewController.h"
#import "DeleConversationApi.h"
#import "DeleConversationRequest.h"
#import "DeleGroModel.h"
#import "YQWaveButton.h"
#import "UITabBar+badge.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FFToast.h"
#import "getMessageListApi.h"
#import "MymessageListRequest.h"
#import "MyMessageModel.h"
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "ConversationViewController.h"
typedef void (^normalGroup)();
@interface MessageViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)NSString *tid;

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UILabel *infoCount;

@property(nonatomic, assign) NSUInteger index;

@property(nonatomic, assign) BOOL isClick;

@property (nonatomic,strong)NSMutableArray *list;

@property (nonatomic,strong)NSMutableArray *mem;

@property (nonatomic,strong)InvitorDetailApi *api;

@property (nonatomic,strong)DeleConversationApi *conversationApi;

@property (nonatomic,strong)DeleConversationApi *conversation1Api;

@property (nonatomic,strong)DeleConversationApi *conversation2Api;

@property (nonatomic,strong)InvitorDetailModel *model;

@property (nonatomic,strong)normalGroup normal;

@property (nonatomic, strong) NSString *messageCounter;

@property (nonatomic,strong)getMessageListApi *listApi;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)GetIMtokenApi *getAllGroupsApi;
@property (nonatomic,strong)NSArray *getAllGroups;

- (void)updateBadgeValueForTabBarItem;

@end

@implementation MessageViewController

- (GetIMtokenApi *)getAllGroupsApi
{
    if (!_getAllGroupsApi) {
        _getAllGroupsApi = [[GetIMtokenApi alloc]init];
        _getAllGroupsApi.delegate = self;
    }
    return _getAllGroupsApi;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshConversationTableViewIfNeeded];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [self getGroup];
    [self updateBadgeValueForTabBarItem];
    self.showConversationListWhileLogOut = NO;
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

- (void)getGroup{
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
- (DeleConversationApi *)conversationApi
{
    if (!_conversationApi) {
        _conversationApi = [[DeleConversationApi alloc]init];
        _conversationApi.delegate = self;
    }
    return _conversationApi;
}

- (DeleConversationApi *)conversation1Api
{
    
    if (!_conversation1Api) {
        
        _conversation1Api = [[DeleConversationApi alloc]init];
        
        _conversation1Api.delegate = self;
        
    }
    
    return _conversation1Api;
    
}

- (DeleConversationApi *)conversation2Api
{
    
    if (!_conversation2Api) {
        
        _conversation2Api = [[DeleConversationApi alloc]init];
        
        _conversation2Api.delegate = self;
        
    }
    
    return _conversation2Api;
    
}

- (InvitorDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[InvitorDetailApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
}

- (getMessageListApi *)listApi{
    if (!_listApi) {
        _listApi = [[getMessageListApi alloc]init];
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
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
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
    
    if (api == _conversationApi) {
        
        NSArray *arr = [DeleGroModel mj_objectArrayWithKeyValuesArray:responsObject[@"groupids"]];
        
        for (DeleGroModel *model in arr) {
            
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:model.deletegroupid];
          
            DeleConversationHeader *header = [[DeleConversationHeader alloc]init];
            
            header.target = @"huizhenControl";
            
            header.method = @"flushDelete";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            DeleConversationBody *bodyer = [[DeleConversationBody alloc]init];
            
            bodyer.id = model.deletegroupid;
            
            DeleConversationRequest *requester = [[DeleConversationRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.conversation1Api DeleConversation:requester.mj_keyValues.mutableCopy];
            
        }
    }
    
    NSLog(@"%@",responsObject);
    [self.conversationListTableView.mj_header endRefreshing];
    
 
    if (api == _listApi) {
        NSArray *array = (NSArray *)responsObject;
        NSLog(@"%@",array);
        if (array.count <= 0) {
        } else {
            [self.messageArray removeAllObjects];
            for (MyMessageModel *model in responsObject) {
                if ([model.status isEqualToString:@"0"]) {
                    [self.messageArray addObject:model];
                }
            }
            //            if ([UdeskManager getLocalUnreadeMessagesCount] > 0) {
            //                self.badgeLabel.text = [NSString stringWithFormat:@"%ld",[UdeskManager getLocalUnreadeMessagesCount]];
            //                self.badgeLabel.backgroundColor = DefaultRedTextClor;
            //            }
        }
    }
    
    [self refreshConversationTableViewIfNeeded];
    
    [self.conversationListTableView reloadData];
    
    
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
   
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
    
            [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                                @(ConversationType_DISCUSSION),
                                                @(ConversationType_CHATROOM),
                                                @(ConversationType_GROUP),
                                                @(ConversationType_APPSERVICE),
                                                @(ConversationType_SYSTEM)]];
    }

    return self;

}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    [self updateBadgeValueForTabBarItem];
    NSLog(@"--------jjj-------%@  %@",model.conversationTitle,model.targetId);
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                if (model.conversationType == ConversationType_GROUP) {
                    
//                    if ([model.targetId isEqualToString:[User LocalUser].tgroupid]) {
//                        conversation.title = [User LocalUser].tname;
//                        conversation.targetId = [User LocalUser].tgroupid;
//                        self.tid = model.targetId;
//                    }else{
                    NSUserDefaults *groupObject = [NSUserDefaults standardUserDefaults];
                    NSDictionary *getGroupObject = [groupObject objectForKey:model.targetId];
                    if (getGroupObject[@"huizhenid"]) {
                        HuizhenConversationViewController *conversation = [[HuizhenConversationViewController alloc]init];
                        //                        NSDictionary *dic = @{
                        //                                              @"targetid":self.targetId,
                        //                                              @"huizhenid":self.huizhenid
                        //                                              };
                        if ([getGroupObject[@"targetid"] isEqualToString:model.targetId]) {
                            conversation.targetId = getGroupObject[@"targetid"];
                            conversation.huizhenid = getGroupObject[@"huizhenid"];
                            conversation.title = model.conversationTitle;
                            self.tid = model.targetId;
                            conversation.faqi = getGroupObject[@"faqi"];
                        }
                        conversation.conversationType = model.conversationType;
                        conversation.displayUserNameInCell = YES;
                        conversation.enableNewComingMessageIcon = YES; //开启消息提醒
                        conversation.enableUnreadMessageIcon = YES;
                        conversation.isGroupCon = YES;
                        [self.navigationController pushViewController:conversation animated:YES];
                    }else{
                        ConversationViewController*conversation = [[ConversationViewController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
                        conversation.title = model.conversationTitle;
                        conversation.conversationType = model.conversationType;
                        conversation.targetId = model.targetId;
                        self.tid = model.targetId;
                        conversation.displayUserNameInCell = YES;
                        conversation.enableNewComingMessageIcon = YES; //开启消息提醒
                        conversation.enableUnreadMessageIcon = YES;
                        conversation.isGroupCon = YES;
                        [self.navigationController pushViewController:conversation animated:YES];
                    }
                 
                }else if(model.conversationType == ConversationType_PRIVATE){
                    
                    ConversationViewController*conversation = [[ConversationViewController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
                    conversation.isPrivateCon = YES;
                    conversation.title = model.conversationTitle;
                    conversation.conversationType = model.conversationType;
                    conversation.targetId = model.targetId;
                    conversation.displayUserNameInCell = YES;
                    conversation.enableNewComingMessageIcon = YES; //开启消息提醒
                    conversation.enableUnreadMessageIcon = YES;
                    [self.navigationController pushViewController:conversation animated:YES];

                }else{
                    
//                    HuizhenConversationViewController*conversation = [[HuizhenConversationViewController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
//                    conversation.title = model.conversationTitle;
//                    conversation.conversationType = model.conversationType;
//                    conversation.targetId = model.targetId;
//                    conversation.displayUserNameInCell = YES;
//                    conversation.enableNewComingMessageIcon = YES; //开启消息提醒
//                    conversation.enableUnreadMessageIcon = YES;
//                    [self.navigationController pushViewController:conversation animated:YES];
                }
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self refreshConversationTableViewIfNeeded];
    self.conversationListTableView.tableFooterView = [UIView new];
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    [self.conversationListTableView reloadData];
    //定位未读数会话
    self.index = 0;
    //接收定位到未读数会话的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GotoNextCoversation)
                                                 name:@"GotoNextCoversation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForSharedMessageInsertSuccess)
                                                 name:@"RCDSharedMessageInsertSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"RefreshConversationList"
                                               object:nil];
    
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    
    [self updateBadgeValueForTabBarItem];

    [self.conversationListTableView reloadData];
    // Do any additional setup after loading the view.
    
}

-(void) GotoNextCoversation
{
    NSUInteger i;
    //设置contentInset是为了滚动到底部的时候，避免conversationListTableView自动回滚。
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
    for (i = self.index + 1; i < self.conversationListDataSource.count; i++) {
        RCConversationModel *model = self.conversationListDataSource[i];
        if (model.unreadMessageCount > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            self.index = i;
            [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
    //滚动到起始位置
    if (i >= self.conversationListDataSource.count) {
        //    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        for (i = 0; i < self.conversationListDataSource.count; i++) {
            RCConversationModel *model = self.conversationListDataSource[i];
            if (model.unreadMessageCount > 0) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                self.index = i;
                [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                      atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}

- (void)updateBadgeValueForTabBarItem {
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        int appionmentMessagecount = (int)self.messageArray.count;
        int udeskMessageCount = (int)[UdeskManager getLocalUnreadeMessagesCount];
        if (count > 0) {
            [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count + appionmentMessagecount + udeskMessageCount];
        } else {
            [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = nil;
        }
    });
    
}

- (void)jumpToCustom{

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



- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"------%@",userId);
    
    if ([userId isEqualToString:[User LocalUser].id]) {
        
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].name portrait:[User LocalUser].facepath]);
        
    }else
    {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
    }
    
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
    for (GroupInfoModel *model in self.getAllGroups) {
        NSLog(@"--------%@",model.groupid);
        if ([groupId isEqualToString:model.groupid]) {
            RCGroup *groupinfo = [[RCGroup alloc]initWithGroupId:model.groupid groupName:model.groupname portraitUri:model.groupfacepath];
            completion(groupinfo);
        }
    }
}

//- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
//{
//    
//    if ([groupId isEqualToString:[User LocalUser].tgroupid]) {
//        
//        RCGroup *userInfo = [[RCGroup alloc]init];
//        
//        userInfo.groupId = [User LocalUser].tgroupid;
//        
//        userInfo.groupName = [User LocalUser].tname;
//        
//        userInfo.portraitUri = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
//        
//        return completion(userInfo);
//        
//    }else{
//        
//        RCGroup *userInfo = [[RCGroup alloc]init];
//        
//        userInfo.groupId = [User LocalUser].mdtgroupid;
//        
//        userInfo.groupName = [User LocalUser].mdtgroupname;
//        
//        userInfo.portraitUri = [User LocalUser].mdtgroupfacepath;
//        return completion(userInfo);
//    }
//    
//}


- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    
    
    
}

/*!
 更新SDK中的群组信息缓存
 
 @param groupInfo   需要更新的群组信息
 @param groupId     需要更新的群组ID
 
 @discussion 使用此方法，可以更新SDK缓存的群组信息。
 但是处于性能和使用场景权衡，SDK不会在当前View立即自动刷新（会在切换到其他View的时候再刷新该群组的显示信息）。
 如果您想立即刷新，您可以在会话列表或者会话页面reload强制刷新。
 */
- (void)refreshGroupInfoCache:(RCGroup *)groupInfo
                  withGroupId:(NSString *)groupId{
    
 
}

- (void)refreshCell:(NSNotification *)notify {
    /*
     NSString *row = [notify object];
     RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
     model.unreadMessageCount = 0;
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
     withRowAnimation:UITableViewRowAnimationNone];
     });
     */
    [self refreshConversationTableViewIfNeeded];
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

- (void)notifyUpdateUnreadMessageCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        int appionmentMessagecount = (int)self.messageArray.count;
        int udeskMessageCount = (int)[UdeskManager getLocalUnreadeMessagesCount];
        if (count > 0) {
            [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count + appionmentMessagecount + udeskMessageCount];
        } else {
            [RootManager sharedManager].tabbarController.viewControllers[3].tabBarItem.badgeValue = nil;
        }
    });
    [self playSound];
}

- (void)playSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
    AudioServicesPlaySystemSound(1007);
}

@end
