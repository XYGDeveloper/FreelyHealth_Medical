//
//  GlistDetailViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GlistDetailViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "EditTableViewCell.h"
#import "DesTableViewCell.h"
#import "GroupUploadPicTableViewCell.h"
#import "InviteDoctorViewController.h"
#import "ImageTableViewCell.h"
#import "MyIntroTableViewCell.h"
#import "FillApi.h"
#import "FillAndInviteRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import "isAttendGroupConApi.h"
#import "IsAttenendGroupConRequest.h"
#import "MyInviteModel.h"
#import "HuizhenConversationViewController.h"
#import "InvitorDetailApi.h"
#import "InvitorDetailRequest.h"
#import "GlistModel.h"
#import "HUPhotoBrowser.h"
#import "FindGroupApi.h"
#import "FindGroupInfoRequest.h"
#import "GroupInfoModel.h"
#import "IANActivityIndicatorButton.h"
#import "UIButton+IANActivityView.h"
#import "YQWaveButton.h"
#import "ACMediaFrame.h"
#import "AlertView.h"
#import "LYZAdView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
@interface GlistDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSModel *model;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) EditTableViewCell *name;

@property (nonatomic, strong) EditTableViewCell *subject;

@property (nonatomic, strong) EditTableViewCell *desHeader;

@property (nonatomic,strong) NSArray *basicInfo;

@property (nonatomic,strong)SZTextView *textView;

//相关事件

@property (nonatomic,strong)YQWaveButton *inviteGroupCon;    //invite

@property (nonatomic,strong)YQWaveButton *joinGroupCon;      //join

@property (nonatomic,strong)YQWaveButton *rejectGroupCon;    //reject

@property (nonatomic,strong)YQWaveButton *agreeGroupCon;    //reject

@property (nonatomic,strong)FillApi *fillApi;

@property (nonatomic,strong)MBProgressHUD *hub;

@property (nonatomic,strong)NSMutableArray *imageObjectArray;

@property (nonatomic,strong)NSMutableArray *urlImageArray;

@property (nonatomic,strong)NSString *GroupId;

@property (nonatomic,strong)NSString *Id;

@property (nonatomic,strong)isAttendGroupConApi *attenedApi;

@property (nonatomic,strong)isAttendGroupConApi *NattenedApi;

@property (nonatomic,strong)InvitorDetailApi *detailApi;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic,strong)NSString *tid;

@property (nonatomic,strong)GlistModel *glistmodel;

@property (nonatomic,strong)FindGroupApi *findApi;

@property (nonatomic,strong)FindGroupApi *findApi1;

@end

@implementation customFootCell

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

@implementation GlistDetailViewController


- (NSMutableArray *)imageObjectArray
{
    
    if (!_imageObjectArray) {
        
        _imageObjectArray = [NSMutableArray array];
    }
    
    return _imageObjectArray;
    
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
    
}

- (NSMutableArray *)urlImageArray
{
    
    if (!_urlImageArray) {
        
        _urlImageArray = [NSMutableArray array];
    }
    
    return _urlImageArray;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (OSSApi *)Ossapi
{
    
    if (!_Ossapi) {
        
        _Ossapi = [[OSSApi alloc]init];
        
        _Ossapi.delegate  =self;
        
    }
    return _Ossapi;
    
}

- (FillApi *)fillApi
{
    if (!_fillApi) {
        
        _fillApi = [[FillApi alloc]init];
        
        _fillApi.delegate = self;
        
    }
    
    return _fillApi;
    
}

- (FindGroupApi *)findApi1
{
    if (!_findApi1) {
        
        _findApi1 = [[FindGroupApi alloc]init];
        
        _findApi1.delegate = self;
        
    }
    
    return _findApi1;
    
}

- (FindGroupApi *)findApi
{
    if (!_findApi) {
        
        _findApi = [[FindGroupApi alloc]init];
        
        _findApi.delegate = self;
        
    }
    
    return _findApi;
    
}

- (isAttendGroupConApi *)attenedApi
{
    if (!_attenedApi) {
        
        _attenedApi = [[isAttendGroupConApi alloc]init];
        
        _attenedApi.delegate = self;
    }
    
    return _attenedApi;
    
}

- (isAttendGroupConApi *)NattenedApi
{
    if (!_NattenedApi) {
        
        _NattenedApi = [[isAttendGroupConApi alloc]init];
        
        _NattenedApi.delegate = self;
    }
    
    return _NattenedApi;
    
}

- (InvitorDetailApi *)detailApi
{
    if (!_detailApi) {
        
        _detailApi = [[InvitorDetailApi alloc]init];
        
        _detailApi.delegate  =self;
    }
    return _detailApi;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.hub hide:YES];

}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    if (api == _fillApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];

        [self.hub hide:YES];

        InviteDoctorViewController *invite = [InviteDoctorViewController new];
        
        invite.groupID = responsObject[@"id"];
        
        invite.title = @"选择医生";
        
        [self.navigationController pushViewController:invite animated:YES];
        
    }
    
    if (api == _Ossapi) {
        
        [Utils postMessage:command.response.msg onView:self.view];

        OSSModel *model = responsObject;
        
        [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            NSLog(@"%@",names);
            
            for (NSString *name in names) {
                
                NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                
                [self.urlImageArray addObject:url];
                
            }
            
            FillHeader *head = [[FillHeader alloc]init];
            //
            head.target = @"huizhenControl";
            
            head.method = @"huizhen";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
            head.token = [User LocalUser].token;
            
            FillBody *body = [[FillBody alloc]init];
            
            body.patientname = self.name.text;
            
            body.item = self.subject.text;
            
            body.des = self.textView.text;
            
            body.imagepath = [self.urlImageArray componentsJoinedByString:@","];
            
            FillAndInviteRequest *request = [[FillAndInviteRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            NSLog(@"%@",request);
            
            [self.fillApi fillAndCommit:request.mj_keyValues.mutableCopy];
            
        }];
        
        NSLog(@"%@",self.urlImageArray);
        
    }
    
    if (api == _attenedApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];

        [self.hub hide:YES];

        NSLog(@"canyu:%@",responsObject);
        
        FindGroupInfoHeader *head = [[FindGroupInfoHeader alloc]init];
        //
        head.target = @"huizhenControl";
        
        head.method = @"findGroup";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        FindGroupInfoBody *body = [[FindGroupInfoBody alloc]init];
        
        body.id = responsObject[@"mdtgroupid"];

        FindGroupInfoRequest *request = [[FindGroupInfoRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.findApi getGroupInfo:request.mj_keyValues.mutableCopy];
        
    }
    
    if (api == _NattenedApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];

        [self.hub hide:YES];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (api == _detailApi) {
        
        GlistModel *model = [GlistModel mj_objectWithKeyValues:responsObject];
        
        self.glistmodel = model;
        
        self.name.text = model.patientname;
        
        self.subject.text  = model.item;
        
        self.textView.text  = model.des;
        
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
        
    }
    
    if (api == _findApi) {
        
        GroupInfoModel *model = responsObject;
        
        HuizhenConversationViewController *conver = [[HuizhenConversationViewController alloc]init];
        conver.isGroupCon = YES;
        conver.item = model.groupname;
        conver.targetId = model.groupid;
        self.mdtgroupid = model.groupid;
        self.mdtgroupname = model.groupname;
        //本地保存
        [User LocalUser].mdtgroupid = model.groupid;
        [User LocalUser].mdtgroupname = model.groupname;
        [User LocalUser].mdtgroupfacepath = model.groupfacepath;
        [User saveToDisk];
        //
        conver.mdtgroupname = model.groupname;
        conver.conversationType = ConversationType_GROUP;
        conver.title = model.groupname;
        [self.navigationController pushViewController:conver animated:YES];
        
    }
    
    if (api == _findApi1) {
        
        GroupInfoModel *model = responsObject;
        HuizhenConversationViewController *conver = [[HuizhenConversationViewController alloc]init];
        conver.isGroupCon = YES;
        conver.item = self.glistmodel.item;
        conver.targetId = self.mdtgroupid;
        conver.mdtgroupname = self.mdtgroupname;
        conver.conversationType = ConversationType_GROUP;
        conver.title = self.glistmodel.item;
        [User LocalUser].mdtgroupid = model.groupid;
        [User LocalUser].mdtgroupname = model.groupname;
        [User LocalUser].mdtgroupfacepath = model.groupfacepath;
        [User saveToDisk];
        [self.navigationController pushViewController:conver animated:YES];
        
    }
    
}

- (instancetype)initWithType:(GroupConsultType)type withID:(NSString *)tid{
    
    self = [super init];
    
    if (self) {
        
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
        
        switch (type) {
            case GroupConsultTypeInvite:
            {
                [self.view addSubview:self.inviteGroupCon];
                [self.inviteGroupCon addTarget:self action:@selector(toinvite) forControlEvents:UIControlEventTouchUpInside];
                [self.inviteGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                }];
                
            }
                break;
            case GroupConsultTypeJoinOrNot:
            {
                [self.view addSubview:self.rejectGroupCon];
                [self.rejectGroupCon addTarget:self action:@selector(rejectJoin) forControlEvents:UIControlEventTouchUpInside];
                
                [self.rejectGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(kScreenWidth/2);
                    make.height.mas_equalTo(50);
                }];
                [self.view addSubview:self.joinGroupCon];
                [self.joinGroupCon addTarget:self action:@selector(toJoin) forControlEvents:UIControlEventTouchUpInside];
                [self.joinGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(self.rejectGroupCon.mas_right);
                    make.width.mas_equalTo(self.rejectGroupCon.mas_width);
                    make.height.mas_equalTo(self.rejectGroupCon.mas_height);
                }];
                
                self.tid = tid;
                
                InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
                
                header.target = @"huizhenControl";
                
                header.method = @"huizhenDetail";
                
                header.versioncode = Versioncode;
                
                header.devicenum = Devicenum;
                
                header.fromtype = Fromtype;
                
                header.token = [User LocalUser].token;
                
                InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
                
                bodyer.id = tid;
                
                InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
                
                requester.head = header;
                
                requester.body = bodyer;
                
                NSLog(@"%@",requester);
                
                [self.detailApi getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
                
            }
            default:
                break;
        }
        
    }
    return self;
}

- (instancetype)initWithType:(GroupConsultType)type withID:(NSString *)tid isAgree:(BOOL)isAgree
{
    
    self = [super init];
    
    if (self) {
        
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
        
        switch (type) {
            case GroupConsultTypeInvite:
            {
                [self.view addSubview:self.inviteGroupCon];
                [self.inviteGroupCon addTarget:self action:@selector(toinvite) forControlEvents:UIControlEventTouchUpInside];
                [self.inviteGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                }];
                
            }
                break;
            case GroupConsultTypeJoinOrNot:
            {
                [self.view addSubview:self.rejectGroupCon];
                [self.rejectGroupCon addTarget:self action:@selector(rejectJoin) forControlEvents:UIControlEventTouchUpInside];
                
                [self.rejectGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(kScreenWidth/2);
                    make.height.mas_equalTo(50);
                }];
                [self.view addSubview:self.joinGroupCon];
                [self.joinGroupCon addTarget:self action:@selector(toJoin) forControlEvents:UIControlEventTouchUpInside];
                [self.joinGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(self.rejectGroupCon.mas_right);
                    make.width.mas_equalTo(self.rejectGroupCon.mas_width);
                    make.height.mas_equalTo(self.rejectGroupCon.mas_height);
                }];
                
                self.tid = tid;
                
                InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
                
                header.target = @"huizhenControl";
                
                header.method = @"huizhenDetail";
                
                header.versioncode = Versioncode;
                
                header.devicenum = Devicenum;
                
                header.fromtype = Fromtype;
                
                header.token = [User LocalUser].token;
                
                InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
                
                bodyer.id = tid;
                
                InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
                
                requester.head = header;
                
                requester.body = bodyer;
                
                NSLog(@"%@",requester);
                
                [self.detailApi getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
                
            }
                
              case GroupConsultTypeAgree:
            {
                
                [self.view addSubview:self.agreeGroupCon];
                [self.agreeGroupCon addTarget:self action:@selector(gochat) forControlEvents:UIControlEventTouchUpInside];
                
                [self.agreeGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                }];
            
                self.tid = tid;
                
                InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
                
                header.target = @"huizhenControl";
                
                header.method = @"huizhenDetail";
                
                header.versioncode = Versioncode;
                
                header.devicenum = Devicenum;
                
                header.fromtype = Fromtype;
                
                header.token = [User LocalUser].token;
                
                InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
                
                bodyer.id = tid;
                
                InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
                
                requester.head = header;
                
                requester.body = bodyer;
                
                NSLog(@"%@",requester);
                
                [self.detailApi getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
                
            }
            default:
                break;
        }
        
    }
    return self;
    
}

- (instancetype)initWithType:(GroupConsultType)type withid:(NSString *)tid{
    
    self = [super init];
    
    if (self) {
        
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
        
    }
    return self;
}



- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)gochat{
    
            FindGroupInfoHeader *head = [[FindGroupInfoHeader alloc]init];
            //
            head.target = @"huizhenControl";
            
            head.method = @"findGroup";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
            head.token = [User LocalUser].token;
            
            FindGroupInfoBody *body = [[FindGroupInfoBody alloc]init];
            
            body.id = self.mdtgroupid;
            
            FindGroupInfoRequest *request = [[FindGroupInfoRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            NSLog(@"%@",request);
            
            [self.findApi1 getGroupInfo:request.mj_keyValues.mutableCopy];
  
 
}

//to invite doctor

- (void)rejectJoin{
    
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            IsAttendHeader *header = [[IsAttendHeader alloc]init];
            
            header.target = @"huizhenControl";
            
            header.method = @"huizhenXuanze";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            IsAttendBody *bodyer = [[IsAttendBody alloc]init];
            
            bodyer.id = self.tid;
            
            bodyer.choose = @"2";
            
            IsAttenendGroupConRequest *requester = [[IsAttenendGroupConRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.NattenedApi getIsttendDetail:requester.mj_keyValues.mutableCopy];
  
 
}

//reject to join

- (void)toinvite{
    
            
            if (self.name.text.length <= 0) {
                
                [Utils postMessage:@"请填写患者姓名" onView:self.view];
                
                return;
                
            }
            
            if (self.subject.text.length <= 0) {
                
                [Utils postMessage:@"请填写会诊主题" onView:self.view];
                
                return;
                
            }
            
            if (self.textView.text.length <= 0) {
                
                [Utils postMessage:@"请填写详情描述" onView:self.view];
                
                return;
                
            }
            
            if (self.imageObjectArray.count <= 0) {
                
                [Utils postMessage:@"请上传图片资料" onView:self.view];
                
                return;
                
            }
            
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
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
  
 
}

// to join

- (void)toJoin{
  
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            IsAttendHeader *header = [[IsAttendHeader alloc]init];
            
            header.target = @"huizhenControl";
            
            header.method = @"huizhenXuanze";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            IsAttendBody *bodyer = [[IsAttendBody alloc]init];
            
            bodyer.id = self.tid;
            
            bodyer.choose = @"1";
            
            IsAttenendGroupConRequest *requester = [[IsAttenendGroupConRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.attenedApi getIsttendDetail:requester.mj_keyValues.mutableCopy];
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


- (EditTableViewCell *)desHeader {
    if (!_desHeader) {
        _desHeader = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_desHeader setTypeName:@"详情描述" placeholder:@""];
        [_desHeader setEditAble:NO];
        _desHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        _desHeader.textField.keyboardType = UIKeyboardTypeDefault;
        
    }
    return _desHeader;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = FontNameAndSize(16);
        _textView.editable = NO;
        _textView.textColor = DefaultBlackLightTextClor;
        _textView.placeholder = @"请描述会诊的内容，方便医生更好的给出专业意见（最少10个字）";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        
    }
    return _textView;
}

- (YQWaveButton *)inviteGroupCon
{
    
    if (!_inviteGroupCon) {
        
        _inviteGroupCon = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        _rejectGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _inviteGroupCon.backgroundColor = AppStyleColor;
        
        [_inviteGroupCon setTitle:@"邀请会诊" forState:UIControlStateNormal];
        
        [_inviteGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _inviteGroupCon;
}

- (YQWaveButton *)joinGroupCon
{
    
    if (!_joinGroupCon) {
        
        _joinGroupCon = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        _joinGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _joinGroupCon.backgroundColor = AppStyleColor;
        
        [_joinGroupCon setTitle:@"进入会诊" forState:UIControlStateNormal];
        
        [_joinGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _joinGroupCon;
}

- (YQWaveButton *)rejectGroupCon
{
    
    if (!_rejectGroupCon) {
        
        _rejectGroupCon = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        _rejectGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _rejectGroupCon.backgroundColor = [UIColor whiteColor];
        
        [_rejectGroupCon setTitle:@"暂不参与" forState:UIControlStateNormal];
        
        [_rejectGroupCon setTitleColor:AppStyleColor forState:UIControlStateNormal];
        
    }
    return _rejectGroupCon;
}

- (YQWaveButton *)agreeGroupCon
{
    
    if (!_agreeGroupCon) {
        
        _agreeGroupCon = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        _agreeGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _agreeGroupCon.backgroundColor = AppStyleColor;
        
        [_agreeGroupCon setTitle:@"进入会诊群聊" forState:UIControlStateNormal];
        
        [_agreeGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _agreeGroupCon;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.basicInfo.count;
    }else if(section == 2){
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        if (section == 0) {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }
        
    }else{
        if (section == 0) {
            return nil;
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
            
            [cell refreshWirthModel1:self.textView.text];
        }];
        
    }else if(indexPath.section == 2){
        return 43;
    }else{
        return 43;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        [self.subject setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, MAXFLOAT)];
        return [self.basicInfo safeObjectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 1){
        
        MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshWirthModel1:self.textView.text];
        
        return cell;
        
    }else{
        customFootCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([customFootCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        
        ImageTableViewCell *cell = (ImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.imageArray placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"] atIndex:indexPath.row dismiss:nil];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.tableView registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyIntroTableViewCell class])];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[customFootCell class] forCellReuseIdentifier:NSStringFromClass([customFootCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImageTableViewCell class])];
    self.basicInfo = @[self.name,self.subject];
    // Do any additional setup after loading the view.
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
