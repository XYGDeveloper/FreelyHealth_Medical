//
//  ConversationViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HuizhenConversationViewController.h"
#import "GroupViewController.h"
#import "CustomViewController.h"
#import "MyProfileViewController.h"
#import "DiseaseProfileViewController.h"
#import "TeamDetailViewController.h"
#import "GroupAllViewController.h"
#import "QueryIsExitAgreeBookRequest.h"
#import "GroupInfoModel.h"
#import "getGroupChatListApi.h"
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "GroupChatListModel.h"
@interface HuizhenConversationViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,ApiRequestDelegate>
@property (nonatomic,strong)getGroupChatListApi *chatApi;
@property (nonatomic,strong)GetIMtokenApi *getAllGroupsApi;
@property (nonatomic,strong)NSMutableArray *memberlist;
@property (nonatomic,strong)NSMutableArray *groupMemberlist;
//
@property (nonatomic,strong)NSArray *Memberlist1;
@property (nonatomic,strong)NSArray *allGroups;

@end

@implementation HuizhenConversationViewController

- (NSMutableArray *)memberlist{
    if (!_memberlist) {
        _memberlist = [NSMutableArray array];
    }
    return _memberlist;
}

- (getGroupChatListApi *)chatApi{
    if (!_chatApi) {
        _chatApi = [[getGroupChatListApi alloc]init];
        _chatApi.delegate = self;
    }
    return _chatApi;
}

- (GetIMtokenApi *)getAllGroupsApi
{
    if (!_getAllGroupsApi) {
        _getAllGroupsApi = [[GetIMtokenApi alloc]init];
        _getAllGroupsApi.delegate = self;
    }
    return _getAllGroupsApi;
}

- (void)getAllgroup{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.isVedioChat == YES) {
//
//    }else{
//        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
//        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
//    }
    
    /**
     *@parameter :将此会诊id保存起来，以便在会话列表中再次进入
     **
     */
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    if (self.conversationType == ConversationType_GROUP) {
        [[RCIM sharedRCIM] setCurrentUserInfo:info];
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        if (self.huizhenid && self.huizhenid.length > 0) {
            NSUserDefaults *groupObject = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = @{
                                  @"targetid":self.targetId,
                                  @"huizhenid":self.huizhenid,
                                  @"faqi":self.faqi
                                  };
            [groupObject setObject:dic forKey:self.targetId];
            QGBHeader *header = [[QGBHeader alloc]init];
            header.target = @"doctorHuizhenControl";
            header.method = @"getMdtGroupMembers";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            QGBBody *bodyer = [[QGBBody alloc]init];
            bodyer.id = self.huizhenid;
            NSLog(@"self.targetId%@",self.targetId);
            QueryIsExitAgreeBookRequest *requester = [[QueryIsExitAgreeBookRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.chatApi getlist:requester.mj_keyValues.mutableCopy];
            
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[[[[[[[[[[[[[[[[[%@",self.chatSessionInputBarControl.pluginBoardView.allItems);

    if (self.isGroupCon == YES) {
        if ([self.faqi isEqualToString:@"1"]) {
            [self setRightNavigationItemWithTitle:@"发起视频" action:@selector(scanGroup)];
        }else{
            [self setRightNavigationItemWithTitle:nil action:nil];
        }
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1102];
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];

    }

    if (self.isPrivateCon == YES) {
        [self setRightNavigationItemWithImage:[UIImage imageNamed:@"person"] highligthtedImage:[UIImage imageNamed:@"person"] action:@selector(scanDetail)];
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1102];
        [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];

    }
    
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    if ([userId isEqualToString:[User LocalUser].id]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [User LocalUser].id;
        user.name = [User LocalUser].name;
        user.portraitUri = [User LocalUser].facepath;
        return completion(user);
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (GroupChatListModel *model in self.Memberlist1) {
                    RCUserInfo *userinfo = [[RCUserInfo alloc]init];
                    userinfo.userId = model.id;
                    userinfo.name = model.name;
                    userinfo.portraitUri = model.facepath;
                    NSLog(@"%@",userinfo.name);
                    [[RCIM sharedRCIM]refreshUserInfoCache:userinfo withUserId:model.id];
                    completion(userinfo);
                }
            });
        });
    }
}

//- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
//{
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
//    }
//
//}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    if ([groupId isEqualToString:[User LocalUser].tgroupid]) {
        for (GroupInfoModel *model in self.allGroups) {
            RCGroup *groupinfo = [[RCGroup alloc]initWithGroupId:model.groupid groupName:model.groupname portraitUri:model.groupfacepath];
            completion(groupinfo);
        }
    }
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    if ([groupId isEqualToString:self.targetId]) {
        resultBlock(self.groupMemberlist);
    }
}

- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    
    NSLog(@"%@",userInfo);
  
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
    
    NSLog(@"%@",groupId);
    
    NSLog(@"%@",groupInfo);
    
}

- (void)scanGroup{
    
//    GroupAllViewController *all = [[GroupAllViewController alloc]init];
//
//    all.targrtid = self.targetId;
//
//    all.title = @"能与会诊的医生";
//
//    [self.navigationController pushViewController:all animated:YES];
    
      [[RCCall sharedRCCall]startMultiCall:ConversationType_GROUP targetId:self.targetId mediaType:RCCallMediaVideo];
    
}

- (void)scanDetail{
    
    TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
    
    detail.isShow = YES;
    
    detail.ID = self.targetId;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)didTapCellPortrait:(NSString *)userId {
    
    if ([userId isEqualToString:[User LocalUser].id]) {
        
        MyProfileViewController *profile = [MyProfileViewController new];
        
        profile.title = @"我的资料";
        
        [self.navigationController pushViewController:profile animated:YES];
        
    }else{
        
        TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
        
        detail.ID = userId;
        
        detail.title = @"团队详情";
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
   
    if (api == _chatApi) {
        NSLog(@"%@",responsObject);
        self.Memberlist1 = responsObject;
        self.memberlist = [NSMutableArray array];
        [self.memberlist removeAllObjects];
        self.groupMemberlist  = [NSMutableArray array];
        [self.groupMemberlist removeAllObjects];
        for (GroupChatListModel *model in responsObject) {
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [self.memberlist addObject:user];
            [self.groupMemberlist addObject:model.id];
        }
        [RCCall sharedRCCall].appLocalizedName = self.title;
        [[RCCall sharedRCCall] isAudioCallEnabled:ConversationType_GROUP];
        [[RCCall sharedRCCall] isVideoCallEnabled:ConversationType_GROUP];
        for (GroupChatListModel *model in responsObject) {
            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [[RCIM sharedRCIM] setCurrentUserInfo:info];
        }
    }
    
    if (api == _getAllGroupsApi) {
        NSArray *arr = [GroupInfoModel mj_objectArrayWithKeyValuesArray:responsObject[@"groups"]];
        self.allGroups = arr;
        for (GroupInfoModel *model in arr) {
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = model.groupid;
            group.groupName = model.groupname;
            group.portraitUri = model.groupfacepath;
            [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:model.groupid];
        }
    }
}



@end
