//
//  GroupConViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/11/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GroupConViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "EditTableViewCell.h"
#import "DesTableViewCell.h"
#import "GroupUploadPicTableViewCell.h"
#import "InviteDoctorViewController.h"
#import "FillApi.h"
#import "FillAndInviteRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import "MBProgressHUD+BWMExtension.h"

@interface GroupConViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ApiRequestDelegate>

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSModel *model;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) EditTableViewCell *name;

@property (nonatomic, strong) EditTableViewCell *subject;

@property (nonatomic, strong) EditTableViewCell *desHeader;

@property (nonatomic,strong) NSArray *basicInfo;

@property (nonatomic,strong)SZTextView *textView;

//相关事件

@property (nonatomic,strong)UIButton *inviteGroupCon;    //invite

@property (nonatomic,strong)UIButton *joinGroupCon;      //join

@property (nonatomic,strong)UIButton *rejectGroupCon;    //reject

@property (nonatomic,strong)FillApi *fillApi;

@property (nonatomic,strong)MBProgressHUD *hub;

@property (nonatomic,strong)NSMutableArray *imageObjectArray;

@property (nonatomic,strong)NSMutableArray *urlImageArray;

@property (nonatomic,strong)NSString *GroupId;

@property (nonatomic,strong)NSString *taskno;

@end

@implementation GroupConViewController

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


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.hub hide:YES];

}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    [Utils postMessage:command.response.msg onView:self.view];

    if (api == _fillApi) {
        
        [self.hub bwm_hideWithTitle:@"提交成功"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval
                            msgType:BWMMBProgressHUDMsgTypeSuccessful];
        InviteDoctorViewController *invite = [InviteDoctorViewController new];
        invite.groupID = responsObject[@"id"];
        invite.title = @"选择医生";
        [self.navigationController pushViewController:invite animated:YES];
        
    }
    
    if (api == _Ossapi) {
        
        OSSModel *model = responsObject;
        
        [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            NSLog(@"%@",names);
            [self.urlImageArray removeAllObjects];
            
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
            
            body.taskno = self.taskno;
            
            body.imagepath = [self.urlImageArray componentsJoinedByString:@","];
            
            FillAndInviteRequest *request = [[FillAndInviteRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            NSLog(@"%@",request);
            
            [self.fillApi fillAndCommit:request.mj_keyValues.mutableCopy];
            
        }];
        
        NSLog(@"%@",self.urlImageArray);
        
    }
    
}

- (instancetype)initWithType:(GroupConsultType)type withPName:(NSString *)name des:(NSString *)des imageArray:(NSMutableArray *)imagepathArr taskNo:(NSString *)taskno{
    
    self = [super init];
    
    if (self) {
        
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
        
        switch (type) {
            case GroupConsultTypeInvite:
            {
                self.name.text = name;
                self.textView.text = des;
                self.urlImageArray = imagepathArr;
                self.taskno = taskno;
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
                
            }
            default:
                break;
        }
        
    }
    return self;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//to invite doctor

- (void)rejectJoin{
    
    
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
    
    self.hub = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在提交..."];

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

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = Font(16);
        _textView.textColor = DefaultGrayTextClor;
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
        
        _rejectGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];
        
        _inviteGroupCon.backgroundColor = AppStyleColor;
        
        [_inviteGroupCon setTitle:@"邀请会诊" forState:UIControlStateNormal];
        
        [_inviteGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _inviteGroupCon;
}

- (UIButton *)joinGroupCon
{
    
    if (!_joinGroupCon) {
        
        _joinGroupCon = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _joinGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];

        _joinGroupCon.backgroundColor = AppStyleColor;
        
        [_joinGroupCon setTitle:@"进入会诊" forState:UIControlStateNormal];
        
        [_joinGroupCon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _joinGroupCon;
}

- (UIButton *)rejectGroupCon
{
    
    if (!_rejectGroupCon) {
        
        _rejectGroupCon = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _rejectGroupCon.titleLabel.font = [UIFont systemFontOfSize:18.0];

        _rejectGroupCon.backgroundColor = [UIColor whiteColor];
        
        [_rejectGroupCon setTitle:@"暂不参与" forState:UIControlStateNormal];
        
        [_rejectGroupCon setTitleColor:AppStyleColor forState:UIControlStateNormal];
        
    }
    return _rejectGroupCon;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.basicInfo.count;
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
        return 227.5;
    }else if(indexPath.section == 2){
        return 260;
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
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.desHeader];
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:203/255.0 alpha:1.0f];
        [cell addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.desHeader.bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [cell addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(lineview.mas_bottom);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        return cell;
        
    }else{
        
        GroupUploadPicTableViewCell *cell = [[GroupUploadPicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GroupUploadPicTableViewCell class]) withApp:self.urlImageArray];
        cell.select = ^(NSArray *arr) {
            
            NSLog(@"%@",arr);
//
           self.imageObjectArray = arr.mutableCopy;
//            NSLog(@"%@",self.imageObjectArray);
            
        };
        return cell;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.basicInfo = @[self.name,self.subject];
    
    // Do any additional setup after loading the view.
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
