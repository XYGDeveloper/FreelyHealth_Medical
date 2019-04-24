//
//  NoteAuthViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "NoteAuthViewController.h"
#import "HQDrawingView.h"
#import "AuthCommitApi.h"
#import "AuthCommitRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import "LSProgressHUD.h"
#import "MeViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "AuthScuessViewController.h"
#import "AuModel.h"
#define Service_ID    @"KEFU150539755915325"
#import <JPUSHService.h>
@interface NoteAuthViewController ()<ApiRequestDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong)HQDrawingView *drawView;
//获取oss签名
@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSModel *model;

@property (nonatomic,strong)NSMutableArray *urlImageArray;

//提交认证
@property (nonatomic,strong)AuthCommitApi *Commitapi;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSString *signImageUrl;
@property (nonatomic,strong)UIImage *signImage;

@property (nonatomic,strong)id responsObject;

@end

@implementation NoteAuthViewController

- (NSMutableArray *)urlImageArray
{
    if (!_urlImageArray) {
        _urlImageArray = [NSMutableArray array];
    }
    return _urlImageArray;
}


- (OSSApi *)Ossapi
{
    if (!_Ossapi) {
        _Ossapi = [[OSSApi alloc]init];
        _Ossapi.delegate  =self;
    }
    return _Ossapi;
}



- (AuthCommitApi *)Commitapi
{
    if (!_Commitapi) {
        _Commitapi = [[AuthCommitApi alloc]init];
        _Commitapi.delegate  =self;
    }
    return _Commitapi;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];

}

- (void)setJSPushWithToken:(NSString *)token{
    [JPUSHService setAlias:token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", iResCode, iAlias, seq);
    } seq:1];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _Commitapi) {
        [Utils removeAllHudFromView:self.view];
        AuModel *model = (AuModel *)responsObject;
        [User LocalUser].phone = model.phone;
        [User LocalUser].isauthenticate = model.isauthenticate;
        [User LocalUser].isauthenticate = model.isauthenticate;
        [User LocalUser].sex = model.sex;
        [User LocalUser].dname = model.dname;
        [User LocalUser].hname = model.hname;
        [User LocalUser].facepath = model.facepath;
        [User LocalUser].name = model.name;
        [User LocalUser].pname = model.pname;
        [User saveToDisk];
        [self setJSPushWithToken:[User LocalUser].token];
        [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
            NSLog(@"融云登陆成功：%@",userId);
            [User LocalUser].id = userId;
            [User saveToDisk];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"融云登陆错误：%ld",(long)status);
        } tokenIncorrect:^{
            NSLog(@"融云token错误：");
        }];
        [Utils postMessage:@"认证资料已提交" onView:self.view];
        AuthScuessViewController *scuess = [AuthScuessViewController new];
        scuess.title = @"认证确认";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
        [self.navigationController pushViewController:scuess animated:YES];
    }
    
    if (api == _Ossapi) {
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        [OSSImageUploader asyncUploadImages:@[self.signImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [Utils removeHudFromView:self.view];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    self.signImageUrl = url;
                }
                [User LocalUser].signature = self.signImageUrl;
                [User saveToDisk];
            [Utils addHudOnView:self.view withTitle:@"正在提交认证资料中......"];
            AuthCommitHeader *head = [[AuthCommitHeader alloc]init];
            head.target = @"authenticationDControl";
            head.method = @"doctorAuthentication";
            head.versioncode = Versioncode;
            head.devicenum = Devicenum;
            head.fromtype = Fromtype;
            head.token = [User LocalUser].token;
            AuthCommitBody *body = [[AuthCommitBody alloc]init];
            body.name = self.name;
            body.sex = self.sex;
            body.email = self.email;
            body.hid = self.hosId;
            body.did = self.keshiId;
            body.pid = self.jopId;
            body.hospitalname = self.addHos;
            body.departmentname = self.addKeshi;
            body.certification = self.cerImageurl;
            body.workcard = self.workImageurl;
            body.veriface = self.facImageurl;
            body.signature = [User LocalUser].signature;
            AuthCommitRequest *request = [[AuthCommitRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.Commitapi AuthCommit:request.mj_keyValues.mutableCopy];
            });
        }];
    }
}

- (void)setTopView{
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    [self.view addSubview:self.headView];
    
    self.headView.backgroundColor = DefaultBackgroundColor;
    
    UIView *topView = [[UIView alloc]init];
    
    [self.headView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *stepline = [[UIView alloc]init];
    
    stepline.backgroundColor = AppStyleColor;
    
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
    
    UIImageView *img1 = [[UIImageView alloc]init];
    
    img1.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    
    [normalFlag addSubview:img1];
    
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
 
    UIView *normalFlag1Line = [[UIView alloc]init];
    
    normalFlag1Line.backgroundColor = AppStyleColor;
    
    normalFlag1Line.layer.cornerRadius = 3.5;
    
    normalFlag1Line.layer.masksToBounds = YES;
    
    [stepline addSubview:normalFlag1Line];
    
    [normalFlag1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.mas_equalTo((kScreenWidth - 80)/2);
        
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
    
    authFlag.backgroundColor = AppStyleColor;
    
    [topView addSubview:authFlag];
    
    [authFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(stepline.mas_centerX);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    
    UIImageView *img2 = [[UIImageView alloc]init];
    
    img2.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    
    [authFlag addSubview:img2];
    
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *authLabel = [[UILabel alloc]init];
    
    [topView addSubview:authLabel];
    
    authLabel.textColor = AppStyleColor;
    
    authLabel.textAlignment = NSTextAlignmentCenter;
    
    authLabel.text = @"资质认证";
    
    authLabel.font = Font(18);
    
    [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(authFlag.mas_centerX);
    }];
    
    
    //
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.backgroundColor = AppStyleColor;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIView *noteFlag1 = [[UIView alloc]init];
    
    noteFlag1.backgroundColor = [UIColor whiteColor];
    
    noteFlag1.layer.cornerRadius = 3.5;
    
    noteFlag1.layer.masksToBounds = YES;
    
    [noteFlag addSubview:noteFlag1];
    
    [noteFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(noteFlag.mas_centerY);
    }];

    
    UILabel *noteLabel = [[UILabel alloc]init];
    
    [topView addSubview:noteLabel];
    
    noteLabel.textColor = AppStyleColor;
    
    noteLabel.textAlignment = NSTextAlignmentCenter;
    
    noteLabel.text = @"笔迹认证";
    
    noteLabel.font = Font(18);
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
    }];
    
}

- (void)setMiddleView{
    self.middleView = [[UIView alloc]init];
    [self.view addSubview:self.middleView];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(304);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = Font(14);
    label.textColor = DefaultGrayTextClor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请在以下空白区域签名(可选)";
    [self.middleView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleView.mas_centerX);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(220);
        
    }];
    
    self.drawView = [[HQDrawingView alloc]init];
    self.drawView.backgroundColor = [UIColor whiteColor];
    
    [self.drawView initDrawingView];
    
    self.drawView.lineWidth = 6.0f;

    [self.middleView addSubview:self.drawView];
    
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        
        make.left.mas_equalTo(20);
        
        make.right.mas_equalTo(-20);
        
        make.bottom.mas_equalTo(-60);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.layer.cornerRadius = 6;
    
    button.layer.masksToBounds = YES;
    
    button.layer.borderWidth = 0.5;
    
    button.layer.borderColor = AppStyleColor.CGColor;
    
    [button setTitle:@"清空签名" forState:UIControlStateNormal];
    
    [button setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(cleanNote) forControlEvents:UIControlEventTouchUpInside];
    
    [self.middleView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        
        make.centerX.mas_equalTo(self.middleView.mas_centerX);
        
        make.width.mas_equalTo(150);
        
        make.height.mas_equalTo(30);
        
    }];
    
}

- (void)cleanNote{
    [self.drawView doBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setMiddleView];
    
    [self setRightNavigationItemWithTitle:@"完成" action:@selector(NextStep)];

    // Do any additional setup after loading the view.
}


//完成
- (void)NextStep{
    //提交接口
    [self.drawView saveImage:^(UIImage *image) {
        if (!image) {
            [Utils postMessage:@"请在此页面完成笔记签名！" onView:self.view];
            return ;
        }
        self.signImage = image;
        [Utils addHudOnView:self.view withTitle:@"上传笔迹签名中....."];
        //请求签名
        UploadHeader *header = [[UploadHeader alloc]init];
        
        header.target = @"generalDControl";
        
        header.method = @"getDOssSign";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        UploadBody *bodyer = [[UploadBody alloc]init];
        
        UploadToolRequest *requester = [[UploadToolRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.Ossapi getoss:requester.mj_keyValues.mutableCopy];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
