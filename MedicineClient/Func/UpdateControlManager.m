//
//  UpdateControlManager.m
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UpdateControlManager.h"

@implementation UpdateControlManager

+ (instancetype)sharedUpdate {
    
    static UpdateControlManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[UpdateControlManager alloc] init];
    });
    return __manager;
}


- (id)init {
    if (self = [super init]) {
        self.update = [[VersionUpdateApi alloc]init];
        self.update.delegate = self;
    }
    return self;
}

- (void)updateVersion{
    versionHeader *header = [[versionHeader alloc]init];
    header.target = @"openDControl";
    header.method = @"iosVersionSwitch";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = @"1";
    versionBody *body = [[versionBody alloc]init];
    VersionUpdateRequest *requester = [[VersionUpdateRequest alloc]init];
    requester.head = header;
    requester.body = body;
    [self.update versionUpdate:requester.mj_keyValues.mutableCopy];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    NSLog(@"---%@",responsObject);
    if (api == _update) {
        if ([responsObject[@"isOpen"] isEqualToString:@"Y"]) {
            [self judgeAPPVersion];
        }else{
            NSLog(@"check close!!!!!!!!!!! ");
        }
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    NSLog(@"mmmdddddd%@",command.response.msg);
}

-(void)judgeAPPVersion
{
    NSString *urlStr = @"http://itunes.apple.com/CN/lookup?id=1286632380";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSLog(@"%@",jsonObject);
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    NSLog(@"商店的版本是 %@",version);
    NSArray *arr = [UpdateModel mj_objectArrayWithKeyValuesArray:infoContent];
    UpdateModel *model = [arr lastObject];
    self.model = model;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
    //将版本号按照.切割后存入数组中
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *appArray = [version componentsSeparatedByString:@"."];
    NSInteger minArrayLength = MIN(localArray.count, appArray.count);
    BOOL needUpdate = NO;
    for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
        //取出每个部分的字符串值,比较数值大小
        NSString *localElement = localArray[i];
        NSString *appElement = appArray[i];
        NSInteger  localValue =  localElement.integerValue;
        NSInteger  appValue = appElement.integerValue;
        if(localValue<appValue) {
            //从前往后比较数字大小,一旦分出大小,跳出循环
            needUpdate = YES;
            break;
        }else{
            needUpdate = NO;
        }
        
    }
    if (needUpdate) {
        NSString *title                          = @"版本升级说明";
        NSString *content                     = model.releaseNotes;
        NSString  *buttonTitle                =  @"立即升级";
        UpdateViewMessageObject *messageObject = MakeUpdateViewObject(title,content, buttonTitle,NO);
        [LYZUpdateView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:99];
    }
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 99) {
        NSURL *url = [NSURL URLWithString:self.model.trackViewUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
