//
//  FaceViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/9/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FaceViewController.h"
#import "PhotoPickManager.h"
#import "CaptureFaceViewController.h"
#import "LSProgressHUD.h"
@interface FaceViewController ()<UIActionSheetDelegate,IFlyFaceRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *faceImage;

@property (weak, nonatomic) IBOutlet UIButton *upLoad;

@property (nonatomic,strong)UIActionSheet *actionsheet1;

@property (nonatomic,retain) IFlyFaceRequest * iFlySpFaceRequest;

@property (nonatomic,retain) NSString *resultStings;

@property (nonatomic,retain) CALayer *imgToUseCoverLayer;

@property (nonatomic,strong)UIImage *images;

@property (nonatomic,strong)MBProgressHUD *hud;


@end

@implementation FaceViewController


- (IBAction)upLoad:(id)sender {
    
    self.actionsheet1 = [[UIActionSheet alloc] initWithTitle:@"工作牌或医师资格证" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [self.actionsheet1 showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [_imgToUseCoverLayer removeFromSuperlayer];
    
    if (actionSheet == self.actionsheet1) {
        PhotoPickManager *pickManager = [PhotoPickManager shareInstance];
        [pickManager presentPicker:buttonIndex
                            target:self
                     callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
                         
                         NSLog(@"%@",[infoDict valueForKey:UIImagePickerControllerOriginalImage]);
                         
                         UIImage *image = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
                         
                         UIImage* images = [[image fixOrientation] compressedImage];//将图片压缩以上传服务器
                         NSData* imgData = [images compressedData];
                         
                         self.faceImage.image = images;
                         
                         self.images = image;
                         
                         
                         self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                         
                         self.iFlySpFaceRequest=[IFlyFaceRequest sharedInstance];
                         [self.iFlySpFaceRequest setDelegate:self];
                         //人脸识别注册
                         
                                                  [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_REG] forKey:[IFlySpeechConstant FACE_SST]];
                                                  [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
                                                  [self.iFlySpFaceRequest setParameter:USER_APPID forKey:@"auth_id"];
                                                  [self.iFlySpFaceRequest setParameter:@"del" forKey:@"property"];
                                                  //  压缩图片大小
                      

                         NSLog(@"detect image data length: %lu",(unsigned long)[imgData length]);
                                                  [self.iFlySpFaceRequest sendRequest:imgData];
                         
                     }];
        
    }else{
        
        
    }
    
    
}

#pragma mark - IFlyFaceRequestDelegate


/**
 * 消息回调
 * @param eventType 消息类型
 * @param params 消息数据对象
 */
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateFaceImage:self.resultStings];
        });
    }
    
}

-(void)updateFaceImage:(NSString*)result{
    
    NSError* error;
    NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"9090909090%@",dic);
    
    
    if(dic){
        NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
        
        //注册
        if([strSessionType isEqualToString:KCIFlyFaceResultReg]){
            [self praseRegResult:result];
        }
        
        //验证
        if([strSessionType isEqualToString:KCIFlyFaceResultVerify]){
            [self praseVerifyResult:result];
        }
        
        //检测
        if([strSessionType isEqualToString:KCIFlyFaceResultDetect]){
            [self praseDetectResult:result];
        }
        
        
    }
}


-(void)praseDetectResult:(NSString*)result{
    NSString *resultInfo = @"";
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            //检测
            if([strSessionType isEqualToString:KCIFlyFaceResultDetect]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                if([ret integerValue]!=0){
                    resultInfo=[resultInfo stringByAppendingFormat:@"检测人脸错误\n错误码：%@",ret];
                    
                    [Utils postMessage:resultInfo onView:self.view];
                    
                }else{
                    
                    resultInfo=[resultInfo stringByAppendingString:[rst isEqualToString:KCIFlyFaceResultSuccess]?@"检测到人脸轮廓":@"未检测到人脸轮廓"];
                    
                    [Utils postMessage:resultInfo onView:self.view];

//                    self.resultStings = @"";
                    
                        if ([resultInfo isEqualToString:@"检测到人脸轮廓"]) {
                            
                            [Utils postMessage:@"检测人脸通过" onView:self.view];

                            double delayInSeconds = 4;
                            dispatch_queue_t mainQueue = dispatch_get_main_queue();
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, mainQueue, ^{
                            CaptureFaceViewController *capture = [[CaptureFaceViewController alloc]init];
                            
                            capture.title = @"动态捕捉人脸";
                            
                            [self.navigationController pushViewController:capture animated:YES];
                            
                            });
                            
                        }else{
                            
                            [Utils postMessage:@"检测人脸失败" onView:self.view];

                        }

                }
                
                //绘图
                if(_imgToUseCoverLayer){
                    _imgToUseCoverLayer.sublayers=nil;
                    [_imgToUseCoverLayer removeFromSuperlayer];
                    _imgToUseCoverLayer=nil;
                }
                _imgToUseCoverLayer = [[CALayer alloc] init];
                
                
                NSArray* faceArray=[dic objectForKey:KCIFlyFaceResultFace];
                
                for(id faceInArr in faceArray){
                    
                    CALayer* layer= [[CALayer alloc] init];
                    layer.borderWidth = 2.0f;
                    [layer setCornerRadius:2.0f];
                    
                    float image_x, image_y, image_width, image_height;
                    if(self.faceImage.image.size.width/self.faceImage.image.size.height > self.faceImage.frame.size.width/self.faceImage.frame.size.height){
                        image_width = self.faceImage.frame.size.width;
                        image_height = image_width/self.faceImage.image.size.width * self.faceImage.image.size.height;
                        image_x = 0;
                        image_y = (self.faceImage.frame.size.height - image_height)/2;
                        
                    }else if(self.faceImage.image.size.width/self.faceImage.image.size.height < self.faceImage.frame.size.width/self.faceImage.frame.size.height)
                    {
                        image_height = self.faceImage.frame.size.height;
                        image_width = image_height/self.faceImage.image.size.height * self.faceImage.image.size.width;
                        image_y = 0;
                        image_x = (self.faceImage.frame.size.width - image_width)/2;
                        
                    }else{
                        image_x = 0;
                        image_y = 0;
                        image_width = self.faceImage.frame.size.width;
                        image_height = self.faceImage.frame.size.height;
                    }
                    
                    CGFloat resize_scale = image_width/self.faceImage.image.size.width;
                    //
                    if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                        
                        id posDic=[faceInArr objectForKey:KCIFlyFaceResultPosition];
                        if([posDic isKindOfClass:[NSDictionary class]]){
                            CGFloat bottom =[[posDic objectForKey:KCIFlyFaceResultBottom] floatValue];
                            CGFloat top=[[posDic objectForKey:KCIFlyFaceResultTop] floatValue];
                            CGFloat left=[[posDic objectForKey:KCIFlyFaceResultLeft] floatValue];
                            CGFloat right=[[posDic objectForKey:KCIFlyFaceResultRight] floatValue];
                            
                            float x = left;
                            float y = top;
                            float width = right- left;
                            float height = bottom- top;
                            
                            CGRect innerRect = CGRectMake( resize_scale*x+image_x, resize_scale*y+image_y, resize_scale*width, resize_scale*height);
                            
                            [layer setFrame:innerRect];
                            layer.borderColor = AppStyleColor.CGColor;
                            
                        }
                        
                        id attrDic=[faceInArr objectForKey:KCIFlyFaceResultAttribute];
                        if([attrDic isKindOfClass:[NSDictionary class]]){
                            id poseDic=[attrDic objectForKey:KCIFlyFaceResultPose];
                            id pit=[poseDic objectForKey:KCIFlyFaceResultPitch];
                            
                            CATextLayer *label = [[CATextLayer alloc] init];
                            [label setFontSize:14];
                            [label setString:[@"" stringByAppendingFormat:@"%@", pit]];
                            [label setAlignmentMode:kCAAlignmentCenter];
                            [label setForegroundColor:layer.borderColor];
                            [label setFrame:CGRectMake(0, layer.frame.size.height, layer.frame.size.width, 25)];
                            
                            [layer addSublayer:label];
                        }
                    }
                    [_imgToUseCoverLayer addSublayer:layer];
                    
                }
                
                
                [self.faceImage.layer addSublayer:_imgToUseCoverLayer];
            }
            
            [Utils postMessage:resultInfo onView:self.view];
            
            //            [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:resultInfo waitUntilDone:NO];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
    
}



-(void)praseRegResult:(NSString*)result{
    NSString *resultInfo = @"";
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            //注册
            if([strSessionType isEqualToString:KCIFlyFaceResultReg]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                if([ret integerValue]!=0){
                    
                    [self.hud hide:YES];

                    [Utils postMessage:@"人脸注册失败！" onView:self.view];
                    
                }else{
                    
                    if(rst && [rst isEqualToString:KCIFlyFaceResultSuccess]){
                        NSString* gid=[dic objectForKey:KCIFlyFaceResultGID];
                        [Utils postMessage:resultInfo onView:self.view];
                        
                        [User LocalUser].gid = gid;
                        
                        [User saveToDisk];
                        
                        [self.hud hide:YES];

                        [Utils postMessage:@"人脸注册成功" onView:self.view];
                        
                        //2然后人脸关键点检测
                        [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_DETECT] forKey:[IFlySpeechConstant FACE_SST]];
                        [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
                        //  压缩图片大小
                        UIImage* images = [[self.images fixOrientation] compressedImage];//将图片压缩以上传服务器
                        NSData* imgData = [images compressedData];
                     
                        NSLog(@"detect image data length: %lu",(unsigned long)[imgData length]);
                        [self.iFlySpFaceRequest sendRequest:imgData];
                    }else{
                        
                        [Utils postMessage:resultInfo onView:self.view];
                        
                    }
                }
            }
            
            [Utils postMessage:resultInfo onView:self.view];
            
            //            [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:resultInfo waitUntilDone:NO];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
    
    
}


//验证

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
                }else{
                    
                    if([rst isEqualToString:KCIFlyFaceResultSuccess]){
                        resultInfo=[resultInfo stringByAppendingString:@"检测到人脸\n"];
                    }else{
                        resultInfo=[resultInfo stringByAppendingString:@"未检测到人脸\n"];
                    }
                    NSString* verf=[dic objectForKey:KCIFlyFaceResultVerf];
                    NSString* score=[dic objectForKey:KCIFlyFaceResultScore];
                    if([verf boolValue]){
                        resultInfo=[resultInfo stringByAppendingString:@"验证结果:验证成功!"];
                        resultInfo=[resultInfo stringByAppendingFormat:@"验证结果:验证成功!\n %@",score];
                        
                    }else{
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
            
            [Utils postMessage:resultInfo onView:self.view];
            
            //            [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:resultInfo waitUntilDone:NO];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
        
    }
    
    
}



//-(void)showResultInfo:(NSString*)resultInfo{
//   
//    [Utils postMessage:resultInfo onView:self.view];
//    
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceImage.contentMode = UIViewContentModeScaleAspectFit;

//    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@""] highligthtedImage:[UIImage imageNamed:@""] action:nil];
    // Do any additional setup after loading the view from its nib.
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
