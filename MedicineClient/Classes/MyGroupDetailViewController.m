//
//  MyGroupDetailViewController.m
//  MedicineClient
//
//  Created by L on 2017/12/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyGroupDetailViewController.h"
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
#import "PhotoUpLoadTableViewCell.h"
#import "MBProgressHUD+BWMExtension.h"
#import "ACMediaFrame.h"

@interface MyGroupDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ApiRequestDelegate>{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;
}
@property (nonatomic,strong)ACSelectMediaView *BGmamediaView;

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)FillApi *fillApi;

@property (nonatomic,strong)OSSModel *model;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) EditTableViewCell *name;

@property (nonatomic, strong) EditTableViewCell *subject;

@property (nonatomic, strong) EditTableViewCell *desHeader;
@property (nonatomic, strong) EditTableViewCell *desHeader1;

@property (nonatomic,strong) NSArray *basicInfo;

@property (nonatomic,strong)SZTextView *textView;

@property (nonatomic,strong)UIButton *inviteGroupCon;

@property (nonatomic,strong)NSMutableArray *imageObjectArray;

@property (nonatomic,strong)NSMutableArray *urlImageArray;

@property (nonatomic,strong)MBProgressHUD *hub;

@end


@implementation customCell

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

@implementation MyGroupDetailViewController

- (NSMutableArray *)imageObjectArray
{
    if (!_imageObjectArray) {
        
        _imageObjectArray = [NSMutableArray array];
    }
    return _imageObjectArray;
}

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

- (FillApi *)fillApi
{
    if (!_fillApi) {
        
        _fillApi = [[FillApi alloc]init];
        
        _fillApi.delegate = self;
        
    }
    
    return _fillApi;
    
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.separatorColor = DividerGrayColor;
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
        _name.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _name;
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

- (EditTableViewCell *)desHeader1 {
    if (!_desHeader1) {
        _desHeader1 = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_desHeader1 setTypeName:@"病历资料" placeholder:@""];
        [_desHeader1 setEditAble:NO];
        _desHeader1.selectionStyle = UITableViewCellSelectionStyleNone;
        _desHeader1.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return _desHeader1;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = FontNameAndSize(16);
        _textView.textColor = DefaultBlackLightTextClor;
        _textView.placeholder = @"请描述会诊的内容，方便医生更好的给出专业意见（最少10个字）";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        
    }
    return _textView;
}

- (UIButton *)inviteGroupCon
{
    
    if (!_inviteGroupCon) {
        
        _inviteGroupCon = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _inviteGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _inviteGroupCon.backgroundColor = AppStyleColor;
        
        [_inviteGroupCon setTitle:@"发起会诊" forState:UIControlStateNormal];
        
        [_inviteGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _inviteGroupCon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[customCell class] forCellReuseIdentifier:NSStringFromClass([customCell class])];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImageTableViewCell class])];
    
    self.basicInfo = @[self.name,self.subject];
 
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    [self.view addSubview:self.inviteGroupCon];
    
    [self.inviteGroupCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    if (self.item) {
        self.subject.text = self.item;
    }
    
    [self.inviteGroupCon addTarget:self action:@selector(toCommit) forControlEvents:UIControlEventTouchUpInside];
  
    self.BGmamediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.BGmamediaView .type = ACMediaTypePhotoAndCamera;
    self.BGmamediaView .maxImageSelected = 12;
    self.BGmamediaView .naviBarBgColor = AppStyleColor;
    self.BGmamediaView .rowImageCount = 3;
    self.BGmamediaView .lineSpacing = 20;
    self.BGmamediaView .interitemSpacing = 20;
    self.BGmamediaView .sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.BGmamediaView  observeViewHeight:^(CGFloat mediaHeight) {
        self.tableView.tableFooterView = self.BGmamediaView;
    }];
    
    [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        self.imageObjectArray = [NSMutableArray array];
        [self.imageObjectArray removeAllObjects];
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
            [self.Ossapi getoss:requester.mj_keyValues.mutableCopy];
        }
    }];
}

- (void)toCommit{
    
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
    
    [Utils addHudOnView:self.view];
    
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
    
}



- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils removeHudFromView:self.view];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    
    if (api == _fillApi) {
        [Utils removeHudFromView:self.view];
        InviteDoctorViewController *invite = [InviteDoctorViewController new];
        invite.groupID = responsObject[@"id"];
        invite.title = @"选择医生";
        [self.navigationController pushViewController:invite animated:YES];
    }
    if (api == _Ossapi) {
        [Utils removeHudFromView:self.view];
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        weakify(self);
            [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
                self.urlImageArray = [NSMutableArray array];
                [self.urlImageArray removeAllObjects];
                NSLog(@"%@",names);
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    [self.urlImageArray addObject:url];
                }
                strongify(self);
                NSLog(@"%@",self.urlImageArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils removeHudFromView:self.view];
                });
                
            }];
    }
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.basicInfo.count;
    }else if(section == 1){
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
        return 15;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 150;
    }else if(indexPath.section == 0) {
        return 52;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        [self.subject setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, MAXFLOAT)];
        return [self.basicInfo safeObjectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell addSubview:self.desHeader];
        
        [self.desHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = DividerGrayColor;
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo(self.desHeader.mas_bottom).mas_equalTo(5);
        }];
        
        [cell addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(5);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        return cell;
    }else{
        customCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([customCell class])];
        return cell;
        
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
