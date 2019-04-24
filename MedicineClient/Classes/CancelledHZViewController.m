//
//  CancelledHZViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/23.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CancelledHZViewController.h"
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
#import "MyHZViewController.h"
#import "queryIsHaveApi.h"
#import "QueryIsExitAgreeBookRequest.h"
#import "scanAgreebookViewController.h"
#import "AgreeBookModel.h"
@interface CancelledHZViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)HZListdetailApi *api;
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
@property (nonatomic,strong)queryIsHaveApi *ishave;

@end

@implementation CancelledHZViewController


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

- (queryIsHaveApi *)ishave{
    if (!_ishave) {
        _ishave = [[queryIsHaveApi alloc]init];
        _ishave.delegate = self;
    }
    return _ishave;
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
        self.itemArr = @[@"联系客服"];
        self.itemimageArr = @[@"contactKF"];
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
        [self.tableview reloadData];
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
    return 5;
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
    if (indexPath.section == 4) {
        MyHZViewController *list = [MyHZViewController new];
        list.orderStatus = @"1";
        list.huizhnid = self.model.id;
        list.isfaqi = self.model.isfaqi;
        [self.navigationController pushViewController:list animated:YES];
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
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect frame = [optionButton convertRect:optionButton.bounds toView:window];
    OYRPopOption *s = [[OYRPopOption alloc] initWithFrame:CGRectMake(0,-24, kScreenWidth, kScreenHeight + 24)];
    s.option_optionContents = self.itemArr;
    s.option_optionImages = self.itemimageArr;
    // 使用链式语法直接展示 无需再写 [s option_show];
    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
        if ([content isEqualToString:@"联系客服"]) {
            [Utils callPhoneNumber:@"400-900-1169"];

        }
        
    } whichFrame:frame animate:YES] option_show];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"ddd"] highligthtedImage:[UIImage imageNamed:@"ddd"] action:@selector(droupMenu:)];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    HZListDetailHeader *head = [[HZListDetailHeader alloc]init];
    head.target = @"doctorHuizhenControl";
    head.method = @"doctorHuizhenDetail";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    HZListDetailBody *body = [[HZListDetailBody alloc]init];
    body.id = self.huizhenid;
    body.issystem = self.model.issystem;
    HzDetailRequest *request = [[HzDetailRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api gethzDetail:request.mj_keyValues.mutableCopy];
    
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

@end
