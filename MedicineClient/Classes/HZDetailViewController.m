//
//  HZDetailViewController.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZDetailViewController.h"
#import "HZListDetailModel.h"
#import "HZListdetailApi.h"
#import "HzDetailRequest.h"
#import "AppionmentInfoTableViewCell.h"
#import "AppionmentDetailDesTableViewCell.h"
#import "AppionmentChatTableViewCell.h"
#import "WailtToPayNoticeTableViewCell.h"
#import "FriendCircleCell.h"
#import "AttendCountTableViewCell.h"
#import "OYRPopOption.h"
#import "AttenderViewController.h"
#import "BeginHuizhenViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "FillAdviceViewController.h"
#import "MyHZListViewController.h"
#import "JoinHZapi.h"
#import "JoinHZRequest.h"
#import "MyHZViewController.h"
#import "AttenderViewController.h"
#import "cancelHZapi.h"
#import "cancelHZRequest.h"
#import "queryIsHaveApi.h"
#import "QueryIsExitAgreeBookRequest.h"
#import "GroupInfoModel.h"
#import "getGroupChatListApi.h"
#import "scanAgreebookViewController.h"
#import "AgreeBookModel.h"
#import <RongCallKit/RongCallKit.h>
#import "GroupChatListModel.h"
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "HuizhenConversationViewController.h"
@interface HZDetailViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMUserInfoDataSource>
@property (nonatomic,strong)HZListdetailApi *api;
@property (nonatomic,strong)JoinHZapi *joinApi;
@property (nonatomic,strong)JoinHZapi *notjoinApi;
@property (nonatomic,strong)cancelHZapi *cancelApi;
@property (nonatomic,strong)getGroupChatListApi *chatApi;
@property (nonatomic,strong)HZListDetailModel *model;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIButton *attendButton;
@property (nonatomic,strong)UIButton *notAttendButton;
//
@property (nonatomic,strong)NSArray *itemArr;
@property (nonatomic,strong)NSArray *itemimageArr;
//
@property (nonatomic,strong)queryIsHaveApi *ishave;
//
@property (nonatomic,strong)NSArray *Memberlist;
@property (nonatomic,strong)NSMutableArray *memberlist;
@property (nonatomic,strong)NSMutableArray *groupMemberlist;
@property (nonatomic,strong)GetIMtokenApi *getAllGroupsApi;

@end

@implementation HZDetailViewController

- (UIButton *)attendButton{
    if (!_attendButton) {
        _attendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attendButton.backgroundColor = AppStyleColor;
        [_attendButton setTitle:@"确认参加" forState:UIControlStateNormal];
        [_attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _attendButton;
}

- (UIButton *)notAttendButton{
    if (!_notAttendButton) {
        _notAttendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _notAttendButton.backgroundColor = [UIColor whiteColor];
        [_notAttendButton setTitle:@"不参加" forState:UIControlStateNormal];
        [_notAttendButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
    }
    return _notAttendButton;
}

- (void)AttendUI{
    //判断是客服还是医生用户
    [self.view addSubview:self.attendButton];
    [self.attendButton addTarget:self action:@selector(toAttend) forControlEvents:UIControlEventTouchUpInside];
    [self.notAttendButton addTarget:self action:@selector(nottoAttend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.notAttendButton];
    [self.notAttendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.attendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
}


- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = [UIColor whiteColor];
        _tableview.backgroundColor =DefaultBackgroundColor;
    }
    return _tableview;
}

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (HZListdetailApi *)api{
    if (!_api) {
        _api = [[HZListdetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)refreshWithhuizhenid:(NSString *)huizhenid
                  issystemid:(NSString *)issystem{
    HZListDetailHeader *head = [[HZListDetailHeader alloc]init];
    head.target = @"doctorHuizhenControl";
    head.method = @"doctorHuizhenDetail";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    HZListDetailBody *body = [[HZListDetailBody alloc]init];
    body.id = huizhenid;
    HzDetailRequest *request = [[HzDetailRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api gethzDetail:request.mj_keyValues.mutableCopy];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _api) {
        self.model = responsObject;
        QGBHeader *header = [[QGBHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"queryHuizhenResult";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        QGBBody *bodyer = [[QGBBody alloc]init];
        bodyer.id = self.model.id;
        QueryIsExitAgreeBookRequest *requester = [[QueryIsExitAgreeBookRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.ishave quqryAgreebook:requester.mj_keyValues.mutableCopy];
        if ([self.model.issystem isEqualToString:@"1"]) {  //官方发起的
            self.itemArr = @[@"联系客服"];
            self.itemimageArr = @[@"contactKF"];
            if ([self.model.faqiname isEqualToString:[User LocalUser].name]) {
                self.tableview.tableFooterView = self.footView;
            }else{
                self.tableview.tableFooterView = nil;
            }
        }else{
                                            //不是官方发起的
            if ([self.model.isfaqi isEqualToString:@"0"]) {
                if ([self.model.iscanyu isEqualToString:@"0"]) {
                    [self AttendUI];
                }else{
                    self.itemArr = @[@"改为不参加",@"联系客服"];
                    self.itemimageArr = @[@"bucanjia",@"contactKF"];
                }
            }else{
                self.itemArr = @[@"取消会诊",@"联系客服"];
                self.itemimageArr = @[@"bucanjia",@"contactKF"];
                self.tableview.tableFooterView = self.footView;
            }
        }
        [self.tableview reloadData];
    }
    
    if (api == _joinApi) {
        [Utils postMessage:@"加入成功" onView:self.view];
        [Utils removeHudFromView:self.view];
        self.itemArr = @[@"改为不参加",@"联系客服"];
        self.itemimageArr = @[@"bucanjia",@"contactKF"];
        self.attendButton.hidden = YES;
        self.notAttendButton.hidden = YES;
        [self refreshWithhuizhenid:self.huizhenid issystemid:self.model.issystem];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_refreshHZLIST object:nil];
        
    }
    if (api == _notjoinApi) {
        [Utils postMessage:@"取消加入成功" onView:self.view];
        [Utils removeHudFromView:self.view];
        self.itemArr = @[@"改为参加",@"联系客服"];
        self.itemimageArr = @[@"canjia",@"contactKF"];
        self.attendButton.hidden = YES;
        self.notAttendButton.hidden = YES;
        [self refreshWithhuizhenid:self.huizhenid issystemid:self.model.issystem];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_refreshHZLIST object:nil];
    }
    
    if (api == _cancelApi) {
        [Utils postMessage:@"取消会诊成功" onView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_refreshHZLIST object:nil];
        [Utils removeHudFromView:self.view];
        self.itemArr = @[@"联系客服"];
        self.itemimageArr = @[@"contactKF"];
    }
    
    if (api == _ishave) {
        NSLog(@"%@",responsObject);
        AgreeBookModel *model = responsObject;
        if (model.diagnose.length <= 0) {
            if ([self.model.issystem isEqualToString:@"0"] && [self.model.isfaqi isEqualToString:@"1"]) {
                self.tableview.tableFooterView = self.footView;
            }
        }else{
            self.tableview.tableHeaderView = self.headerView;
        }
    }
    
    if (api == _chatApi) {
        NSLog(@"%@",responsObject);
        self.Memberlist = responsObject;
        self.memberlist = [NSMutableArray array];
        [self.memberlist removeAllObjects];
        self.groupMemberlist  = [NSMutableArray array];
        [self.groupMemberlist removeAllObjects];
        for (GroupChatListModel *model in responsObject) {
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [self.memberlist addObject:user];
            [self.groupMemberlist addObject:model.id];
        }
        [RCCall sharedRCCall].appLocalizedName = @"直医会诊室";
        [[RCCall sharedRCCall] isAudioCallEnabled:ConversationType_GROUP];
        [[RCCall sharedRCCall] isVideoCallEnabled:ConversationType_GROUP];
        for (GroupChatListModel *model in responsObject) {
            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [[RCIM sharedRCIM] setCurrentUserInfo:info];
        }
        if ([self.model.jinru isEqualToString:@"1"]) {
            if ([self.model.issystem isEqualToString:@"1"]) {
                //                [[RCCall sharedRCCall]startMultiCall:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo];
                HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                con.huizhenid = self.model.id;
                con.title = self.model.topic;
                NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                con.displayUserNameInCell = YES;
                con.enableNewComingMessageIcon = YES; //开启消息提醒
                con.enableUnreadMessageIcon = YES;
                con.isGroupCon = YES;
                [self.navigationController pushViewController:con animated:YES];
                
            }else{
                if ([self.model.isfaqi isEqualToString:@"1"]) {
                    //                    [[RCCall sharedRCCall]startMultiCall:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo];
                    HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                    con.huizhenid = self.model.id;
                    con.title = self.model.topic;
                    NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                    con.displayUserNameInCell = YES;
                    con.enableNewComingMessageIcon = YES; //开启消息提醒
                    con.enableUnreadMessageIcon = YES;
                    con.isGroupCon = YES;
                    [self.navigationController pushViewController:con animated:YES];
                }else{
                    HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                    con.huizhenid = self.model.id;
                    con.title = self.model.topic;
                    NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                    con.displayUserNameInCell = YES;
                    con.enableNewComingMessageIcon = YES; //开启消息提醒
                    con.enableUnreadMessageIcon = YES;
                    con.isGroupCon = YES;
                    [self.navigationController pushViewController:con animated:YES];
                    //                    [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo userIdList:self.groupMemberlist];
                    //                    HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                    //                    con.huizhenid = self.model.id;
                    //                    con.title = @"直医会诊群";
                    //                    NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                    //                    [self.navigationController pushViewController:con animated:YES];
                }
            }
        }else{
            [Utils postMessage:@"视频会诊还没开始，暂时不能进行进入" onView:self.view];
        }
    }
    
    if (api == _getAllGroupsApi) {
        NSArray *arr = [GroupInfoModel mj_objectArrayWithKeyValuesArray:responsObject[@"groups"]];
        for (GroupInfoModel *model in arr) {
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = model.groupid;
            group.groupName = model.groupname;
            group.portraitUri = model.groupfacepath;
            [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:model.groupid];
        }
    }
    
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshWithhuizhenid:self.huizhenid issystemid:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.tableview];
    [self layOut];
    //
    [self.tableview registerClass:[AppionmentInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
    [self.tableview registerClass:[AppionmentDetailDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
    [self.tableview registerClass:[WailtToPayNoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
    [self.tableview registerClass:[AppionmentChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
    [self.tableview registerClass:[AttendCountTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AttendCountTableViewCell class])];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"ddd"] highligthtedImage:[UIImage imageNamed:@"ddd"] action:@selector(droupMenu:)];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.model.status isEqualToString:@"1"]) {
        return 6;
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            return 135;
        } else if (indexPath.section == 1) {
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class]) cacheByIndexPath:indexPath configuration:^(AppionmentDetailDesTableViewCell *cell) {
                [cell refreshWIithDetailModel:self.model];
            }];
        } else if(indexPath.section == 2) {
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendCircleCell class]) cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
                [cell cellDataWithAppionmentModel:self.model];
            }];
        }else if(indexPath.section == 3) {
            return 100;
        }else if(indexPath.section == 4) {
            return 94;
        }else{
            return 40;
        }
    }else{
        return 100;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            AppionmentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWIithDetailModel:self.model];
            return cell;
        } else if(indexPath.section == 1) {
            AppionmentDetailDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWIithDetailModel:self.model];
            return cell;
        } else  if(indexPath.section ==2) {
            FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            [cell cellDataWithAppionmentModel:self.model];
            return cell;
        }else  if(indexPath.section == 3) {
            AppionmentChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chat = ^{
                //
            };
            return cell;
        }else  if(indexPath.section == 4) {
            WailtToPayNoticeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *sep = [UIView new];
            sep.backgroundColor = DefaultBackgroundColor;
            [cell addSubview:sep];
            [sep mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1.0);
            }];
            [cell refreshWithAppionmentDetailModel:self.model];
            return cell;
        }else{
            AttendCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AttendCountTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithmodel:self.model];
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            AppionmentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWIithDetailModel:self.model];
            return cell;
        } else if(indexPath.section == 1) {
            AppionmentDetailDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWIithDetailModel:self.model];
            return cell;
        } else  if(indexPath.section ==2) {
            FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            [cell cellDataWithAppionmentModel:self.model];
            return cell;
        }else  if(indexPath.section == 3) {
            AppionmentChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chat = ^{
                //
            };
            return cell;
        }else  if(indexPath.section == 4) {
            WailtToPayNoticeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *sep = [UIView new];
            sep.backgroundColor = DefaultBackgroundColor;
            [cell addSubview:sep];
            [sep mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1.0);
            }];
            [cell refreshWithAppionmentDetailModel:self.model];
            return cell;
        }else{
            AttendCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AttendCountTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithmodel:self.model];
            return cell;
        }
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"1"]) {
        if (indexPath.section == 5) {
            MyHZViewController *list = [MyHZViewController new];
            list.orderStatus = @"1";
            list.huizhnid = self.model.id;
            list.isfaqi = self.model.isfaqi;
            [self.navigationController pushViewController:list animated:YES];
        }else if (indexPath.section == 3){
            QGBHeader *header = [[QGBHeader alloc]init];
            header.target = @"doctorHuizhenControl";
            header.method = @"getMdtGroupMembers";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            QGBBody *bodyer = [[QGBBody alloc]init];
            bodyer.id = self.model.id;
            QueryIsExitAgreeBookRequest *requester = [[QueryIsExitAgreeBookRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.chatApi getlist:requester.mj_keyValues.mutableCopy];
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 0.001;
    } else {
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.001;
    } else {
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    } else {
        return nil;
    }
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end