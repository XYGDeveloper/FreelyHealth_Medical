//
//  LoginViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.

#import "LoginViewController.h"
#import "RequestParameter.h"
#import "OptionVarCodeApi.h"
#import "LoginApi.h"
#import "LoginRequest.h"
#import "User.h"
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "AuthenticationViewController.h"
#import "AgentViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#import "LSProgressHUD.h"
#import "UIImage+GradientColor.h"
#import "Udesk.h"
#import "UdeskManager.h"
#import "JPUSHService.h"
#define Service_ID    @"KEFU150539755915325"
#import "GroupInfoModel.h"
#import "IANActivityIndicatorButton.h"
#import "UIButton+IANActivityView.h"
#import "MBProgressHUD+BWMExtension.h"
#import "SecurityUtil.h"
@interface LoginViewController ()<UITextFieldDelegate,ApiRequestDelegate,RCIMUserInfoDataSource>

@property (nonatomic,strong)UIView *tellephoneBackgroungView;

@property (nonatomic,strong)UIView *valiBackgroungView;

@property (nonatomic,strong)UILabel *remarkLabel;

@property (nonatomic,strong)IANActivityIndicatorButton *loginButton;

@property (nonatomic,strong)UILabel *telephoneLabel;

@property (nonatomic,strong)UITextField *telephone;

@property (nonatomic,strong)UIView *sepLine;

@property (nonatomic,strong)UILabel *valiLabel;

@property (nonatomic,strong)UITextField *valicode;

@property (nonatomic,strong)UIButton *getVlicode;

@property (nonatomic,strong)OptionVarCodeApi *GetVarcodeApi;

@property (nonatomic,strong)LoginApi *loginApi;

@property (nonatomic,strong)GetIMtokenApi *lMApi;

@property (nonatomic,strong)GetIMtokenApi *getAllGroupsApi;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation LoginViewController


- (GetIMtokenApi *)lMApi
{
    if (!_lMApi) {
        _lMApi = [[GetIMtokenApi alloc]init];
        _lMApi.delegate = self;
    }
    return _lMApi;
}

- (GetIMtokenApi *)getAllGroupsApi
{
    if (!_getAllGroupsApi) {
        _getAllGroupsApi = [[GetIMtokenApi alloc]init];
        _getAllGroupsApi.delegate = self;
    }
    return _getAllGroupsApi;
}

- (OptionVarCodeApi *)GetVarcodeApi
{
    if (!_GetVarcodeApi) {
        _GetVarcodeApi = [[OptionVarCodeApi alloc]init];
        _GetVarcodeApi.delegate  = self;
    }
    return _GetVarcodeApi;
}


- (LoginApi *)loginApi
{
    if (!_loginApi) {
        _loginApi = [[LoginApi alloc]init];
        _loginApi.delegate = self;
    }
    return _loginApi;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    if (api == _GetVarcodeApi) {
        [Utils removeHudFromView:self.view];
    }
    if (api == _loginApi) {
        [Utils removeHudFromView:self.view];
    }
    if (api == _lMApi) {
        [Utils removeHudFromView:self.view];
    }
    if (api == _getAllGroupsApi) {
        [Utils removeHudFromView:self.view];
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    if (api == self.GetVarcodeApi) {
        NSLog(@"%@",responsObject);
        [Utils removeHudFromView:self.view];
        [Utils postMessage:@"验证码已发送到您的手机" onView:self.view];
    }
    
    if (api == _loginApi) {
        [User LocalUser].id = responsObject[@"id"];
        [User LocalUser].isauthenticate = responsObject[@"isauthenticate"];
        [User LocalUser].phone = responsObject[@"phone"];
        [User LocalUser].kefu = responsObject[@"kefu"];
        [User saveToDisk];
        if (responsObject[@"token"] && [[User LocalUser].isauthenticate isEqualToString:@"N"]) {
                AuthenticationViewController *quth = [AuthenticationViewController new];
//                quth.token = responsObject[@"token"];
                [User LocalUser].temptoken = responsObject[@"token"];
                [User LocalUser].temptoken = responsObject[@"kefu"];
                [User saveToDisk];
                quth.title = @"认证";
                [self.navigationController pushViewController:quth animated:YES];
                
        }else if ( responsObject[@"token"] && [[User LocalUser].isauthenticate isEqualToString:@"O"]){
                User *Localuser = [User mj_objectWithKeyValues:responsObject];
                [User setLocalUser:Localuser];
                AgentViewController *agent = [AgentViewController new];
                agent.title = @"服务记录";
                [self.navigationController pushViewController:agent animated:YES];
                
        }else{
                User *Localuser = [User mj_objectWithKeyValues:responsObject];
                [User setLocalUser:Localuser];
                [Utils addHudOnView:self.view];
                getTokenHeader *head = [[getTokenHeader alloc]init];
                head.target = @"generalDControl";
                head.method = @"getDIMToken";
                head.versioncode = Versioncode;
                head.devicenum = Devicenum;
                head.fromtype = Fromtype;
                head.token = responsObject[@"token"];
                getTokenBody *body = [[getTokenBody alloc]init];
                GetImTokenRequest *request = [[GetImTokenRequest alloc]init];
                request.head = head;
                request.body = body;
                NSLog(@"%@",request);
                [self.lMApi getToken:request.mj_keyValues.mutableCopy];
            }
        
    }
    
    if (api == _lMApi) {
        NSLog(@"%@",responsObject);
        [User LocalUser].IMtoken = responsObject[@"imtoken"];
        [User saveToDisk];
        [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
            NSLog(@"融云连接登陆成功。当前登录的用户ID：%@", userId);
            [User LocalUser].id = userId;
            [User saveToDisk];
            //获取所有群组信息
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
            [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
            [RCIM sharedRCIM].currentUserInfo.name = [User LocalUser].name;
            [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            [[RCIM sharedRCIM]setUserInfoDataSource:self];
            [self sertUdeskWithToken:[User LocalUser].token];
            [JPUSHService setAlias:[User LocalUser].token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", iResCode, iAlias, seq);
                if (iResCode == 0) {
                    NSLog(@"极光标签设置成功");
                }
            } seq:1];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            [Utils postMessage:@"token过期或者不正确" onView:self.view];
        }];
    }
    
    if (api == _getAllGroupsApi) {
        
        [Utils removeAllHudFromView:self.view];
        NSLog(@"%@",responsObject);
        
        NSArray *arr = [GroupInfoModel mj_objectArrayWithKeyValuesArray:responsObject[@"groups"]];
        
        for (GroupInfoModel *model in arr) {
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = model.groupid;
            group.groupName = model.groupname;
            group.portraitUri = model.groupfacepath;
            [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:model.groupid];
        }
        
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
      
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
    }
    
}

- (void)sertUdeskWithToken:(NSString *)token{
    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"freelyhealth.udesk.cn" appKey:@"e96116c884c1ed66d56dfe6013f20b41" appId:@"6b81c756059b61d3"];
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = [User LocalUser].token;
    customer.nickName = [User LocalUser].name;
    customer.email = [NSString stringWithFormat:@"%@@163.com",[User LocalUser].phone];
    customer.cellphone = [User LocalUser].phone;
    [UdeskManager initWithOrganization:organization customer:customer];
    
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        NSLog(@"客服用户自定义字段：%@",responseObject);
    }];
    
    UdeskCustomerCustomField *textField = [UdeskCustomerCustomField new];
    textField.fieldKey = @"TextField_20157";
    textField.fieldValue = @"暂无留言";
    UdeskCustomerCustomField *keshiField = [UdeskCustomerCustomField new];
    keshiField.fieldKey = @"TextField_21228";
    keshiField.fieldValue = [User LocalUser].dname;
    
    UdeskCustomerCustomField *hosField = [UdeskCustomerCustomField new];
    hosField.fieldKey = @"TextField_21229";
    hosField.fieldValue = [User LocalUser].hname;
    
    UdeskCustomerCustomField *tField = [UdeskCustomerCustomField new];
    tField.fieldKey = @"TextField_21230";
    tField.fieldValue = [User LocalUser].tname;
    
    UdeskCustomerCustomField *zhichengField = [UdeskCustomerCustomField new];
    zhichengField.fieldKey = @"TextField_21231";
    zhichengField.fieldValue = [User LocalUser].pname;
    
    UdeskCustomerCustomField *selectField = [UdeskCustomerCustomField new];
    selectField.fieldKey = @"SelectField_10248";
    
    if ([[User LocalUser].sex isEqualToString:@"男"]) {
        
        selectField.fieldValue = @[@"0"];
        
    }else{
        
        selectField.fieldValue = @[@"1"];
        
    }
    
    customer.customField = @[textField,keshiField,hosField,tField,zhichengField,selectField];
    
    [UdeskManager updateCustomer:customer];
    
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        NSLog(@"客服用户自定义字段：%@",responseObject);
    }];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    NSLog(@"------%@",userId);
    
        if ([userId isEqualToString:[User LocalUser].id]) {
            
            RCUserInfo *userInfo = [[RCUserInfo alloc]init];
            
            userInfo.userId = userId;
            
            userInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
            
            userInfo.portraitUri = [User LocalUser].facepath;
            
            return completion(userInfo);
            
        }
           
        return completion(nil);
 
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = DefaultBackgroundColor;
    
    [self layoutViewcontrollerSubview];
    
    [self layOutSubviews];
    
    if (self.reLogin == YES) {
            [self setLeftNavigationItemWithImage:[UIImage imageNamed:@""] highligthtedImage:[UIImage imageNamed:@""] action:nil];
    }else{
            [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    }

    
    
}

- (void)back{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)layoutViewcontrollerSubview{
    
    self.tellephoneBackgroungView = [[UIView alloc]init];
    
    self.tellephoneBackgroungView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tellephoneBackgroungView];
    
    self.valiBackgroungView = [[UIView alloc]init];
    
    self.valiBackgroungView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.valiBackgroungView];
    
    self.remarkLabel = [[UILabel alloc]init];
    
    self.remarkLabel.backgroundColor = [UIColor clearColor];
    
    self.remarkLabel.textColor = DefaultGrayLightTextClor;
    
    self.remarkLabel.textAlignment = NSTextAlignmentCenter;
    
    self.remarkLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    
    self.remarkLabel.text = NSLocalizedString(@"login_viewcontroller_remark", nil);
    
    [self.view addSubview:self.remarkLabel];
    
    self.loginButton = [[IANActivityIndicatorButton alloc] init];
    
    [self.view addSubview:self.loginButton];
    
    self.loginButton.backgroundColor = RGB(71, 149, 164);
    
    [self.loginButton setTitle:NSLocalizedString(@"login_viewcontroller_title", nil) forState:UIControlStateNormal];
    
    self.loginButton.layer.cornerRadius = 6;
    
    self.loginButton.layer.masksToBounds = YES;
    
    self.loginButton.alpha = 1.0;
    
    UIColor *topleftColor = [UIColor colorWithRed:137/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:97/255.0f green:201/255.0f blue:221/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    
    [self.loginButton setBackgroundImage:bgImg forState:UIControlStateNormal];
    
    weakify(self);
    
    self.loginButton.TouchBlock = ^(IANActivityIndicatorButton *myButton){
        strongify(self);
        
        
        [self.telephone resignFirstResponder];
        
        [self.valicode resignFirstResponder];
        
        if (self.telephone.text.length <= 0) {
            
            [Utils postMessage:@"请输入手机号码" onView:self.view];
            
            return;
            
        }
        
        if (self.valicode.text.length <= 0) {
            
            [Utils postMessage:@"请输入验证码" onView:self.view];
            
            return;
            
        }
        
        NSError *error = nil;
        
        if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
            
            [self toast:[error localizedDescription]];
            
            return;
        }
        
        self.loginButton.alpha = 1.0f;
        self.loginButton.enabled = YES;
        
//        [self.loginButton startButtonActivityIndicatorView];

        LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
        
        head.target = @"openDControl";
        
        head.method = @"loginByDCaptcha";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        LoginRequestBody *body = [[LoginRequestBody alloc]init];
        
        body.phone = self.telephone.text;
        
        body.captcha = self.valicode.text;
        
        LoginRequest *request = [[LoginRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.loginApi LoginByAchaCode:request.mj_keyValues.mutableCopy];
        
    };
    
    
    self.telephoneLabel = [[UILabel alloc]init];
    
    [self.tellephoneBackgroungView addSubview:self.telephoneLabel];
    
    self.telephoneLabel.text = NSLocalizedString(@"login_viewcontroller_telephonelabel", nil);
    
    self.telephoneLabel.textColor = DefaultGrayLightTextClor;
    
    self.telephoneLabel.textAlignment = NSTextAlignmentLeft;
    
    self.telephoneLabel.font = Font(16);
    
    self.telephone = [[UITextField alloc]init];
    
    [self.tellephoneBackgroungView addSubview:self.telephone];
    
    self.telephone.placeholder = NSLocalizedString(@"login_viewcontroller_telephoneplacehoder", nil);
    
    self.telephone.font = Font(16);
    
    self.telephone.keyboardType = UIKeyboardTypeNumberPad;
    
    self.telephone.delegate = self;
    
    self.telephone.clearButtonMode = UITextFieldViewModeAlways;
    
    self.sepLine = [[UIView alloc]init];
    
    self.sepLine.backgroundColor = DividerGrayColor;
    
    [self.tellephoneBackgroungView addSubview:self.sepLine];
    
    self.getVlicode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.getVlicode setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    self.getVlicode.titleLabel.font = Font(16);
    
    [self.tellephoneBackgroungView addSubview:self.getVlicode];
    
    self.getVlicode.backgroundColor = [UIColor clearColor];
    
    [self.getVlicode setTitle:NSLocalizedString(@"login_viewcontroller_postvliacode", nil) forState:UIControlStateNormal];
    
    [self.getVlicode addTarget:self action:@selector(toGetvlicode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.valiLabel = [[UILabel alloc]init];
    
    [self.valiBackgroungView addSubview:self.valiLabel];
    
    self.valiLabel.text = NSLocalizedString(@"login_viewcontroller_valicode", nil);
    
    self.valiLabel.textColor = DefaultGrayLightTextClor;
    
    self.valiLabel.textAlignment = NSTextAlignmentLeft;
    
    self.valiLabel.font = Font(16);
    
    self.valicode = [[UITextField alloc]init];
    
    [self.valiBackgroungView addSubview:self.valicode];
    
    self.valicode.placeholder = NSLocalizedString(@"login_viewcontroller_valicodeplacehoder", nil);
    
    self.valicode.font = Font(16);
    
    self.valicode.delegate = self;
    
    self.valicode.clearButtonMode = UITextFieldViewModeAlways;
    
    self.valicode.keyboardType = UIKeyboardTypeNumberPad;

    [self.valicode  addTarget:self action:@selector(vartextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
}

-(void)vartextFieldChange:(id)sender
{
    
    NSError *error = nil;
    
    if (self.valicode.text.length >= 4 && [ValidatorUtil isValidMobile:self.telephone.text error:&error] ) {
        //  1. 登录按钮变为可点击状态
        self.loginButton.alpha = 1.0;
        
    }else
    {
        
        self.loginButton.alpha = 0.7;
        
    }
    
}


- (void)layOutSubviews{
    
    
    CGFloat margin = 0;
    
    CGFloat height = 64;
    
    [self.tellephoneBackgroungView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(margin);
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(height);
        
    }];
    
    [self.valiBackgroungView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.tellephoneBackgroungView.mas_bottom).mas_equalTo(1);
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(height);
        
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.valiBackgroungView.mas_bottom).mas_equalTo(7);
        
        make.width.mas_equalTo(kScreenWidth - 40);
        
        make.height.mas_equalTo(14);
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).mas_equalTo(31.5);
        
        make.left.mas_equalTo(15);
        
        make.right.mas_equalTo(-15);
        
        make.height.mas_equalTo(49);
        
    }];
    
    [self.telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(32);
        
    }];
    
    
    [self.telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        
        make.left.mas_equalTo(self.telephoneLabel.mas_right);
        
        make.width.mas_equalTo(140);
        
        make.height.mas_equalTo(32);
        
    }];
    
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        
        make.left.mas_equalTo(self.telephone.mas_right).mas_equalTo(20);
        
        make.width.mas_equalTo(0.5);
        
        make.height.mas_equalTo(32);
        
    }];
    
    [self.getVlicode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        
        make.left.mas_equalTo(_sepLine.mas_right).mas_equalTo(20);
        
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(32);
        
    }];
    
    [self.valiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        
        make.centerY.mas_equalTo(self.valiBackgroungView.mas_centerY);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(32);
        
    }];
    
    
    [self.valicode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.valiBackgroungView.mas_centerY);
        
        make.left.mas_equalTo(self.valiLabel.mas_right);
        
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(32);
        
    }];
    
}

#pragma mark- delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
    
}


// to option valicode

-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
    
}

- (void)toGetvlicode:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    if (self.telephone.text.length <= 0) {
        [Utils postMessage:@"请输入手机号码" onView:self.view];
        return;
    }
    
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    
    [Utils addHudOnView:self.view];
    RequestHeader *head = [[RequestHeader alloc]init];
    head.target = @"openDControl";
    head.method = @"getDEnter";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    RequestBody *body = [[RequestBody alloc]init];
    NSString * result = [SecurityUtil encryptAESDataToBase64:self.telephone.text app_key:@"smart@LYZ0000000"];
    body.phaes = result;
    RequestParameter *request = [[RequestParameter alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.GetVarcodeApi getAchaCode:request.mj_keyValues.mutableCopy];
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.getVlicode setTitle:@"获取验证码" forState:UIControlStateNormal];
                //设置不可点击
                self.getVlicode.userInteractionEnabled = YES;
                [self.getVlicode setTitleColor:AppStyleColor forState:UIControlStateNormal];
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                [self.getVlicode setTitle:[NSString stringWithFormat:@"重新获取%@秒",strTime] forState:UIControlStateNormal];
                //设置可点击
                self.getVlicode.userInteractionEnabled = NO;
                
                self.getVlicode.titleLabel.font = Font(14);
                
                [self.getVlicode setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
                
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}

//to login
- (void)toLogin:(UIButton *)sender{
    [self.view endEditing:YES];
    if (self.telephone.text.length <= 0) {
        [Utils postMessage:@"请输入手机号码" onView:self.view];
        return;
    }
    if (self.valicode.text.length <= 0) {
        [Utils postMessage:@"请输入验证码" onView:self.view];
        return;
    }
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
        [self toast:[error localizedDescription]];
        return;
    }
    
    self.loginButton.alpha = 1.0f;
    self.loginButton.enabled = YES;
    [Utils addHudOnView:self.view];
    LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
    head.target = @"openDControl";
    head.method = @"loginByDCaptcha";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    LoginRequestBody *body = [[LoginRequestBody alloc]init];
    body.phone = self.telephone.text;
    body.captcha = self.valicode.text;
    LoginRequest *request = [[LoginRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.loginApi LoginByAchaCode:request.mj_keyValues.mutableCopy];
    
}

@end
