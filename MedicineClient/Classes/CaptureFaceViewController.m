//
//  CaptureFaceViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/9/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaptureFaceViewController.h"
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#import "DetectorViewT.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "UIImage+compress.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceResultKeys.h"
#import "NextStepViewController.h"
#import "LSProgressHUD.h"
@interface CaptureFaceViewController ()<IFlyFaceRequestDelegate>
{
    NSTimer *timer;
    NSInteger timeCount;
    
}
@property(nonatomic,strong)DetectorViewT *detector;
@property(nonatomic,strong)UIImageView *frontImageView;
@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,retain) IFlyFaceRequest * iFlySpFaceRequest;

@property (nonatomic,retain) NSString *resultStings;

@property (nonatomic,retain) CALayer *imgToUseCoverLayer;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation CaptureFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@""] highligthtedImage:[UIImage imageNamed:@""] action:nil];
    
    self.iFlySpFaceRequest=[IFlyFaceRequest sharedInstance];
    [self.iFlySpFaceRequest setDelegate:self];
    // Do any additional setup after loading the view.
    DetectorViewT *detector = [[DetectorViewT alloc] initWithFrame:CGRectMake(10,0, kScreenWidth - 20, kScreenHeight- 64-49-10)];
    [self.view addSubview:detector];
    self.detector = detector;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(detector.frame) + 10,kScreenWidth- 20,40);
    [cancelBtn setTitle:@"重新捕捉人脸" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 100, 120)];
    
    showImageView.layer.borderWidth = 1.0f;
    showImageView.contentMode = UIViewContentModeScaleAspectFit;
    showImageView.layer.borderColor = AppStyleColor.CGColor;
    
    [self.detector addSubview:showImageView];
    showImageView.clipsToBounds = YES;
    self.showImageView = showImageView;
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    timeLabel.font = Font(16);
    
    timeLabel.textColor = AppStyleColor;
    [self.detector addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
        
    }];
    
    //    self.interfaceOrientation;
    //    self.detector.interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    __weak typeof(self) weakSelf = self;
    
    self.detector.getStringBlock = ^(NSDictionary *resultDict){
        
        if ([[resultDict objectForKey:@"result"] boolValue]) {
            
            [weakSelf timeBegin];
        }
        else{
            
            [weakSelf releaseTimer];
        }
//        tipLabel.text = resultDict[@"desc"];
    };
    
    
}
#pragma mark - 强制改屏幕
- (void)timeBegin{
    if (timer) {
        return;
    }
    timeCount = 3;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCalculate:) userInfo:nil repeats:YES];
    
    self.timeLabel.text = [NSString stringWithFormat:@"静静地看着屏幕%ld s后拍照...", (long)timeCount];
}
- (void)releaseTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
        self.timeLabel.text = @"";
    }
}
- (void)timeCalculate:(NSTimer *)theTimer{
    timeCount --;
    if(timeCount >= 1)
    {
        self.timeLabel.text = [NSString  stringWithFormat:@"静静地看着屏幕%ld s后拍照...",(long)timeCount];
    }
    else
    {
        [theTimer invalidate];
        theTimer=nil;
        if (self.detector.takePhotoBlock) {
            self.detector.takePhotoBlock();
        }
        
        weakify(self);
        
        self.detector.getImageBlock = ^(UIImage *image){
            
            strongify(self);
            
            self.showImageView.image = image;
          
            double delayInSeconds = 1;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                
//                if(!gid){
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"结果" message:@"请先注册，或在设置中输入已注册的gid" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                    
//                    return;
//                }
                NSString* gid=[User LocalUser].gid;

                NSLog(@"8888888888------%@",gid);
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_VERIFY] forKey:[IFlySpeechConstant FACE_SST]];
                [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
                [self.iFlySpFaceRequest setParameter:USER_APPID forKey:@"auth_id"];
            
                [self.iFlySpFaceRequest setParameter:gid forKey:[IFlySpeechConstant FACE_GID]];
                [self.iFlySpFaceRequest setParameter:@"2000" forKey:@"wait_time"];
                
                //  压缩图片大小
                UIImage* images = [[image fixOrientation] compressedImage];//将图片压缩以上传服务器
                NSData* imgData = [images compressedData];
                NSLog(@"reg image data length: %lu",(unsigned long)[imgData length]);
                [self.iFlySpFaceRequest sendRequest:imgData];
                
            });
            
            NSLog(@"---======-----%@",image);
         
        };
        
    }
}
- (void)cancelPhoto{
    if (self.detector.cancelPhotoBlock) {
        self.detector.cancelPhotoBlock();
    }else{
        NSLog(@"22");
    }
    
    self.showImageView.image = nil;
}

- (void) onEvent:(int) eventType WithBundle:(NSString*) params{
    NSLog(@"onEvent | params:%@",params);
}

/**
 * 数据回调，可能调用多次，也可能一次不调用
 * @param buffer 服务端返回的二进制数据
 */
- (void) onData:(NSData* )data{
    
    NSLog(@"onData | ");
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"result:%@",result);
    
    if (result) {
        
        self.resultStings = result;
        
    }
    
}

/**
 * 结束回调，没有错误时，error为null
 * @param error 错误类型
 */
- (void) onCompleted:(IFlySpeechError*) error{
    
    NSLog(@"onCompleted | error:%@",[error errorDesc]);
    NSString* errorInfo=[NSString stringWithFormat:@"错误码：%d\n 错误描述：%@",[error errorCode],[error errorDesc]];
    
    NSLog(@"错误信息%@",errorInfo);
    
    if(0!=[error errorCode]){
        //        [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:errorInfo waitUntilDone:NO];
    }
    else{
     
        NSError* error;
        NSData* resultData=[self.resultStings dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"9090909090%@",dic);
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
          
            //验证
            if([strSessionType isEqualToString:KCIFlyFaceResultVerify]){
                [self praseVerifyResult:self.resultStings];
            }
            
        }

    }
    
}


-(void)praseVerifyResult:(NSString*)result{
    NSString *resultInfo = @"";
    NSString *resultInfoForLabel = @"";
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            if([strSessionType isEqualToString:KCIFlyFaceResultVerify]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                if([ret integerValue]!=0){
                    resultInfo=[resultInfo stringByAppendingFormat:@"验证错误\n错误码：%@",ret];
                    
                    [self.hud hide:YES];

                    
                }else{
                    
                    if([rst isEqualToString:KCIFlyFaceResultSuccess]){
                        resultInfo=[resultInfo stringByAppendingString:@"检测到人脸\n"];
                        
                        [self.hud hide:YES];

                    }else{
                        resultInfo=[resultInfo stringByAppendingString:@"未检测到人脸\n"];
                        
                        [self.hud hide:YES];

                    }
                    NSString* verf=[dic objectForKey:KCIFlyFaceResultVerf];
                    NSString* score=[dic objectForKey:KCIFlyFaceResultScore];
                    if([verf boolValue]){
                        
                        [self.hud hide:YES];

                        resultInfo=[resultInfo stringByAppendingString:@"验证结果:验证成功!"];
                        resultInfo=[resultInfo stringByAppendingFormat:@"验证结果:验证成功!\n %@",score];
                    
                        double delayInSeconds = 2;
                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, mainQueue, ^{
                            
                            for (UIViewController *temp in self.navigationController.viewControllers)
                            {
                                if ([temp isKindOfClass:[NextStepViewController class]])
                                {
                                    
                                    [User LocalUser].img = self.showImageView.image;
                                    
                                    [User saveToDisk];
                                    
                                    NSLog(@"---------%@",[User LocalUser].img);
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFace" object:nil];
                                    
                                    [self.navigationController popToViewController:temp animated:YES];
                                 
                                }
                            }
                        
                            
                        });

                        
                    }else{
                        
                        [self.hud hide:YES];

                        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
                        NSString* gid=[defaults objectForKey:KCIFlyFaceResultGID];
                        resultInfoForLabel=[resultInfoForLabel stringByAppendingFormat:@"last reg gid:%@\n",gid];
                        resultInfo=[resultInfo stringByAppendingString:@"验证结果:验证失败!"];
                        
                        
                    }
                }
                
            }
            
            
            if([resultInfo length]<1){
                resultInfo=@"结果异常";
            }
            
            [self.hud hide:YES];

            [Utils postMessage:resultInfo onView:self.view];
        
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
        
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
