//
//  BeginHuizhenViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BeginHuizhenViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "EditTableViewCell.h"
#import "SelectSexCell.h"
#import "MyIntroTableViewCell.h"
#import "SZTextView.h"
#import "ACMediaFrame.h"
#import "SureDoctorViewController.h"
#import "SelectHuanzheTableViewController.h"
#import "HuanZheModel.h"
#import "UploadToolRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "OSSImageUploader.h"
#import "HuizhenCommitModel.h"
#import "sendHZApi.h"
#import "sendHZRequest.h"
//
#import "deleHZApi.h"
#import "AlertView.h"
#import "LYZAdView.h"
//
#import "GetHZInfoRequest.h"
#import "getHZInformationApi.h"
#import "FillHZmodel.h"
#define kFetchTag 5000
@interface BeginHuizhenViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ApiRequestDelegate,BaseMessageViewDelegate>{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;
}
@property (nonatomic,strong)UIView *headview;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableview;
@property (nonatomic,strong)UIButton *nextStepButton;
//cell
@property (nonatomic,strong)EditTableViewCell *canyuhuanzheCell;
@property (nonatomic,strong)EditTableViewCell *subject;
@property (nonatomic,strong)EditTableViewCell *huanzheCell;
@property (nonatomic,strong)SelectSexCell *sexcell;
@property (nonatomic,strong)EditTableViewCell *agecell;
@property (nonatomic,strong)SZTextView *textView;
@property (nonatomic, strong)EditTableViewCell *desHeader;
//
@property (nonatomic,strong)NSString *sexString;
@property (nonatomic,strong)NSArray *nomalData;
@property (nonatomic,strong)ACSelectMediaView *BGmamediaView;
@property (nonatomic,strong)NSMutableArray *imageObjectArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@property (nonatomic,strong)OSSApi *Api;
@property (nonatomic,strong)sendHZApi *sendApi;
@property (nonatomic,strong)NSString *yuyueID;
@property (nonatomic,strong)NSString *mdtidID;
@property (nonatomic,strong)deleHZApi *delApi;
//预填写接口
@property (nonatomic,strong)getHZInformationApi *fillApi;
@property (nonatomic,strong)FillHZmodel *model;
@property (nonatomic,strong)NSMutableArray *modifyHZPreArray;

@end

@implementation ImgTableviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.intro = [[UILabel alloc]init];
        self.intro.textColor = DefaultGrayTextClor;
        self.intro.text = @"上传相关图片（检查报告/影像资料）";
        self.intro.textAlignment = NSTextAlignmentLeft;
        self.intro.font = FontNameAndSize(16);
        [self.contentView addSubview:self.intro];
//        self.sep = [[UILabel alloc]init];
//        self.sep.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.sep];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self layOut];
    }
    return self;
}


- (void)layOut{
    
    [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(25.5);
    }];
    
//    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(0.5);
//        make.bottom.mas_equalTo(0);
//    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end

@implementation BeginHuizhenViewController

- (OSSApi *)Api{
    if (!_Api) {
        _Api = [[OSSApi alloc]init];
        _Api.delegate = self;
    }
    return _Api;
}

- (sendHZApi *)sendApi{
    if (!_sendApi) {
        _sendApi = [[sendHZApi alloc]init];
        _sendApi.delegate = self;
    }
    return _sendApi;
}

- (deleHZApi *)delApi{
    if (!_delApi) {
        _delApi = [[deleHZApi alloc]init];
        _delApi.delegate = self;
    }
    return _delApi;
}

- (getHZInformationApi *)fillApi{
    if (!_fillApi) {
        _fillApi = [[getHZInformationApi alloc]init];
        _fillApi.delegate  =self;
    }
    return _fillApi;
}

- (NSMutableArray *)urlArray{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _Api) {
        OSSModel *model = responsObject;
        [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [Utils removeHudFromView:self.view];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    [self.urlArray addObject:url];
                }
                NSLog(@"%@",self.urlArray);
            });
        }];
    }
  
    if (api == _sendApi) {
        [Utils removeAllHudFromView:self.view];
        SureDoctorViewController *sure = [SureDoctorViewController new];
        sure.huizhenid = responsObject[@"id"];
        sure.title = @"选择医生";
        [self.navigationController pushViewController:sure animated:YES];
    }
    
    if (api == _delApi) {
        [Utils postMessage:@"删除成功" onView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (api == _fillApi) {
        FillHZmodel *model = responsObject;
        self.model = model;
        self.canyuhuanzheCell.text = model.name;
        self.subject.text = model.topic;
        self.huanzheCell.text = model.name;
        if ([model.sex isEqualToString:@"男"]) {
            [self.sexcell setSex:@"1"];
            self.sexString = @"男";
        }else{
            [self.sexcell setSex:@"0"];
            self.sexString = @"女";
        }
        self.agecell.text = model.age;
        self.textView.text = model.zhengzhuang;
        self.BGmamediaView.preShowMedias = [model.blimages componentsSeparatedByString:@";"];
    }
}
- (UIView *)headview{
    if (!_headview) {
        _headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
        _headview.backgroundColor = [UIColor whiteColor];
        UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [proButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [proButton setTitle:@"填写资料" forState:UIControlStateNormal];
        proButton.titleLabel.font = Font(15);
        [self.headview addSubview:proButton];
        [proButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selButton setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
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
        _tableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableview registerClass:[ImgTableviewCell class] forCellReuseIdentifier:NSStringFromClass([ImgTableviewCell class])];
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.separatorColor = HexColor(0xe7e7e9);
        _tableview.delegate = self;
        _tableview.dataSource  =self;
    }
    return _tableview;
}

- (EditTableViewCell *)canyuhuanzheCell {
    if (!_canyuhuanzheCell) {
        _canyuhuanzheCell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_canyuhuanzheCell setTypeName:@"参与会诊患者" placeholder:@""];
        _canyuhuanzheCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _canyuhuanzheCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _canyuhuanzheCell.textField.keyboardType = UIKeyboardTypeDefault;
        [_canyuhuanzheCell setEditAble:NO];
    }
    return _canyuhuanzheCell;
}

- (EditTableViewCell *)subject {
    if (!_subject) {
        _subject = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _subject.selectionStyle = UITableViewCellSelectionStyleNone;
        [_subject setTypeName:@"会诊主题" placeholder:@"请输入会诊主题"];
        _subject.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _subject;
}

- (EditTableViewCell *)huanzheCell {
    if (!_huanzheCell) {
        _huanzheCell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _huanzheCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_huanzheCell setTypeName:@"会诊患者" placeholder:@"请输入患者姓名"];
        _huanzheCell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _huanzheCell;
}

- (SelectSexCell *)sexcell{
    if (!_sexcell) {
        _sexcell = [[SelectSexCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_sexcell setSex:@"1"];
        _sexcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _sexcell;
}

- (EditTableViewCell *)agecell {
    if (!_agecell) {
        _agecell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _agecell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_agecell setTypeName:@"患者年龄" placeholder:@"请输入患者年龄"];
        _agecell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _agecell;
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
        _textView.textColor = DefaultBlackLightTextClor;
        _textView.placeholder = @"请填写会诊描述内容，方便医生给出更好的专业意见，不少于10字";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}

- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.backgroundColor = AppStyleColor;
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextstep) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}
- (void)setLayOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headview.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (UIImage *) imageFromURLString: (NSString *) urlstring{
    return [UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headview];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.nextStepButton];
    [self setLayOut];
    if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
        self.nomalData = @[self.canyuhuanzheCell,self.subject,self.huanzheCell,self.sexcell,self.agecell];
    }else{
        self.nomalData = @[self.subject,self.huanzheCell,self.sexcell,self.agecell];
    }
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    self.view.backgroundColor = DefaultBackgroundColor;
    weakify(self);
    self.sexString = @"男";
    self.sexcell.type = ^(NSString *type) {
        NSLog(@"%@",type);
        strongify(self);
        if ([type isEqualToString:@"1"]) {
            self.sexString = @"男";
        }else{
            self.sexString = @"女";
        }
    };
    self.BGmamediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.BGmamediaView .type = ACMediaTypePhotoAndCamera;
    self.BGmamediaView .maxImageSelected = 9;
    self.BGmamediaView .naviBarBgColor = AppStyleColor;
    self.BGmamediaView .rowImageCount = 3;
    self.BGmamediaView .lineSpacing = 20;
    self.BGmamediaView .interitemSpacing = 20;
    self.BGmamediaView .sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.BGmamediaView  observeViewHeight:^(CGFloat mediaHeight) {
        self.tableview.tableFooterView = self.BGmamediaView;
    }];
    
    [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        self.imageObjectArray = [NSMutableArray array];
        [self.imageObjectArray removeAllObjects];
        if (self.isModify == YES) {
            NSLog(@"--%@",list);
            for (ACMediaModel *model in list) {
                if (model.imageUrlString) {
                    [self.imageObjectArray addObject:[self imageFromURLString:model.imageUrlString]];
                }
                [self.imageObjectArray addObject:model.image];
            }
            NSLog(@"--------%@",self.imageObjectArray);
            
            if (!self.imageObjectArray) {
                return ;
            }else{
            [Utils addHudOnView:self.view];
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
            [self.Api getoss:requester.mj_keyValues.mutableCopy];
            }
        }else{
            for (ACMediaModel *model in list) {
                [self.imageObjectArray addObject:model.image];
            }
            if (!self.imageObjectArray) {
                return ;
            }else{
                [Utils addHudOnView:self.view];
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
                [self.Api getoss:requester.mj_keyValues.mutableCopy];
            }
        }
        
    }];
    
    if (self.isModify == YES) {
        //请求签名
        getHZinfoHeader *header = [[getHZinfoHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"huizhenDetail";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        getHZinfoBody *bodyer = [[getHZinfoBody alloc]init];
        bodyer.id = self.hzid;
        GetHZInfoRequest *requester = [[GetHZInfoRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.fillApi getHZinformation:requester.mj_keyValues.mutableCopy];
    }
    
}

- (void)back{
    NSString *content = @"放弃会诊并退出？";
    [self showScanMessageTitle:nil content:content leftBtnTitle:@"取消" rightBtnTitle:@"确定退出" tag:50000];
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
    if (messageView.tag == 50000) {
        if ([event isEqualToString:@"确定退出"]) {
            if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Utils addHudOnView:self.view];
                sendHZHeader *header = [[sendHZHeader alloc]init];
                header.target = @"doctorHuizhenControl";
                header.method = @"deleteHuizhen";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                sendHZBody *bodyer = [[sendHZBody alloc]init];
                bodyer.id = self.mdtidID;
                sendHZRequest *requester = [[sendHZRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                NSLog(@"%@",requester);
                [self.delApi deleHZ:requester.mj_keyValues.mutableCopy];
            }
        }else{
            
        }
    }
    [messageView hide];
    
}

- (void)nextstep{
    if (self.isModify == YES) {
        SureDoctorViewController *sure = [SureDoctorViewController new];
        sure.isModify = YES;
        sure.name = self.huanzheCell.text;
        sure.sex = self.sexString;
        sure.zhengzhuang = self.textView.text;
        sure.blimages = [self.urlArray componentsJoinedByString:@";"];
        sure.topic = self.subject.text;
        sure.age = self.agecell.text;
//        sure.huizhenid = self.model.//会诊时间
        sure.huizhenid = self.model.id;
        sure.title = @"选择医生";
        [self.navigationController pushViewController:sure animated:YES];
    }else{
        if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
            if (self.canyuhuanzheCell.text.length <= 0) {
                [Utils postMessage:@"请选择参与会诊的患者" onView:self.view];
                return;
            }
        }
        
        if (self.subject.text.length <= 0) {
            [Utils postMessage:@"请填写会诊主题" onView:self.view];
            return;
        }
        if (self.huanzheCell.text.length <= 0) {
            [Utils postMessage:@"请填写会诊患者姓名" onView:self.view];
            return;
        }
        
        if (self.sexString.length <= 0) {
            [Utils postMessage:@"请填写患者性别" onView:self.view];
            return;
        }
        if (self.agecell.text.length <= 0) {
            [Utils postMessage:@"请填写患者年龄" onView:self.view];
            return;
        }
        if (self.textView.text.length <= 0) {
            [Utils postMessage:@"请填写详情描述" onView:self.view];
            return;
        }
        if (self.textView.text.length > 0 && self.textView.text.length < 10) {
            [Utils postMessage:@"详情描述不少于10字" onView:self.view];
            return;
        }
        
        if (self.imageObjectArray.count <= 0) {
            [Utils postMessage:@"请上传会诊图片资料" onView:self.view];
            return;
        }
        [Utils addHudOnView:self.view];
        //请求签名
        sendHZHeader *header = [[sendHZHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"createHuizhen";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        sendHZBody *bodyer = [[sendHZBody alloc]init];
        if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
            bodyer.id  = self.mdtidID;
        }else{
            bodyer.id  = @"";
        }
        bodyer.topic = self.subject.text;
        bodyer.name = self.huanzheCell.text;
        bodyer.sex = self.sexString;
        bodyer.age = self.agecell.text;
        bodyer.zhengzhuang = self.textView.text;
        bodyer.blimages = [self.urlArray componentsJoinedByString:@";"];
        sendHZRequest *requester = [[sendHZRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.sendApi sendHZ:requester.mj_keyValues.mutableCopy];
    }
   
}

#pragma mark----TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
        if (section == 0) {
            return 5;
        }else{
            return 1;
        }
    }else{
        if (section == 0) {
            return 4;
        }else{
            return 1;
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        return 150;
    }else{
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 1 || section ==2) {
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
    } else {
        if (section == 1 || section == 2) {
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
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
        return [self.nomalData objectAtIndex:indexPath.row];
    }else if(indexPath.section ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.desHeader];
        [self.desHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
//        UIView *lineView = [[UIView alloc]init];
//        lineView.backgroundColor = DividerGrayColor;
//        [cell addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(20);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(0.5);
//            make.top.mas_equalTo(self.desHeader.mas_bottom).mas_equalTo(5);
//        }];
        [cell addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.desHeader.mas_bottom).mas_equalTo(5);
            make.left.right.bottom.mas_equalTo(0);
        }];
        return cell;
    }else{
        ImgTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImgTableviewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[User LocalUser].kefu isEqualToString:@"Y"]) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            SelectHuanzheTableViewController *select = [SelectHuanzheTableViewController new];
            select.hospital = ^(HuanZheModel *model) {
                self.canyuhuanzheCell.text = model.name;
                self.yuyueID = model.id;
                self.mdtidID = model.mdtid;
                self.huanzheCell.text = model.name;
                self.subject.text = model.topic;
                if ([model.sex isEqualToString:@"男"]) {
                    [self.sexcell setSex:@"1"];
                    self.sexString = @"男";
                }else{
                    [self.sexcell setSex:@"0"];
                    self.sexString = @"女";
                }
                self.agecell.text = model.age;
                self.textView.text = model.zhengzhuang;
            };
            select.title = @"会诊邀请";
            [self.navigationController pushViewController:select animated:YES];
        }
    }
}

@end

