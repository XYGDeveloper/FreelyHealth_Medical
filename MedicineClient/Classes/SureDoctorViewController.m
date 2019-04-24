//
//  SureDoctorViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SureDoctorViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "EditTableViewCell.h"
#import "AttenderViewController.h"
#import "DateTimePickerView.h"
#import "SelectAdviceerViewController.h"
#import "HuizhenCommitModel.h"
#import "FillAdviceViewController.h"
#import "BeginHZApi.h"
#import "sendHZRequest.h"
//
#import "KTSelectDatePicker.h"

#import "deleHZApi.h"
#import "AlertView.h"
#import "LYZAdView.h"
//
#import "GetJoinedDoctorModel.h"
#import "GetJoinedDoctorApi.h"
#import "JoinedDoctorRequest.h"
#import "GroupConSearchModel.h"
//
#import "ModifyHzTimeApi.h"
#import "ModifyHZtimeRequest.h"
#define kFetchTag 3000
@interface SureDoctorViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)UIView *headview;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableview;
//cell
@property (nonatomic,strong)EditTableViewCell *attentionDoctor;
@property (nonatomic,strong)EditTableViewCell *startTime;
@property (nonatomic,strong)EditTableViewCell *hzAgreement;
@property (nonatomic,strong)EditTableViewCell *txTime;
//dataSource
@property (nonatomic,strong)NSArray *normalArray;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@property (nonatomic, strong) UIButton *sendHZButton;
@property (nonatomic, strong) BeginHZApi *api;
@property (nonatomic,strong)deleHZApi *delApi;

@property (nonatomic,strong)NSString *memeberStr;
@property (strong, nonatomic) KTSelectDatePicker *selectPicker;
//
@property (nonatomic, strong) GetJoinedDoctorApi *doctorListApi;
@property (nonatomic,strong)NSArray *tempArray;
//
@property (nonatomic, strong) ModifyHzTimeApi *modifyApi;

@end

@implementation SureDoctorViewController

- (UIButton *)sendHZButton{
    if (!_sendHZButton) {
        _sendHZButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendHZButton.backgroundColor = AppStyleColor;
        [_sendHZButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendHZButton setTitle:@"发起会诊" forState:UIControlStateNormal];
    }
    return _sendHZButton;
}

- (BeginHZApi *)api{
    if (!_api) {
        _api = [[BeginHZApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (deleHZApi *)delApi{
    if (!_delApi) {
        _delApi = [[deleHZApi alloc]init];
        _delApi.delegate = self;
    }
    return _delApi;
}

- (GetJoinedDoctorApi *)doctorListApi{
    if (!_doctorListApi) {
        _doctorListApi = [[GetJoinedDoctorApi alloc]init];
        _doctorListApi.delegate = self;
    }
    return _doctorListApi;
}

- (ModifyHzTimeApi *)modifyApi{
    if (!_modifyApi) {
        _modifyApi = [[ModifyHzTimeApi alloc]init];
        _modifyApi.delegate = self;
    }
    return _modifyApi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeAllHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeAllHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    NSLog(@"%@",responsObject);
    if (api == _api) {
        [Utils jumpToTabbarControllerAtIndex:2];
    }else if (api == _doctorListApi) {
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            
        } else {
            self.tempArray = responsObject;
            if (self.tempArray.count <= 0) {
                self.attentionDoctor.text = @"";
            }else{
                GroupConSearchModel *model = [self.tempArray firstObject];
                self.attentionDoctor.text = [NSString stringWithFormat:@"%@等%lu人",model.dname,self.tempArray.count];
            }
        }
    }else if(api == _modifyApi){
        [Utils jumpToTabbarControllerAtIndex:2];
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (UIView *)headview{
    if (!_headview) {
        _headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
        _headview.backgroundColor = [UIColor whiteColor];
        UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [proButton setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
        [proButton setTitle:@"填写资料" forState:UIControlStateNormal];
        proButton.titleLabel.font = Font(15);
        [self.headview addSubview:proButton];
        [proButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [selButton setTitle:@"选择医生" forState:UIControlStateNormal];
        selButton.titleLabel.font = Font(15);
        [self.headview addSubview:selButton];
        [selButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        UIImageView *midIMg = [[UIImageView alloc]init];
        midIMg.image = [UIImage imageNamed:@"huizhen_step"];
        [self.headview addSubview:midIMg];
        [midIMg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(12);
            make.centerX.mas_equalTo(self.headview.mas_centerX);
            make.centerY.mas_equalTo(self.headview.mas_centerY);
        }];
    }
    return _headview;
}

- (TPKeyboardAvoidingTableView *)tableview{
    if (!_tableview) {
        _tableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.separatorColor = HexColor(0xe7e7e9);
        _tableview.delegate = self;
        _tableview.dataSource  = self;
    }
    return _tableview;
}

- (EditTableViewCell *)attentionDoctor {
    if (!_attentionDoctor) {
        _attentionDoctor = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_attentionDoctor setTypeName:@"参加医生" placeholder:@""];
        [_attentionDoctor setEditAble:NO];
        _attentionDoctor.selectionStyle = UITableViewCellSelectionStyleNone;
        _attentionDoctor.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _attentionDoctor.textField.keyboardType = UIKeyboardTypeDefault;
        _attentionDoctor.textField.textAlignment = NSTextAlignmentRight;
    }
    return _attentionDoctor;
}
- (EditTableViewCell *)startTime {
    if (!_startTime) {
        _startTime = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_startTime setTypeName:@"开始时间" placeholder:@""];
        [_startTime setEditAble:NO];
        _startTime.selectionStyle = UITableViewCellSelectionStyleNone;
        _startTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _startTime.textField.keyboardType = UIKeyboardTypeDefault;
        _startTime.textField.textAlignment = NSTextAlignmentRight;
    }
    return _startTime;
}

- (EditTableViewCell *)hzAgreement {
    if (!_hzAgreement) {
        _hzAgreement = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_hzAgreement setTypeName:@"填写会诊意见书" placeholder:@""];
        [_hzAgreement setEditAble:NO];
        _hzAgreement.selectionStyle = UITableViewCellSelectionStyleNone;
        _hzAgreement.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _hzAgreement.textField.keyboardType = UIKeyboardTypeDefault;
        _hzAgreement.textField.textAlignment = NSTextAlignmentRight;
    }
    return _hzAgreement;
}

- (EditTableViewCell *)txTime {
    if (!_txTime) {
        _txTime = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_txTime setTypeName:@"提醒时间" placeholder:@""];
        [_txTime setEditAble:NO];
        _txTime.selectionStyle = UITableViewCellSelectionStyleNone;
        _txTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _txTime.textField.keyboardType = UIKeyboardTypeDefault;
        _txTime.textField.textAlignment = NSTextAlignmentRight;
    }
    return _txTime;
}
- (void)setLayOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headview.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
    }];
    [self.sendHZButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.normalArray = @[self.attentionDoctor,self.startTime];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.headview];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.sendHZButton];
    [self.sendHZButton addTarget:self action:@selector(sendHuizhen) forControlEvents:UIControlEventTouchUpInside];
    [self setLayOut];
    
    self.txTime.text = @"截止前10分钟,短信与APP";
    self.hzAgreement.text = [User LocalUser].name;
    NSDate *date1 = [NSDate date];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60*1+17*60*60-23*60 sinceDate:date1];//后一天
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime1 = [formatter1 stringFromDate:nextDay];
    self.startTime.text = DateTime1;
    
    if (self.isModify == YES) {
        joinedDoctorHeader *header = [[joinedDoctorHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"getMdtMembers";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        joinedDoctorBody *bodyer = [[joinedDoctorBody alloc]init];
        bodyer.id = self.huizhenid;
        JoinedDoctorRequest *requester = [[JoinedDoctorRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.doctorListApi getJoinedDoctorList:requester.mj_keyValues.mutableCopy];
        
    }
    
}

- (void)sendHuizhen{
    //发起会诊
    if (self.memeberStr.length <= 0) {
        [Utils postMessage:@"请添加会诊成员" onView:self.view];
        return;
    }
    
    if (self.isModify== YES) {
        [Utils addHudOnView:self.view];
        modifyHZtimeHeader *header = [[modifyHZtimeHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"updateHuizhenSecond";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        modifyHZtimeBody *bodyer = [[modifyHZtimeBody alloc]init];
        bodyer.id = self.huizhenid;
        bodyer.huizhentime = self.startTime.text;
        bodyer.topic = self.topic;
        bodyer.name = self.name;
        bodyer.age = self.age;
        bodyer.sex = self.sex;
        bodyer.zhengzhuang = self.zhengzhuang;
        bodyer.blimages = self.blimages;
        ModifyHZtimeRequest *requester = [[ModifyHZtimeRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.modifyApi modifyHZtime:requester.mj_keyValues.mutableCopy];
        
    }else{
        [Utils addHudOnView:self.view];
        sendHZHeader *header = [[sendHZHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"createHuizhenSecond";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        sendHZBody *bodyer = [[sendHZBody alloc]init];
        bodyer.id = self.huizhenid;
        bodyer.huizhentime = self.startTime.text;
        
        sendHZRequest *requester = [[sendHZRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.api beginHZ:requester.mj_keyValues.mutableCopy];
    }
}
- (void)back{
//    NSString *content = @"放弃会诊并退出？";
//    [self showScanMessageTitle:nil content:content leftBtnTitle:@"取消" rightBtnTitle:@"确定退出" tag:kFetchTag];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark----TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 10;
    } else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self.self.normalArray objectAtIndex:indexPath.row];
    }else if(indexPath.section ==1){
        return self.hzAgreement;
    }else{
        return self.txTime;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
//        if (self.isModify == YES) {
//            AttenderViewController *attend = [AttenderViewController new];
//            attend.isModify = YES;
//            attend.huizhenID = self.huizhenid;
//            attend.selectSecond = NO;
//            attend.Fillblock = ^(NSString *member,NSString *count) {
//                self.memeberStr = member;
//                if (!count) {
//                    self.attentionDoctor.text = @"";
//                }
//                self.attentionDoctor.text = [NSString stringWithFormat:@"%@等%@人",member,count];
//            };
//            attend.title = @"会诊邀请";
//            [self.navigationController pushViewController:attend animated:YES];
//        }else{
            AttenderViewController *attend = [AttenderViewController new];
            attend.huizhenID = self.huizhenid;
            attend.selectSecond = NO;
            attend.Fillblock = ^(NSString *member,NSString *count) {
                self.memeberStr = member;
                if (!count) {
                    self.attentionDoctor.text = @"";
                }
                self.attentionDoctor.text = [NSString stringWithFormat:@"%@等%@人",member,count];
            };
            attend.title = @"会诊邀请";
            [self.navigationController pushViewController:attend animated:YES];
//        }
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        _selectPicker = [[KTSelectDatePicker alloc] init];
        [_selectPicker didFinishSelectedDate:^(NSDate *selectedDate) {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateStyle:NSDateFormatterMediumStyle];
            [formatter1 setTimeStyle:NSDateFormatterShortStyle];
            [formatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *DateTime1 = [formatter1 stringFromDate:selectedDate];
            self.startTime.text = DateTime1;
        }];
        
    }else if (indexPath.section ==1){
//        SelectAdviceerViewController *advice = [SelectAdviceerViewController new];
//        advice.title = @"选择意见人";
//        [self.navigationController pushViewController:advice animated:YES];
    }else{
//        FillAdviceViewController *test = [FillAdviceViewController new];
//        test.huizhenid = self.huizhenid;
//        test.title = @"会诊意见书";
//        [self.navigationController pushViewController:test animated:YES];
    }
    
}

#pragma mark - DataPickerdelegate
-(void)didFinishPickView:(NSString *)date
{
    self.startTime.text = date;
}


#pragma mark - AlertviewDelegate
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
        if ([event isEqualToString:@"确定退出"]) {
            [Utils addHudOnView:self.view];
            sendHZHeader *header = [[sendHZHeader alloc]init];
            header.target = @"doctorHuizhenControl";
            header.method = @"deleteHuizhen";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            sendHZBody *bodyer = [[sendHZBody alloc]init];
            if (!self.huizhenid) {
                bodyer.id = self.huizhenidNokf;
            }else{
                bodyer.id = self.huizhenid;
            }
            sendHZRequest *requester = [[sendHZRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            NSLog(@"%@",requester);
            [self.delApi deleHZ:requester.mj_keyValues.mutableCopy];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [messageView hide];
    
}

@end
