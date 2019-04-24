//
//  AuthenticationViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "HClActionSheet.h"
#import "ACActionSheet.h"
#import "NextStepViewController.h"
#import "SelectJViewController.h"
#import "SelectHospitalViewController.h"
#import "KeshViewController.h"
#import "JopModel.h"
#import "AlertView.h"
#define kFetchTag 2000
#define kFetchTag1 3000

@interface AuthenticationViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ACActionSheetDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

//
@property (nonatomic,strong)SelectTypeTableViewCell *name;

@property (nonatomic,strong)SelectTypeTableViewCell *sex;

@property (nonatomic,strong)SelectTypeTableViewCell *email;

//

@property (nonatomic,strong)SelectTypeTableViewCell *hotel;

@property (nonatomic,strong)SelectTypeTableViewCell *keshi;

@property (nonatomic,strong)SelectTypeTableViewCell *jop;


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *sectionDataArray;

//
@property (nonatomic,strong)UIImageView *imageurl;

@property (nonatomic,strong)UILabel *titleName;

@property (nonatomic,strong)UILabel *desLTitle;

@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic, strong) ACActionSheet *selectSex;

@property (nonatomic,strong)UIView *headView;

//

@property (nonatomic,strong)NSString *hosID;

@property (nonatomic,strong)NSString *keshiID;

@property (nonatomic,strong)NSString *JopID;

@property (nonatomic,assign)BOOL firstDisplay;

@end

@implementation AuthenticationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        weakify(self);
        self.hospitalName = ^(NSString *hospital) {
            strongify(self);
            NSLog(@"-------%@",hospital);
            self.hotel.textField.text = hospital;
            self.hosID = @"";
        };
        
        self.keshiName = ^(NSString *Keshi) {
            strongify(self);
            NSLog(@"-------%@",Keshi);
            self.keshi.textField.text = Keshi;
            self.keshiID = @"";
        };
 
    if (self.firstDisplay == NO) {
        NSString *content = @"你填写的信息仅用于激活直医账号，直医将为您严格保密，激活成功后，可正常全部功能。";
        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"知道了" rightBtnTitle:nil tag:kFetchTag1];
    }
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)layoutsubview{
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
        if ([event isEqualToString:@"暂不认证"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (messageView.tag == kFetchTag1) {
        if ([event isEqualToString:@"知道了"]) {
            self.firstDisplay = YES;
        }
    }
    [messageView hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.priceLabel];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    
    [self setRightNavigationItemWithTitle:@"下一步" action:@selector(NextStep)];
    
    self.sectionDataArray = @[self.name,self.sex,self.email];
    
    self.dataArray = @[self.hotel, self.keshi, self.jop];
    
    [self.tableView reloadData];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    self.headView.backgroundColor = DefaultBackgroundColor;
    
    UIView *topView = [[UIView alloc]init];
    
    [self.headView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *stepline = [[UIView alloc]init];
    
    stepline.backgroundColor = DividerDarkGrayColor;
    
    [topView addSubview:stepline];
    
    [stepline mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.height.mas_equalTo(1.5);
        
    }];
    
    UIView *normalFlag = [[UIView alloc]init];
    
    normalFlag.backgroundColor = AppStyleColor;
    
    normalFlag.layer.cornerRadius = 10;
    
    normalFlag.layer.masksToBounds = YES;
    
    [topView addSubview:normalFlag];
    
    [normalFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    UIView *normalFlag1 = [[UIView alloc]init];
    
    normalFlag1.backgroundColor = [UIColor whiteColor];
    
    normalFlag1.layer.cornerRadius = 3.5;
    
    normalFlag1.layer.masksToBounds = YES;
    
    [normalFlag addSubview:normalFlag1];
    
    [normalFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(normalFlag.mas_centerY);
    }];
    
    UIView *normalFlag1Line = [[UIView alloc]init];
    
    normalFlag1Line.backgroundColor = AppStyleColor;
    
    normalFlag1Line.layer.cornerRadius = 3.5;
    
    normalFlag1Line.layer.masksToBounds = YES;
    
    [stepline addSubview:normalFlag1Line];
    
    [normalFlag1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.mas_equalTo((kScreenWidth - 80)/4);
        
        make.height.mas_equalTo(1.5);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    
    UILabel *norLabel = [[UILabel alloc]init];
    
    [topView addSubview:norLabel];
    
    norLabel.textColor = AppStyleColor;
    
    norLabel.textAlignment = NSTextAlignmentCenter;
    
    norLabel.text = @"基本信息";
    
    norLabel.font = Font(18);
    
    [norLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(normalFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
    }];
    
    //
    
    UIView *authFlag = [[UIView alloc]init];
    
    authFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    authFlag.layer.cornerRadius = 10;
    
    authFlag.layer.masksToBounds = YES;
    
    [topView addSubview:authFlag];
    
    [authFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(stepline.mas_centerX);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *authLabel = [[UILabel alloc]init];
    
    [topView addSubview:authLabel];
    
    authLabel.textColor = DefaultGrayTextClor;
    
    authLabel.textAlignment = NSTextAlignmentCenter;
    
    authLabel.text = @"资质认证";
    
    authLabel.font = Font(18);
    
    [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(authFlag.mas_centerX);
    }];

    
    
    
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    
    [topView addSubview:noteLabel];
    
    noteLabel.textColor = DefaultGrayTextClor;
    
    noteLabel.textAlignment = NSTextAlignmentCenter;
    
    noteLabel.text = @"笔迹认证";
    
    noteLabel.font = Font(18);
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
    }];

    self.tableView.tableHeaderView = self.headView;
    
    // Do any additional setup after loading the view.
}


-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
    
}

- (void)NextStep{

    if (self.name.text.length <= 0) {
        [Utils postMessage:@"姓名输入为空！" onView:self.view];
        return;
    }
    
    if (self.sex.text.length <= 0) {
        [Utils postMessage:@"请选择性别" onView:self.view];
        return;
    }
    
    if (self.email.text.length <= 0) {
        [Utils postMessage:@"邮箱不能为空！" onView:self.view];
        return;
    }
    
    if (self.email.text.length <= 0) {
        [Utils postMessage:@"邮箱不能为空！" onView:self.view];
        return;
    }
    
    if (![ValidatorUtil validateEmail:self.email.text]) {
        [Utils postMessage:@"邮箱格式不正确！" onView:self.view];
        return;
    }
    
    if (self.hotel.text.length <= 0) {
        [Utils postMessage:@"请选择医院" onView:self.view];
        return;
    }
    
    if (self.keshi.text.length <= 0) {
        [Utils postMessage:@"请选择科室" onView:self.view];
        return;
    }
    
    if (self.jop.text.length <= 0) {
        [Utils postMessage:@"请选择职位" onView:self.view];
        return;
        
    }
    
    NextStepViewController *next = [NextStepViewController new];
        
    next.name = self.name.text;
    next.sex = self.sex.text;
    next.email = self.email.text;
    next.hosId = self.hosID;
    next.keshiId = self.keshiID;
    next.jopId = self.JopID;
    next.addHos = self.hosID.length <= 0?self.hotel.textField.text:@"";
    next.addKeshi =self.keshiID.length <= 0? self.keshi.textField.text:@"";
    next.title = @"认证";
    [self.navigationController pushViewController:next animated:YES];
    
}

- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"姓名" placeholder:@"请输入姓名"];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return _name;
}

- (SelectTypeTableViewCell *)sex {
    if (!_sex) {
        _sex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _sex.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_sex setTypeName:@"性别" placeholder:@"请选择性别"];
        [_sex setEditAble:NO];
        
    }
    return _sex;
}

- (SelectTypeTableViewCell *)email {
    if (!_email) {
        _email = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_email setTypeName:@"邮箱" placeholder:@"请输入您的邮箱"];
        _email.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _email.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _email;
}
//

- (SelectTypeTableViewCell *)hotel {
    if (!_hotel) {
        _hotel = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_hotel setTypeName:@"医院" placeholder:@"请填写您所在医院"];
        _hotel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _hotel.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _hotel.selectionStyle = UITableViewCellSelectionStyleNone;
        _hotel.textField.userInteractionEnabled = YES;
        
        [_hotel setEditAble:NO];
        
    }
    return _hotel;
    
}

- (SelectTypeTableViewCell *)keshi {
    if (!_keshi) {
        _keshi = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_keshi setTypeName:@"科室" placeholder:@"请填写您的科室"];
        _keshi.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        [_jop setTypeName:@"职位" placeholder:@"请填写您的职位"];
        _jop.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _jop.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _jop.selectionStyle = UITableViewCellSelectionStyleNone;
        _jop.textField.userInteractionEnabled = YES;
        [_jop setEditAble:NO];
    }
    return _jop;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.sectionDataArray.count;
        
    }else{
        
        return self.dataArray.count;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self.sectionDataArray safeObjectAtIndex:indexPath.row];
        
    }else{
        
        return [self.dataArray safeObjectAtIndex:indexPath.row];
        
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return 10;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {//选择
        
        
    } else if (indexPath.section == 0 &&indexPath.row == 1) {//选择
        
        self.selectSex = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"] actionSheetBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
            
                self.sex.text = @"男";
                
            }else if(buttonIndex == 1){
                
                self.sex.text = @"女";
                
            }
            
        }];
        
        self.selectSex.delegate = self;
        
        [self.selectSex show];

        
    }else if (indexPath.section == 0 &&indexPath.row == 2) {//选择
        
        
    }else if (indexPath.section == 1 &&indexPath.row == 0) {//选择
        
        SelectHospitalViewController *hos = [SelectHospitalViewController new];
        hos.Auhospital = YES;
        hos.title = @"选择医院";
        
        hos.hospital = ^(JopModel *model) {
            self.hotel.textField.text = model.name;
            self.hosID = model.id;
        };
        
        [self.navigationController pushViewController:hos animated:YES];
        
    }else if (indexPath.section == 1 &&indexPath.row == 1) {//选择
        
        KeshViewController *keshi = [KeshViewController new];
        keshi.Aukeshi = YES;
        keshi.keshi = ^(JopModel *model) {
            self.keshi.textField.text = model.name;
            self.keshiID = model.id;
        };
        keshi.title = @"选择科室";
        
        [self.navigationController pushViewController:keshi animated:YES];
        
    }else if (indexPath.section == 1 &&indexPath.row == 2) {//选择
        
        SelectJViewController *jop = [SelectJViewController new];
        
        jop.jop = ^(JopModel *model) {
            
            self.jop.textField.text = model.name;
            
            self.JopID = model.id;
            
        };
        
        jop.title = @"选择职位";
        
        [self.navigationController pushViewController:jop animated:YES];
        
    }
    
    
}

//-(void)toast:(NSString *)title
//{
//    //    int seconds = 3;
//    //    [self toast:title seconds:seconds];
//    [Utils showErrorMsg:self.view type:0 msg:title];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
