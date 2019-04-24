//
//  MyProfileViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyProfileViewController.h"
#import "BaseInfoTableViewCell.h"
#import "MyIntroTableViewCell.h"
#import "PhotoImgTableViewCell.h"
#import "UpdateProfileViewController.h"
#import "MyProfilwModel.h"
#import "MyProfileApi.h"
#import "MyProfileRequest.h"
#import "SelectTypeTableViewCell.h"
#import "PhotoArrTableViewCell.h"
#import "EmptyManager.h"
#import "LSProgressHUD.h"
#import "PhotoPickManager.h"
#import "ZJImageMagnification.h"
#import "LYZAdView.h"
#import "AlertView.h"
@interface MyProfileViewController ()<UITabBarDelegate,UITableViewDataSource,ApiRequestDelegate,UIActionSheetDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)UIActionSheet *actionsheet1;

@property (nonatomic,strong)UIImage *tempImage;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)MyProfileApi *api;

@property (nonatomic,strong)MyProfilwModel *model;

@property (nonatomic,strong)SelectTypeTableViewCell *name;

@property (nonatomic,strong)SelectTypeTableViewCell *sex;

@property (nonatomic,strong)SelectTypeTableViewCell *email;

@property (nonatomic,strong)SelectTypeTableViewCell *hos;

@property (nonatomic,strong)SelectTypeTableViewCell *keshi;

@property (nonatomic,strong)SelectTypeTableViewCell *jop;

@property (nonatomic,strong)NSArray *sectionDataArray;

@property (nonatomic,strong)NSArray *dataArray;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIImageView *headImage;

@end

@implementation MyProfileViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
    NSLog(@"%@     %@",[User LocalUser].tgroupid,[User LocalUser].tname);
}

- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"姓名" placeholder:@""];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
        _name.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _name.textField.userInteractionEnabled = YES;
        [_name setEditAble:NO];
    }
    return _name;
}

- (SelectTypeTableViewCell *)sex {
    if (!_sex) {
        _sex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_sex setTypeName:@"性别" placeholder:@""];
        _sex.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _sex.selectionStyle = UITableViewCellSelectionStyleNone;
        _sex.textField.userInteractionEnabled = YES;
        [_sex setEditAble:NO];
    }
    return _sex;
}

- (SelectTypeTableViewCell *)email {
    if (!_email) {
        _email = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_email setTypeName:@"邮箱" placeholder:@""];
        _email.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _email.selectionStyle = UITableViewCellSelectionStyleNone;
        _email.textField.userInteractionEnabled = YES;
        [_email setEditAble:NO];
    }
    return _email;
}

- (SelectTypeTableViewCell *)hos {
    if (!_hos) {
        _hos = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_hos setTypeName:@"医院" placeholder:@""];
        _hos.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _hos.selectionStyle = UITableViewCellSelectionStyleNone;
        _hos.textField.userInteractionEnabled = YES;
        [_hos setEditAble:NO];
    }
    return _hos;
}


- (SelectTypeTableViewCell *)keshi {
    if (!_keshi) {
        _keshi = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_keshi setTypeName:@"科室" placeholder:@""];
        _keshi.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _keshi.selectionStyle = UITableViewCellSelectionStyleNone;
        _keshi.textField.userInteractionEnabled = YES;
        [_keshi setEditAble:NO];
    }
    return _keshi;
}

- (SelectTypeTableViewCell *)jop {
    if (!_jop) {
        _jop = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_jop setTypeName:@"职位" placeholder:@""];
        _jop.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _jop.selectionStyle = UITableViewCellSelectionStyleNone;
        _jop.textField.userInteractionEnabled = YES;
        [_jop setEditAble:NO];
    }
    return _jop;
}


- (MyProfileApi *)api
{
    if (!_api) {
        _api = [[MyProfileApi alloc]init];
        _api.delegate  =self;
    }
    return _api;
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.tableview.mj_header endRefreshing];
    [self.hud hide:YES];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    self.model = responsObject;
    self.name.text = self.model.name;
    self.sex.text  =self.model.sex;
    self.email.text  =self.model.email;
    self.hos.text = self.model.hname;
    self.keshi.text  =self.model.dname;
    self.jop.text  =self.model.pname;
    [User LocalUser].isauthenticate = self.model.isauthenticate;
    [User saveToDisk];
    [self.tableview reloadData];
    [self layoutHeadViewWithState:self.model.isauthenticate reason:self.model.refuse];
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.tableview.mj_header endRefreshing];
    [self.hud hide:YES];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    if (!self.model) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    };
}

- (void)layoutHeadViewWithState:(NSString *)authState reason:(NSString *)reason{
    if ([authState isEqualToString:@"1"]) {
        self.tableview.tableHeaderView = nil;
    }else if ([authState isEqualToString:@"2"]){
        UIView *contentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 87)];
        UIView *stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        stateView.backgroundColor = HexColor(0xfffcdd);
        [contentview addSubview:stateView];
        UIImageView *stateImg = [[UIImageView alloc] init];
        [stateView addSubview:stateImg];
        stateImg.image = [UIImage imageNamed:@"au_wailt"];
        [stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(stateView.mas_centerY);
            make.width.height.mas_equalTo(20);
        }];
        UILabel *stateLabel = [[UILabel alloc]init];
        [stateView addSubview:stateLabel];
        stateLabel.textColor = AppStyleColor;
        stateLabel.textAlignment = NSTextAlignmentLeft;
        stateLabel.font  =[UIFont systemFontOfSize:15.0f];
        stateLabel.text = @"认证中";
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(stateImg.mas_right).mas_equalTo(13);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(stateView.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        UIView *stateNoticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, 42)];
        stateNoticeView.backgroundColor = DefaultBackgroundColor;
        [contentview addSubview:stateNoticeView];
        
        UILabel *stateNoticeLabel = [[UILabel alloc]init];
        [stateNoticeView addSubview:stateNoticeLabel];
        stateNoticeLabel.textColor = DefaultGrayLightTextClor;
        stateNoticeLabel.textAlignment = NSTextAlignmentLeft;
        stateNoticeLabel.font  = FontNameAndSize(13);
        stateNoticeLabel.text = @"我们将会在3个工作日内进行审核，请您留意电话，站内提醒";
        [stateNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(stateNoticeView.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        self.tableview.tableHeaderView = contentview;
        
    }else if ([authState isEqualToString:@"3"]){
        self.tableview.tableHeaderView = nil;
    }else{
        UIView *contentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 122)];
        UIView *stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        stateView.backgroundColor = HexColor(0xfffcdd);
        [contentview addSubview:stateView];
        UIImageView *stateImg = [[UIImageView alloc] init];
        [stateView addSubview:stateImg];
        stateImg.image = [UIImage imageNamed:@"au_failure"];
        [stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(13);
            make.width.height.mas_equalTo(20);
        }];
        UILabel *stateLabel = [[UILabel alloc]init];
        [stateView addSubview:stateLabel];
        stateLabel.textColor = HexColor(0xeb6100);
        stateLabel.textAlignment = NSTextAlignmentLeft;
        stateLabel.font  = [UIFont systemFontOfSize:15.0f];
        stateLabel.text = @"认证失败";
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(stateImg.mas_right).mas_equalTo(13);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(stateImg.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        UILabel *stateDetailLabel = [[UILabel alloc]init];
        [stateView addSubview:stateDetailLabel];
        stateDetailLabel.textColor = HexColor(0xeb6100);
        stateDetailLabel.textAlignment = NSTextAlignmentLeft;
        stateDetailLabel.font  =FontNameAndSize(14);
        stateDetailLabel.text = reason;
        stateDetailLabel.numberOfLines = 0;
        [stateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(stateLabel.mas_left);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(stateLabel.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        
        UIView *stateNoticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, 42)];
        stateNoticeView.backgroundColor = DefaultBackgroundColor;
        [contentview addSubview:stateNoticeView];
        UILabel *stateNoticeLabel = [[UILabel alloc]init];
        [stateNoticeView addSubview:stateNoticeLabel];
        stateNoticeLabel.textColor = DefaultGrayLightTextClor;
        stateNoticeLabel.textAlignment = NSTextAlignmentLeft;
        stateNoticeLabel.font  =FontNameAndSize(13);
        stateNoticeLabel.text = @"我们将会在3个工作日内进行审核，请您留意电话，站内提醒";
        [stateNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(stateNoticeView.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        self.tableview.tableHeaderView = contentview;
    }
}

- (void)tapAction{
    [ZJImageMagnification scanBigImageWithImageView:self.headImage alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"menzhen"];
    [self.tableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
    [self.tableview registerClass:[PhotoArrTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhotoArrTableViewCell class])];
    self.view.backgroundColor  = DefaultBackgroundColor;
    self.tableview.backgroundColor = DefaultBackgroundColor;
    self.tableview.separatorColor = RGBA(102, 102, 102, 0.25);
    [self setRightNavigationItemWithTitle:@"更新资料" action:@selector(updatePprofile)];
    self.sectionDataArray = @[self.name,self.sex,self.email];
    self.dataArray = @[self.hos, self.keshi, self.jop];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableview.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求签名
        profileHeader *header = [[profileHeader alloc]init];
        header.target = @"ownDControl";
        header.method = @"myInfos";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        profileBody *bodyer = [[profileBody alloc]init];
        MyProfileRequest *requester = [[MyProfileRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.api getProfile:requester.mj_keyValues.mutableCopy];
    }];
    [self.tableview.mj_header beginRefreshing];
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
        if ([event isEqualToString:@"知道了"]){
        }
    }
    [messageView hide];
}
- (void)updatePprofile{
    if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
        AdViewMessageObject *messageObject = MakeAdViewObject(@"", @"",@"",NO);
        [LYZAdView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:1101];
    }else{
        UpdateProfileViewController *update = [UpdateProfileViewController new];
        update.title = @"更新资料";
        update.model = self.model;
        [self.navigationController pushViewController:update animated:YES];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            return [self.sectionDataArray safeObjectAtIndex:indexPath.row];
        }else if(indexPath.section == 1){
            return [self.dataArray safeObjectAtIndex:indexPath.row];
        }else if(indexPath.section == 2){
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWirthModel:self.model];
            return cell;
        }else if(indexPath.section == 3){
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menzhen"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWirthModeltime:self.model];
            return cell;
        }else{
        PhotoArrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhotoArrTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        return cell;
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 45;
    }else if (indexPath.section == 2){
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
            [cell refreshWirthModel:self.model];
        }];
    }else if (indexPath.section == 3){
        return [tableView fd_heightForCellWithIdentifier:@"menzhen" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
            [cell refreshWirthModeltime:self.model];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([PhotoArrTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(PhotoArrTableViewCell *cell) {
            [cell refreshWithModel:self.model];
        }];
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }else{
        return 1;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        if (section == 0){
            self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
            self.headView.backgroundColor = [UIColor whiteColor];
            UILabel *des = [[UILabel alloc]init];
            des.text  =@"头像";
            des.userInteractionEnabled = YES;
            des.font = Font(16);
            des.textColor = DefaultGrayLightTextClor;
            des.textAlignment = NSTextAlignmentLeft;
            [self.headView addSubview:des];
            [des mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(25);
                make.centerY.mas_equalTo(self.headView.mas_centerY);
                make.left.mas_equalTo(20);
            }];
            self.headImage = [[UIImageView alloc]init];
            self.headImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [self.headImage addGestureRecognizer:tap];
            [self.headView addSubview:self.headImage];
            self.headImage.userInteractionEnabled = YES;
            self.headImage.layer.cornerRadius = 35;
            self.headImage.layer.masksToBounds = YES;
            self.headImage.contentMode = UIViewContentModeScaleAspectFill;
            self.headImage.clipsToBounds = YES;
            [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(des.mas_right).mas_equalTo(30);
                make.width.height.mas_equalTo(70);
                make.centerY.mas_equalTo(self.headView.mas_centerY);
            }];
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]];
           return self.headView;
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        }
    }else{
        if (section == 0){
            self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
            self.headView.backgroundColor = [UIColor whiteColor];
            UILabel *des = [[UILabel alloc]init];
            des.text  =@"头像";
            des.userInteractionEnabled = YES;
            des.font = Font(16);
            des.textColor = DefaultGrayLightTextClor;
            des.textAlignment = NSTextAlignmentLeft;
            [self.headView addSubview:des];
            [des mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(25);
                make.centerY.mas_equalTo(self.headView.mas_centerY);
                make.left.mas_equalTo(20);
            }];
            self.headImage = [[UIImageView alloc]init];
            self.headImage.userInteractionEnabled = YES;
            [self.headView addSubview:self.headImage];
            self.headImage.userInteractionEnabled = YES;
            self.headImage.layer.cornerRadius = 35;
            self.headImage.layer.masksToBounds = YES;
            self.headImage.contentMode = UIViewContentModeScaleAspectFill;
            self.headImage.clipsToBounds = YES;
            [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(des.mas_right).mas_equalTo(30);
                make.width.height.mas_equalTo(70);
                make.centerY.mas_equalTo(self.headView.mas_centerY);
            }];
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]];
            return self.headView;
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0){
            return 90;
        }else{
            return 5;
        }
    }else{
        if (section == 0){
            return 90;
        }else{
            return 5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

@end
