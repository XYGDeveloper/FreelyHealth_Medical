//
//  WailtHZViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/23.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WailtHZViewController.h"
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
#import "BeginHuizhenViewController.h"
#import "AttenderViewController.h"
@interface WailtHZViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMUserInfoDataSource>
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

@implementation WailtHZViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 67.5)];
        _headerView.backgroundColor = DefaultBackgroundColor;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51.5)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:bgView];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = AppStyleColor;
        label.text = @"会诊意见书";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = FontNameAndSize(16);
        label.userInteractionEnabled = YES;
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        UIImageView *img = [[UIImageView alloc]init];
        [bgView addSubview:img];
        img.userInteractionEnabled = YES;
        img.image = [UIImage imageNamed:@"agreebook"];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _headerView;
}

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

- (HZListdetailApi *)api{
    if (!_api) {
        _api = [[HZListdetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (JoinHZapi *)joinApi{
    if (!_joinApi) {
        _joinApi = [[JoinHZapi alloc]init];
        _joinApi.delegate = self;
    }
    return _joinApi;
}

- (JoinHZapi *)notjoinApi{
    if (!_notjoinApi) {
        _notjoinApi = [[JoinHZapi alloc]init];
        _notjoinApi.delegate = self;
    }
    return _notjoinApi;
}

- (cancelHZapi *)cancelApi{
    if (!_cancelApi) {
        _cancelApi = [[cancelHZapi alloc]init];
        _cancelApi.delegate = self;
    }
    return _cancelApi;
}

- (queryIsHaveApi *)ishave{
    if (!_ishave) {
        _ishave = [[queryIsHaveApi alloc]init];
        _ishave.delegate = self;
    }
    return _ishave;
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
        if ([self.model.status isEqualToString:@"1"]) {
            if ([self.model.issystem isEqualToString:@"1"]) {               //系统发起的（本人是系统，其他医生是系统）
                if ([self.model.isfaqi isEqualToString:@"1"]) {
                    if ([self.model.jinru isEqualToString:@"0"]) {
                        self.tableview.tableFooterView = nil;
                    }else{
                        self.tableview.tableFooterView = self.footView;
                    }
                    self.itemArr = @[@"添加成员",@"修改会诊",@"取消会诊",@"联系客服"];
                    self.itemimageArr = @[@"addMember",@"modifyHZ",@"bucanjia",@"contactKF"];
                 
                }else{
                    self.itemArr = @[@"联系客服"];
                    self.itemimageArr = @[@"contactKF"];
                }
            }else{                                       //不是官方发起的
                if ([self.model.isfaqi isEqualToString:@"0"]) {
                    if ([self.model.iscanyu isEqualToString:@"D"]) {
                        [self isAttend];
                        self.itemArr = @[@"联系客服"];
                        self.itemimageArr = @[@"contactKF"];
                    }else if([self.model.iscanyu isEqualToString:@"1"]){
                        self.itemArr = @[@"改为不参加",@"联系客服"];
                        self.itemimageArr = @[@"bucanjia",@"contactKF"];
                    }else{
                        self.itemArr = @[@"改为参加",@"联系客服"];
                        self.itemimageArr = @[@"canjia",@"contactKF"];
                    }
                }else{
                    if ([self.model.jinru isEqualToString:@"0"]) {
                        self.tableview.tableFooterView = nil;
                    }else{
                        self.tableview.tableFooterView = self.footView;
                    }
                    self.itemArr = @[@"添加成员",@"修改会诊",@"取消会诊",@"联系客服"];
                    self.itemimageArr = @[@"addMember",@"modifyHZ",@"bucanjia",@"contactKF"];
                }
            }
        }else if ([self.model.status isEqualToString:@"2"] || [self.model.status isEqualToString:@"3"]){
            self.tableview.tableFooterView = nil;
            self.itemArr = @[@"联系客服"];
            self.itemimageArr = @[@"contactKF"];
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
        [self refreshWithhuizhenid:self.huizhenid issystemid:nil];
    }
    
    if (api == _ishave) {
        NSLog(@"%@",responsObject);
        AgreeBookModel *model = responsObject;
        if (model.diagnose.length > 0) {
            if ([self.model.status isEqualToString:@"3"] ) {
                self.tableview.tableHeaderView = self.headerView;
            }
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
        for (GroupChatListModel *model in responsObject) {
            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [[RCIM sharedRCIM] setCurrentUserInfo:info];
        }
        
        if ([self.model.jinru isEqualToString:@"1"]) {
            if ([self.model.iscanyu isEqualToString:@"0"] || [self.model.iscanyu isEqualToString:@"D"]) {
                [Utils postMessage:@"选择参加才能进入会诊哦" onView:self.view];
                return;
            }else{
                if ([self.model.issystem isEqualToString:@"1"]) {
                    if ([self.model.isfaqi isEqualToString:@"1"]) {
                        HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                        con.huizhenid = self.model.id;
                        con.title = self.model.topic;
                        NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                        con.displayUserNameInCell = YES;
                        con.enableNewComingMessageIcon = YES; //开启消息提醒
                        con.enableUnreadMessageIcon = YES;
                        con.isGroupCon = YES;
                        con.faqi = @"1";
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
                        con.faqi = @"0";
                        [self.navigationController pushViewController:con animated:YES];
                    }
                }else{
                    if ([self.model.isfaqi isEqualToString:@"1"]) {
                        HuizhenConversationViewController *con = [[HuizhenConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
                        con.huizhenid = self.model.id;
                        con.title = self.model.topic;
                        NSLog(@"self.model.mdtgroupid:%@",self.model.id);
                        con.displayUserNameInCell = YES;
                        con.enableNewComingMessageIcon = YES; //开启消息提醒
                        con.enableUnreadMessageIcon = YES;
                        con.isGroupCon = YES;
                        con.faqi = @"1";
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
                        con.faqi = @"0";
                        [self.navigationController pushViewController:con animated:YES];
                    }
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

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        _footView.backgroundColor = [UIColor clearColor];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = AppStyleColor;
        _button.layer.cornerRadius = 6;
        _button.layer.masksToBounds = YES;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"会诊意见书" forState:UIControlStateNormal];
        [_footView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.footView.mas_centerY);
            make.height.mas_equalTo(50);
        }];
        [_button addTarget:self action:@selector(fillAgreeBook) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

//查看会诊意见书
- (void)scanAgreebook{
    scanAgreebookViewController *huizhenAgreebook = [scanAgreebookViewController new];
    huizhenAgreebook.title = @"会诊意见书";
    huizhenAgreebook.huizhenid = self.model.id;
    [self.navigationController pushViewController:huizhenAgreebook animated:YES];
}

- (void)fillAgreeBook{
    FillAdviceViewController *fill = [FillAdviceViewController new];
    fill.huizhenid = self.model.id;
    fill.title = @"填写会诊意见书";
    [self.navigationController pushViewController:fill animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.model.status isEqualToString:@"1"]) {
        return 6;
    }else if ([self.model.status isEqualToString:@"2"]){
        return 5;
    }else{
        return 5;
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
            return 110;
        }else{
            return 40;
        }
    }else if ([self.model.status isEqualToString:@"2"]){
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
            return 110;
        }else{
            return 40;
        }
    }else{
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
            return 110;
        }else{
            return 40;
        }
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
    }else if ([self.model.status isEqualToString:@"2"]){
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
    }else if ([self.model.status isEqualToString:@"2"]){
        if (indexPath.section == 4) {
            MyHZViewController *list = [MyHZViewController new];
            list.orderStatus = @"1";
            list.huizhnid = self.model.id;
            list.isfaqi = self.model.isfaqi;
            [self.navigationController pushViewController:list animated:YES];
        }
    }else{
        if (indexPath.section == 4) {
            MyHZViewController *list = [MyHZViewController new];
            list.orderStatus = @"1";
            list.huizhnid = self.model.id;
            list.isfaqi = self.model.isfaqi;
            [self.navigationController pushViewController:list animated:YES];
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

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)droupMenu:(UIButton *)optionButton{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect frame = [optionButton convertRect:optionButton.bounds toView:window];
    OYRPopOption *s = [[OYRPopOption alloc] initWithFrame:CGRectMake(0,-24, kScreenWidth, kScreenHeight + 24)];
    if ([self.model.status isEqualToString:@"1"]) {
        if ([self.model.issystem isEqualToString:@"1"]) {               //系统发起的（本人是系统，其他医生是系统）
            if ([self.model.isfaqi isEqualToString:@"1"]) {
                s.option_optionContents = self.itemArr;
                s.option_optionImages = self.itemimageArr;
                // 使用链式语法直接展示 无需再写 [s option_show];
                [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                    if ([content isEqualToString:@"取消会诊"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"取消会诊后，接收人不再接收到会诊信息" preferredStyle:UIAlertControllerStyleAlert];
                        //添加的输入框
                        //WS(weakSelf);
                        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"理由";
                            NSLog(@"%@",textField);
                        }];
                        UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            UITextField *userNameTextField = alert.textFields.firstObject;
                            NSLog(@"理由%@",userNameTextField.text);
                            //取消会诊
                            [Utils addHudOnView:self.view];
                            cancelHeader *header = [[cancelHeader alloc]init];
                            header.target = @"doctorHuizhenControl";
                            header.method = @"doctorCancelHuizhenYuyue";
                            header.versioncode = Versioncode;
                            header.devicenum = Devicenum;
                            header.fromtype = Fromtype;
                            header.token = [User LocalUser].token;
                            cancelBody *bodyer = [[cancelBody alloc]init];
                            bodyer.id = self.model.id;
                            bodyer.reason = userNameTextField.text;
                            cancelHZRequest *requester = [[cancelHZRequest alloc]init];
                            requester.head = header;
                            requester.body = bodyer;
                            [self.cancelApi cancelHZ:requester.mj_keyValues.mutableCopy];
                            
                        }];
                        
                        [alert addAction:Action];
                        [alert addAction:twoAc];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }else if ([content isEqualToString:@"联系客服"]){
                        [Utils callPhoneNumber:@"400-900-1169"];
                    }else if ([content isEqualToString:@"修改会诊"]){
                        BeginHuizhenViewController *begin = [BeginHuizhenViewController new];
                        begin.hzid = self.model.id;
                        begin.isModify = YES;
                        begin.title = @"修改会诊";
                        [self.navigationController pushViewController:begin animated:YES];
                        
//                        [Utils callPhoneNumber:@"400-900-1169"];
                    }else if ([content isEqualToString:@"添加成员"]){
                        AttenderViewController *attend = [AttenderViewController new];
                        attend.isModify = YES;
                        attend.huizhenID = self.model.id;
                        attend.title = @"会诊邀请";
                        [self.navigationController pushViewController:attend animated:YES];
                    }
                } whichFrame:frame animate:YES] option_show];
                
            }else{
                s.option_optionContents = self.itemArr;
                s.option_optionImages = self.itemimageArr;
                // 使用链式语法直接展示 无需再写 [s option_show];
                [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                    if ([content isEqualToString:@"联系客服"]) {
                        [Utils callPhoneNumber:@"400-900-1169"];
                    }
                } whichFrame:frame animate:YES] option_show];
            }
        }else{                                       //不是官方发起的
            if ([self.model.isfaqi isEqualToString:@"0"]) {
                if ([self.model.iscanyu isEqualToString:@"D"]) {
                    s.option_optionContents = self.itemArr;
                    s.option_optionImages = self.itemimageArr;
                    // 使用链式语法直接展示 无需再写 [s option_show];
                    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                        if ([content isEqualToString:@"联系客服"]) {
                            [Utils callPhoneNumber:@"400-900-1169"];
                        }
                    } whichFrame:frame animate:YES] option_show];
                }else if([self.model.iscanyu isEqualToString:@"1"]){
                    s.option_optionContents = self.itemArr;
                    s.option_optionImages = self.itemimageArr;
                    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                        if ([content isEqualToString:@"联系客服"]) {
                            [Utils callPhoneNumber:@"400-900-1169"];
                            
                        }else if ([content isEqualToString:@"改为不参加"]){
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认不参加该会诊？" preferredStyle:UIAlertControllerStyleAlert];
                            
                            //添加的输入框
                            //WS(weakSelf);
                            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                textField.placeholder = @"理由";
                                NSLog(@"%@",textField);
                            }];
                            UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                UITextField *userNameTextField = alert.textFields.firstObject;
                                NSLog(@"得到不参加会诊理由%@",userNameTextField.text);
                                [Utils addHudOnView:self.view];
                                joinHZHeader *header = [[joinHZHeader alloc]init];
                                
                                header.target = @"doctorHuizhenControl";
                                
                                header.method = @"controlCanyu";
                                
                                header.versioncode = Versioncode;
                                
                                header.devicenum = Devicenum;
                                
                                header.fromtype = Fromtype;
                                
                                header.token = [User LocalUser].token;
                                
                                joinHZBody *bodyer = [[joinHZBody alloc]init];
                                bodyer.iscanyu = @"0";
                                bodyer.id = self.model.id;
                                bodyer.refuse = userNameTextField.text;
                                JoinHZRequest *requester = [[JoinHZRequest alloc]init];
                                requester.head = header;
                                requester.body = bodyer;
                                
                                [self.notjoinApi joinHZ:requester.mj_keyValues.mutableCopy];
                            }];
                            
                            [alert addAction:Action];
                            [alert addAction:twoAc];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    } whichFrame:frame animate:YES]option_show];
                }else{
                    s.option_optionContents =  self.itemArr;
                    s.option_optionImages = self.itemimageArr;
                    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                        if ([content isEqualToString:@"联系客服"]) {
                            [Utils callPhoneNumber:@"400-900-1169"];
                        }else if ([content isEqualToString:@"改为参加"]){
                            [Utils addHudOnView:self.view];
                            joinHZHeader *header = [[joinHZHeader alloc]init];
                            header.target = @"doctorHuizhenControl";
                            header.method = @"controlCanyu";
                            header.versioncode = Versioncode;
                            header.devicenum = Devicenum;
                            header.fromtype = Fromtype;
                            header.token = [User LocalUser].token;
                            joinHZBody *bodyer = [[joinHZBody alloc]init];
                            bodyer.iscanyu = @"1";
                            bodyer.id = self.model.id;
                            JoinHZRequest *requester = [[JoinHZRequest alloc]init];
                            requester.head = header;
                            requester.body = bodyer;
                            [self.joinApi joinHZ:requester.mj_keyValues.mutableCopy];
                        }
                    } whichFrame:frame animate:YES]option_show];
                }
            }else{
                s.option_optionContents = self.itemArr;
                s.option_optionImages = self.itemimageArr;
                // 使用链式语法直接展示 无需再写 [s option_show];
                [[s option_setupPopOption:^(NSInteger index, NSString *content) {
                    if ([content isEqualToString:@"联系客服"]) {
                        [Utils callPhoneNumber:@"400-900-1169"];
                    }else if ([content isEqualToString:@"修改会诊"]){
                        BeginHuizhenViewController *begin = [BeginHuizhenViewController new];
                        begin.hzid = self.model.id;
                        begin.isModify = YES;
                        begin.title = @"修改会诊";
                        [self.navigationController pushViewController:begin animated:YES];
                        
                        //                        [Utils callPhoneNumber:@"400-900-1169"];
                    }else if([content isEqualToString:@"取消会诊"]){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"取消会诊后，接收人不再接收到会诊信息" preferredStyle:UIAlertControllerStyleAlert];
                        //添加的输入框
                        //WS(weakSelf);
                        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"理由";
                            NSLog(@"%@",textField);
                        }];
                        UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            UITextField *userNameTextField = alert.textFields.firstObject;
                            NSLog(@"理由%@",userNameTextField.text);
                            //取消会诊
                            [Utils addHudOnView:self.view];
                            cancelHeader *header = [[cancelHeader alloc]init];
                            header.target = @"doctorHuizhenControl";
                            header.method = @"doctorCancelHuizhenYuyue";
                            header.versioncode = Versioncode;
                            header.devicenum = Devicenum;
                            header.fromtype = Fromtype;
                            header.token = [User LocalUser].token;
                            cancelBody *bodyer = [[cancelBody alloc]init];
                            bodyer.id = self.model.id;
                            bodyer.reason = userNameTextField.text;
                            cancelHZRequest *requester = [[cancelHZRequest alloc]init];
                            requester.head = header;
                            requester.body = bodyer;
                            [self.cancelApi cancelHZ:requester.mj_keyValues.mutableCopy];
                            
                        }];
                        
                        [alert addAction:Action];
                        [alert addAction:twoAc];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }else if ([content isEqualToString:@"添加成员"]){
                        AttenderViewController *attend = [AttenderViewController new];
                        attend.isModify = YES;
                        attend.huizhenID = self.model.id;
                        attend.title = @"会诊邀请";
                        [self.navigationController pushViewController:attend animated:YES];
                    }
                } whichFrame:frame animate:YES] option_show];
            }
        }
    }else if ([self.model.status isEqualToString:@"2"] || [self.model.status isEqualToString:@"3"]){
        s.option_optionContents = self.itemArr;
        s.option_optionImages = self.itemimageArr;
        // 使用链式语法直接展示 无需再写 [s option_show];
        [[s option_setupPopOption:^(NSInteger index, NSString *content) {
            if ([content isEqualToString:@"联系客服"]) {
                [Utils callPhoneNumber:@"400-900-1169"];
            }
        } whichFrame:frame animate:YES] option_show];
    }
    
//
//
//    if ([self.model.issystem isEqualToString:@"1"]) {  //官方发起的
//        if ([self.model.isfaqi isEqualToString:@"1"]) {
//            self.tableview.tableFooterView = self.footView;
//            self.itemArr = @[@"取消会诊",@"联系客服"];
//            self.itemimageArr = @[@"bucanjia",@"contactKF"];
//            self.tableview.tableFooterView = self.footView;
//
//            s.option_optionContents = self.itemArr;
//            s.option_optionImages = self.itemimageArr;
//            // 使用链式语法直接展示 无需再写 [s option_show];
//            [[s option_setupPopOption:^(NSInteger index, NSString *content) {
//                if ([content isEqualToString:@"联系客服"]) {
//                    [Utils callPhoneNumber:@"400-900-1169"];
//                }else{
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"取消会诊后，接收人不再接收到会诊信息" preferredStyle:UIAlertControllerStyleAlert];
//                    //添加的输入框
//                    //WS(weakSelf);
//                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                        textField.placeholder = @"理由";
//                        NSLog(@"%@",textField);
//                    }];
//                    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    }];
//                    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                        UITextField *userNameTextField = alert.textFields.firstObject;
//                        NSLog(@"理由%@",userNameTextField.text);
//                        //取消会诊
//                        [Utils addHudOnView:self.view];
//                        cancelHeader *header = [[cancelHeader alloc]init];
//                        header.target = @"doctorHuizhenControl";
//                        header.method = @"doctorCancelHuizhenYuyue";
//                        header.versioncode = Versioncode;
//                        header.devicenum = Devicenum;
//                        header.fromtype = Fromtype;
//                        header.token = [User LocalUser].token;
//                        cancelBody *bodyer = [[cancelBody alloc]init];
//                        bodyer.id = self.model.id;
//                        bodyer.reason = userNameTextField.text;
//                        cancelHZRequest *requester = [[cancelHZRequest alloc]init];
//                        requester.head = header;
//                        requester.body = bodyer;
//                        [self.cancelApi cancelHZ:requester.mj_keyValues.mutableCopy];
//
//                    }];
//
//                    [alert addAction:Action];
//                    [alert addAction:twoAc];
//
//                    [self presentViewController:alert animated:YES completion:nil];
//                }
//            } whichFrame:frame animate:YES] option_show];
//        }else{
//            s.option_optionContents = self.itemArr;
//            s.option_optionImages = self.itemimageArr;
//            // 使用链式语法直接展示 无需再写 [s option_show];
//            [[s option_setupPopOption:^(NSInteger index, NSString *content) {
//                if (index == 0) {
//                    [Utils callPhoneNumber:@"400-900-1169"];
//                }
//            } whichFrame:frame animate:YES] option_show];
//        }
//    }else{                                       //不是官方发起的
//        if ([self.model.isfaqi isEqualToString:@"0"]) {
//                if ([self.model.iscanyu isEqualToString:@"0"]) {
//                    s.option_optionContents =  self.itemArr;
//                    s.option_optionImages = self.itemimageArr;
//                    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
//                        if ([content isEqualToString:@"联系客服"]) {
//                            [Utils callPhoneNumber:@"400-900-1169"];
//
//                        }else if ([content isEqualToString:@"改为参加"]){
//                            [Utils addHudOnView:self.view];
//                            joinHZHeader *header = [[joinHZHeader alloc]init];
//                            header.target = @"doctorHuizhenControl";
//                            header.method = @"controlCanyu";
//                            header.versioncode = Versioncode;
//                            header.devicenum = Devicenum;
//                            header.fromtype = Fromtype;
//                            header.token = [User LocalUser].token;
//                            joinHZBody *bodyer = [[joinHZBody alloc]init];
//                            bodyer.iscanyu = @"1";
//                            bodyer.id = self.model.id;
//                            JoinHZRequest *requester = [[JoinHZRequest alloc]init];
//                            requester.head = header;
//                            requester.body = bodyer;
//                            [self.joinApi joinHZ:requester.mj_keyValues.mutableCopy];
//                        }
//                    } whichFrame:frame animate:YES]option_show];
//                }else{
//                    s.option_optionContents = self.itemArr;
//                    s.option_optionImages = self.itemimageArr;
//                    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
//                        if ([content isEqualToString:@"联系客服"]) {
//                            [Utils callPhoneNumber:@"400-900-1169"];
//
//                        }else if ([content isEqualToString:@"改为不参加"]){
//                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认不参加该会诊？" preferredStyle:UIAlertControllerStyleAlert];
//
//                            //添加的输入框
//                            //WS(weakSelf);
//                            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                                textField.placeholder = @"理由";
//                                NSLog(@"%@",textField);
//                            }];
//                            UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                            }];
//                            UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                                UITextField *userNameTextField = alert.textFields.firstObject;
//                                NSLog(@"得到不参加会诊理由%@",userNameTextField.text);
//                                [Utils addHudOnView:self.view];
//                                joinHZHeader *header = [[joinHZHeader alloc]init];
//
//                                header.target = @"doctorHuizhenControl";
//
//                                header.method = @"controlCanyu";
//
//                                header.versioncode = Versioncode;
//
//                                header.devicenum = Devicenum;
//
//                                header.fromtype = Fromtype;
//
//                                header.token = [User LocalUser].token;
//
//                                joinHZBody *bodyer = [[joinHZBody alloc]init];
//                                bodyer.iscanyu = @"0";
//                                bodyer.id = self.model.id;
//                                bodyer.refuse = userNameTextField.text;
//                                JoinHZRequest *requester = [[JoinHZRequest alloc]init];
//                                requester.head = header;
//                                requester.body = bodyer;
//
//                                [self.notjoinApi joinHZ:requester.mj_keyValues.mutableCopy];
//                            }];
//
//                            [alert addAction:Action];
//                            [alert addAction:twoAc];
//
//                            [self presentViewController:alert animated:YES completion:nil];
//                        }
//                    } whichFrame:frame animate:YES]option_show];
//                }
//        }else{
//            s.option_optionContents = self.itemArr;
//            s.option_optionImages = self.itemimageArr;
//            [[s option_setupPopOption:^(NSInteger index, NSString *content) {
//                if ([content isEqualToString:@"联系客服"]) {
//                    [Utils callPhoneNumber:@"400-900-1169"];
//
//                }else if ([content isEqualToString:@"修改会诊"]){
////                    [Utils postMessage:@"正在开发中" onView:self.view];
//                }else if ([content isEqualToString:@"取消会诊"]){
//
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"取消会诊后，接收人不再接收到会诊信息" preferredStyle:UIAlertControllerStyleAlert];
//                    //添加的输入框
//                    //WS(weakSelf);
//                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                        textField.placeholder = @"理由";
//                        NSLog(@"%@",textField);
//                    }];
//                    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    }];
//                    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                        UITextField *userNameTextField = alert.textFields.firstObject;
//                        NSLog(@"理由%@",userNameTextField.text);
//                        //取消会诊
//                        [Utils addHudOnView:self.view];
//                        cancelHeader *header = [[cancelHeader alloc]init];
//                        header.target = @"doctorHuizhenControl";
//                        header.method = @"doctorCancelHuizhenYuyue";
//                        header.versioncode = Versioncode;
//                        header.devicenum = Devicenum;
//                        header.fromtype = Fromtype;
//                        header.token = [User LocalUser].token;
//                        cancelBody *bodyer = [[cancelBody alloc]init];
//                        bodyer.id = self.model.id;
//                        bodyer.reason = userNameTextField.text;
//                        cancelHZRequest *requester = [[cancelHZRequest alloc]init];
//                        requester.head = header;
//                        requester.body = bodyer;
//                        [self.cancelApi cancelHZ:requester.mj_keyValues.mutableCopy];
//
//                    }];
//
//                    [alert addAction:Action];
//                    [alert addAction:twoAc];
//
//                    [self presentViewController:alert animated:YES completion:nil];
//
//                }
////                else{
////                    AttenderViewController *attend = [AttenderViewController new];
////                    attend.huizhenID = self.model.id;
////                    [self.navigationController pushViewController:attend animated:YES];
////                }
//            } whichFrame:frame animate:YES]option_show];
//        }
//
//    }
    
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
    body.issystem = issystem;
    HzDetailRequest *request = [[HzDetailRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api gethzDetail:request.mj_keyValues.mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils addHudOnView:self.view];
  
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"ddd"] highligthtedImage:[UIImage imageNamed:@"ddd"] action:@selector(droupMenu:)];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    NSLog(@",,,,,,,,,,%@   %@",self.huizhenid,self.model.issystem);
    [self refreshWithhuizhenid:self.huizhenid issystemid:self.model.issystem];
    self.view.backgroundColor = DefaultBackgroundColor;
    [Utils addHudOnView:self.view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanAgreebook)];
    [self.headerView addGestureRecognizer:tap];
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[AppionmentInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
    [self.tableview registerClass:[AppionmentDetailDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
    [self.tableview registerClass:[WailtToPayNoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
    [self.tableview registerClass:[AppionmentChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
    [self.tableview registerClass:[AttendCountTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AttendCountTableViewCell class])];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    //    self.tableview.tableFooterView = self.footView;
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
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
//    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
}

- (void)isAttend{
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

//参加会诊
- (void)toAttend{
    [Utils addHudOnView:self.view];
    joinHZHeader *header = [[joinHZHeader alloc]init];
    header.target = @"doctorHuizhenControl";
    header.method = @"controlCanyu";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    joinHZBody *bodyer = [[joinHZBody alloc]init];
    bodyer.iscanyu = @"1";
    bodyer.id = self.model.id;
    JoinHZRequest *requester = [[JoinHZRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.joinApi joinHZ:requester.mj_keyValues.mutableCopy];
}

//不参加会诊
- (void)nottoAttend{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认不参加该会诊？" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加的输入框
    //WS(weakSelf);
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"理由";
        NSLog(@"%@",textField);
    }];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *userNameTextField = alert.textFields.firstObject;
        NSLog(@"得到不参加会诊理由%@",userNameTextField.text);
        
        [Utils addHudOnView:self.view];
        joinHZHeader *header = [[joinHZHeader alloc]init];
        
        header.target = @"doctorHuizhenControl";
        
        header.method = @"controlCanyu";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        
        joinHZBody *bodyer = [[joinHZBody alloc]init];
        bodyer.iscanyu = @"0";
        bodyer.id = self.model.id;
        bodyer.refuse = userNameTextField.text;
        JoinHZRequest *requester = [[JoinHZRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        
        [self.notjoinApi joinHZ:requester.mj_keyValues.mutableCopy];
        
    }];
    [alert addAction:Action];
    [alert addAction:twoAc];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    if ([groupId isEqualToString:self.model.mdtgroupid]) {
        resultBlock(self.groupMemberlist);
    }
}
//
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    if ([userId isEqualToString:[User LocalUser].id]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [User LocalUser].id;
        user.name = [User LocalUser].name;
        user.portraitUri = [User LocalUser].facepath;
        return completion(user);
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (GroupChatListModel *model in self.Memberlist) {
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



@end
