//
//  FillAdviceViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FillAdviceViewController.h"
#import "SZTextView.h"
#import "ACMediaFrame.h"
#import <TPKeyboardAvoidingTableView.h>
#define kFetchTag 2000
#import "AlertView.h"
#import "commitAgreebookApi.h"
#import "commitAgreeBookRequest.h"
#import "OSSModel.h"
#import "OSSApi.h"
#import "OSSImageUploader.h"
#import "UploadToolRequest.h"
#import "endHZApi.h"
@interface FillAdviceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,BaseMessageViewDelegate,ApiRequestDelegate>{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;
}
@property (nonatomic,strong)ACSelectMediaView *BGmamediaView;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableview;
@property (nonatomic,strong)SZTextView *textView;
@property (nonatomic,strong)commitAgreebookApi *commitApi;
@property (nonatomic,strong)OSSApi *ossApi;
@property (nonatomic,strong)endHZApi *endApi;
@property (nonatomic,strong)NSMutableArray *imageObjectArray;
@property (nonatomic,strong)NSMutableArray *urlImageArray;

@end

@implementation FillAdviceViewController

- (commitAgreebookApi *)commitApi{
    if (!_commitApi) {
        _commitApi = [[commitAgreebookApi alloc]init];
        _commitApi.delegate = self;
    }
    return _commitApi;
}

- (OSSApi *)ossApi{
    if (!_ossApi) {
        _ossApi = [[OSSApi alloc]init];
        _ossApi.delegate = self;
    }
    return _ossApi;
}

- (endHZApi *)endApi{
    if (!_endApi) {
        _endApi = [[endHZApi alloc]init];
        _endApi.delegate = self;
    }
    return _endApi;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeAllHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _commitApi) {
        NSString *content = @"已提交意见书，是否解散该群";
        [self showScanMessageTitle:nil content:content leftBtnTitle:@"不解散" rightBtnTitle:@"解散" tag:kFetchTag];
    }
    
    if (api== _ossApi) {
        OSSModel *model = responsObject;
        [Utils removeAllHudFromView:self.view];
        [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            NSLog(@"%@",names);
            self.urlImageArray = [NSMutableArray array];
            [self.urlImageArray removeAllObjects];
            for (NSString *name in names) {
                NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                [self.urlImageArray addObject:url];
            }
        }];
    }
    
    if (api == _endApi) {
        [Utils removeHudFromView:self.view];
        [Utils postMessage:@"会诊结束，解散会诊" onView:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableview.separatorColor = [UIColor whiteColor];
    }
    return _tableview;
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

- (void)setLayOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    [self setLayOut];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setRightNavigationItemWithTitle:@"确定" action:@selector(tosure)];
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
                [self.ossApi getoss:requester.mj_keyValues.mutableCopy];
            }
        }];
}

- (void)tosure{
    if (self.textView.text.length <= 0) {
        [Utils postMessage:@"请填写会诊意见" onView:self.view];
        return;
    }
    
    [Utils addHudOnView:self.view];
    //请求签名
    commitAgreeBookHeader *header = [[commitAgreeBookHeader alloc]init];
    header.target = @"doctorHuizhenControl";
    header.method = @"updateHuizhenResult";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    commitAgreeBookBody *bodyer = [[commitAgreeBookBody alloc]init];
    bodyer.id = self.huizhenid;
    bodyer.diagnose = self.textView.text;
    bodyer.diagnoseimages = [self.urlImageArray componentsJoinedByString:@";"];
    
    commitAgreeBookRequest *requester = [[commitAgreeBookRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    NSLog(@"%@",requester);
    [self.commitApi commitAgreebook:requester.mj_keyValues.mutableCopy];
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
        if ([event isEqualToString:@"解散"]) {
            [Utils addHudOnView:self.view];
            //请求签名
            commitAgreeBookHeader *header = [[commitAgreeBookHeader alloc]init];
            header.target = @"doctorHuizhenControl";
            header.method = @"finishHuizhen";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            commitAgreeBookBody *bodyer = [[commitAgreeBookBody alloc]init];
            bodyer.id = self.huizhenid;
            bodyer.diagnoseimages = [self.urlImageArray componentsJoinedByString:@","];
            commitAgreeBookRequest *requester = [[commitAgreeBookRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            NSLog(@"%@",requester);
            [self.endApi endHZ:requester.mj_keyValues.mutableCopy];
        }else if ([event isEqualToString:@"不解散"]){
            [messageView hide];
        }
    }
    [messageView hide];
    
}

#pragma mark-UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    } else {
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
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
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    return cell;
}

@end
