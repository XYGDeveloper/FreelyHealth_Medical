//
//  GetAuthStateManager.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/4/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetAuthStateManager.h"
#import "MyProfileApi.h"
#import "MyProfilwModel.h"
#import "MyProfileRequest.h"
#import "LYZAdView.h"
#import "AlertView.h"
#define kFetchTag 2000

@interface GetAuthStateManager()<ApiRequestDelegate,BaseMessageViewDelegate>{
                 CallBackBlock  _callBackBlock;
}

@property (nonatomic,strong)MyProfileApi *api;

@end

@implementation GetAuthStateManager

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static GetAuthStateManager *AuthState;
    dispatch_once(&once, ^{
        AuthState = [[GetAuthStateManager alloc] init];
    });
    return AuthState;
}

- (instancetype)init
{
    if([super init]){
        if (!_api) {
            _api = [[MyProfileApi alloc] init];
            _api.delegate = self;
        }
    }
    return self;
}

- (void)getAuthStateWithallBackBlock:(CallBackBlock)callBackBlock{
    _callBackBlock = callBackBlock;
    //请求签名
    [Utils addHudOnView:[UIApplication sharedApplication].keyWindow];
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
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    MyProfilwModel *model = (MyProfilwModel *)responsObject;
    [User LocalUser].isauthenticate = model.isauthenticate;
    [User saveToDisk];
    if ([[User LocalUser].isauthenticate isEqualToString:@"1"]) {
        [Utils removeHudFromView:[UIApplication sharedApplication].keyWindow];
        AdViewMessageObject *messageObject = MakeAdViewObject(@"", @"",@"",NO);
        [LYZAdView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:1101];
    }else if ([[User LocalUser].isauthenticate isEqualToString:@"2"]){
        [Utils removeHudFromView:[UIApplication sharedApplication].keyWindow];
        NSString *content = @"提交的认证资料正在审核中,请耐心等待.";
        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"知道了" rightBtnTitle:nil tag:8000];
    }else{
        [Utils removeHudFromView:[UIApplication sharedApplication].keyWindow];
        //认证成功//认证失败条格子的页面
        if (_callBackBlock) {
            _callBackBlock(model.isauthenticate);
        }
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:[UIApplication sharedApplication].keyWindow];
    [Utils removeHudFromView:[UIApplication sharedApplication].keyWindow];
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
        if ([event isEqualToString:@"知道了"]) {
            
        }
    }
    [messageView hide];
    
}

@end
