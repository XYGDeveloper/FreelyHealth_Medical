//
//  MyGroupConDetailViewController.m
//  MedicineClient
//
//  Created by L on 2018/3/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyGroupConDetailViewController.h"
#import "InvitorDetailApi.h"
#import "InvitorDetailRequest.h"
#import "GlistModel.h"
#import "EditTableViewCell.h"
#import <TPKeyboardAvoidingTableView.h>
#import "MyIntroTableViewCell.h"
#import "ACMediaFrame.h"
#import "IsHaveApi.h"
#import "IsHaveGroupRequest.h"
#import "isAttendGroupConApi.h"
#import "IsAttenendGroupConRequest.h"
#import "HuizhenConversationViewController.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
@interface MyGroupConDetailViewController ()<ApiRequestDelegate,UITableViewDelegate, UITableViewDataSource,BaseMessageViewDelegate>
@property (nonatomic,strong)InvitorDetailApi *detailApi;
@property (nonatomic,strong)GlistModel *glistmodel;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) EditTableViewCell *name;
@property (nonatomic, strong) EditTableViewCell *subject;
@property (nonatomic, strong) NSArray *sectionOnes;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong)IsHaveApi *isApi;
@property (nonatomic,strong)isAttendGroupConApi *attenedApi;
@property (nonatomic,strong)YQWaveButton *tochat;    //invite
@property (nonatomic,strong)NSString *groupName;    //invite
@property (nonatomic,strong)NSString *groupId;    //invite

@end

@implementation customdesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.intro = [[UILabel alloc]init];
        self.intro.textColor = DefaultGrayTextClor;
        self.intro.text = @"图片资料";
        self.intro.textAlignment = NSTextAlignmentLeft;
        self.intro.font = FontNameAndSize(16);
        [self.contentView addSubview:self.intro];
        self.sep = [[UILabel alloc]init];
        self.sep.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.sep];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self layOut];
    }
    return self;
}

- (void)layOut{
    
    [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(25.5);
    }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end

@implementation MyGroupConDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (IsHaveApi *)isApi
{
    if (!_isApi) {
        _isApi = [[IsHaveApi alloc]init];
        _isApi.delegate  =self;
    }
    return _isApi;
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (InvitorDetailApi *)detailApi
{
    if (!_detailApi) {
        _detailApi = [[InvitorDetailApi alloc]init];
        _detailApi.delegate  =self;
    }
    return _detailApi;
}
- (isAttendGroupConApi *)attenedApi
{
    if (!_attenedApi) {
        _attenedApi = [[isAttendGroupConApi alloc]init];
        _attenedApi.delegate  = self;
    }
    return _attenedApi;
}

- (EditTableViewCell *)name {
    if (!_name) {
        _name = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"会诊患者" placeholder:@"请填写会诊患者"];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
        [_name setEditAble:NO];
        _name.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _name;
}

- (EditTableViewCell *)subject {
    if (!_subject) {
        _subject = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _subject.selectionStyle = UITableViewCellSelectionStyleNone;
        [_subject setTypeName:@"会诊主题" placeholder:@"请输入会诊主题"];
        [_subject setEditAble:NO];
        _subject.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _subject;
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (YQWaveButton *)tochat
{
    
    if (!_tochat) {
        _tochat = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        _tochat.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _tochat.backgroundColor = AppStyleColor;
        [_tochat setTitle:@"会诊群聊" forState:UIControlStateNormal];
        [_tochat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _tochat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
    header.target = @"huizhenControl";
    header.method = @"huizhenDetail";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
    bodyer.id = self.id;
    InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    NSLog(@"%@",requester);
    [self.detailApi getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
    self.sectionOnes = @[self.name,self.subject];
    [self.tableView registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
    [self.tableView registerClass:[customdesCell class] forCellReuseIdentifier:NSStringFromClass([customdesCell class])];

    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.tochat];
    [self.tochat addTarget:self action:@selector(toinvite) forControlEvents:UIControlEventTouchUpInside];
    [self.tochat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.sectionOnes.count;
    }else if (section==1){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.sectionOnes[indexPath.row];
    }else if (indexPath.section == 1){
        MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWirthGlistModel:self.glistmodel];
        return cell;
    }else{
        customdesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([customdesCell class])];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 52;
    }else if (indexPath.section==1){
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
            [cell refreshWirthGlistModel:self.glistmodel];
        }];
    }else{
        return 41;
    }
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _detailApi) {
        GlistModel *model = [GlistModel mj_objectWithKeyValues:responsObject];
        self.glistmodel = model;
        self.name.text = model.patientname;
        self.subject.text  = model.item;
        //    self.textView.text  = model.des;
        NSArray *arr = [model.imagepath componentsSeparatedByString:@","];
        for (NSString *path in arr) {
            if (path.length <= 0) {
                return;
            }
            [self.imageArray addObject:path];
        }
        NSLog(@"%@",self.imageArray);
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        mediaView.preShowMedias = self.imageArray;
        mediaView.showDelete = NO;
        mediaView.naviBarBgColor = AppStyleColor;
        mediaView.showAddButton = NO;
        mediaView.rowImageCount = 3;
        mediaView.lineSpacing = 10;
        mediaView.interitemSpacing = 10;
        mediaView.maxImageSelected = 12;
        mediaView.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8);
        [mediaView observeViewHeight:^(CGFloat mediaHeight) {
            self.tableView.tableFooterView = mediaView;
        }];
        [mediaView reload];
        
        [self.tableView reloadData];
        
        IsAttendHeader *header = [[IsAttendHeader alloc]init];
        header.target = @"huizhenControl";
        header.method = @"huizhenXuanze";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        IsAttendBody *bodyer = [[IsAttendBody alloc]init];
        bodyer.id = model.id;
        bodyer.choose = @"1";
        IsAttenendGroupConRequest *requester = [[IsAttenendGroupConRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.attenedApi getIsttendDetail:requester.mj_keyValues.mutableCopy];
      
    }
  
    if (api == _attenedApi) {
        NSLog(@"%@",responsObject);
        self.groupName = responsObject[@"mdtgroupname"];
        self.groupId = responsObject[@"mdtgroupid"];

    }
    
    if (api == _isApi) {
        NSLog(@"%@",responsObject);

    }
}

- (void)toinvite{
    
    
    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
        if ([auth isEqualToString:@"3"]) {
            HuizhenConversationViewController *conver = [[HuizhenConversationViewController alloc]init];
            conver.isGroupCon = YES;
            conver.item = self.groupName;
            conver.targetId = self.groupId;
            conver.mdtgroupname = self.groupName;
            conver.conversationType = ConversationType_GROUP;
            [User LocalUser].mdtgroupid = self.groupId;
            [User LocalUser].mdtgroupname = self.groupName;
            //    [User LocalUser].mdtgroupfacepath = model.groupfacepath;
            [User saveToDisk];
            conver.title = self.groupName;
            [self.navigationController pushViewController:conver animated:YES];
        }else{
            [Utils postMessage:@"认证失败，请重新认证" onView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyProfileViewController *profile = [[MyProfileViewController alloc]init];
                profile.title = @"我的资料";
                [self.navigationController pushViewController:profile animated:YES];
            });
        }
    }];
 
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 2){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else if(section == 1){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
    }else{
        if (section == 2){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else if(section == 1){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 2){
            return 10;
        }else if(section == 1){
            return 10;
        }else{
            return 0.00001;
        }
    }else{
        if (section == 2){
            return 10;
        }else if(section == 1){
            return 10;
        }else{
            return 0.00001;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.000001;
    }else{
        return 0.000001;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
