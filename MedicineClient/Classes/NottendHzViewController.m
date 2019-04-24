//
//  NottendHzViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/23.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "NottendHzViewController.h"
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
#import "GroupChatListModel.h"
#import "getGroupChatListApi.h"
#import "queryIsHaveApi.h"
#import "QueryIsExitAgreeBookRequest.h"
@interface NottendHzViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMGroupUserInfoDataSource,RCIMUserInfoDataSource>
@property (nonatomic,strong)HZListdetailApi *api;
@property (nonatomic,strong)HZListDetailModel *model;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIButton *attendButton;
@property (nonatomic,strong)UIButton *notAttendButton;
//
@property (nonatomic,strong)NSArray *itemArr;
@property (nonatomic,strong)NSArray *itemimageArr;
@property (nonatomic,strong)JoinHZapi *joinApi;
@property (nonatomic,strong)JoinHZapi *notjoinApi;
@property (nonatomic,strong)getGroupChatListApi *chatApi;
@property (nonatomic,strong)NSMutableArray *memberlist;
@property (nonatomic,strong)NSMutableArray *groupMemberlist;
@end

@implementation NottendHzViewController

- (getGroupChatListApi *)chatApi{
    if (!_chatApi) {
        _chatApi = [[getGroupChatListApi alloc]init];
        _chatApi.delegate = self;
    }
    return _chatApi;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
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
            if ([self.model.iscanyu isEqualToString:@"0"]) {
                    self.itemArr = @[@"改为参加",@"联系客服"];
                    self.itemimageArr = @[@"canjia",@"contactKF"];
                }else{
                    self.itemArr = @[@"改为不参加",@"联系客服"];
                    self.itemimageArr = @[@"bucanjia",@"contactKF"];
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
        [self refreshWithHuizhenid:self.huizhenid withissystem:self.model.issystem];

    }
    if (api == _notjoinApi) {
        [Utils postMessage:@"取消加入成功" onView:self.view];
        [Utils removeHudFromView:self.view];
        self.itemArr = @[@"改为参加",@"联系客服"];
        self.itemimageArr = @[@"canjia",@"contactKF"];
        self.attendButton.hidden = YES;
        self.notAttendButton.hidden = YES;
        [self refreshWithHuizhenid:self.huizhenid withissystem:self.model.issystem];

    }
    if (api == _chatApi) {
        NSLog(@"%@",responsObject);
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
        if ([self.model.iscanyu isEqualToString:@"1"]) {
            if ([self.model.jinru isEqualToString:@"0"]) {
                if ([self.model.issystem isEqualToString:@"1"]) {
                    [[RCCall sharedRCCall]startMultiCall:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo];
                }else{
                    if ([self.model.isfaqi isEqualToString:@"1"]) {
                        [[RCCall sharedRCCall]startMultiCall:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo];
                    }else{
                        [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo userIdList:self.groupMemberlist];
                    }
                }
            }else{
                [Utils postMessage:@"视频会诊还没开始，暂时不能进行进入" onView:self.view];
            }
        }else{
            [Utils postMessage:@"您未曾加入到会诊中，请加入会诊" onView:self.view];
        }
    }
    
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

- (void)fillAgreeBook{
    FillAdviceViewController *fill = [FillAdviceViewController new];
    fill.title = @"填写会诊意见书";
    [self.navigationController pushViewController:fill animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)droupMenu:(UIButton *)optionButton{
            if ([self.model.iscanyu isEqualToString:@"0"]) {
                //其他医生发起的
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                CGRect frame = [optionButton convertRect:optionButton.bounds toView:window];
                OYRPopOption *s = [[OYRPopOption alloc] initWithFrame:CGRectMake(0,-24, kScreenWidth, kScreenHeight + 24)];
                s.option_optionContents = self.itemArr;
                s.option_optionImages = self.itemimageArr;
                // 使用链式语法直接展示 无需再写 [s option_show];
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
                    
                } whichFrame:frame animate:YES] option_show];
            }else{
//                //其他医生发起的
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                CGRect frame = [optionButton convertRect:optionButton.bounds toView:window];
                OYRPopOption *s = [[OYRPopOption alloc] initWithFrame:CGRectMake(0,-24, kScreenWidth, kScreenHeight + 24)];
                s.option_optionContents = self.itemArr;
                s.option_optionImages = self.itemimageArr;
                // 使用链式语法直接展示 无需再写 [s option_show];
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

                } whichFrame:frame animate:YES] option_show];
    
    }
    
}

- (void)refreshWithHuizhenid:(NSString *)huizhenid withissystem:(NSString *)issystem
{
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
    [self refreshWithHuizhenid:self.huizhenid withissystem:self.model.issystem];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"ddd"] highligthtedImage:[UIImage imageNamed:@"ddd"] action:@selector(droupMenu:)];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    self.view.backgroundColor = DefaultBackgroundColor;
  
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
    }];
    
    [alert addAction:Action];
    [alert addAction:twoAc];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    if ([groupId isEqualToString:self.model.mdtgroupid]) {
        RCGroup *groupinfo = [[RCGroup alloc]initWithGroupId:self.model.mdtgroupid groupName:self.model.topic portraitUri:@""];
        completion(groupinfo);
    }
}

- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion {
    if ([userId isEqualToString:[User LocalUser].id]) {
        RCUserInfo *userinfo = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[User LocalUser].name portrait:[User LocalUser].facepath];
        completion(userinfo);
    }
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSLog(@"00000     %@",groupId);
    resultBlock(self.groupMemberlist);
}


@end
