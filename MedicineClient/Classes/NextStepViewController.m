//
//  NextStepViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "NextStepViewController.h"
#import "NoteAuthViewController.h"
#import "PhotoPickManager.h"
#import "NoteAuthViewController.h"
#import "FaceStreamDetectorViewController.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "UIImage+compress.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceResultKeys.h"
#import "FaceModel.h"
#import "FaceViewController.h"
#import "Utils.h"
#import "YYImageClipViewController.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import "UIImage+GradientColor.h"
@interface NextStepViewController ()<UIActionSheetDelegate,FaceDetectorDelegate,IFlyFaceRequestDelegate,ApiRequestDelegate,ACActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYImageClipDelegate>

@property (nonatomic,retain) IFlyFaceRequest * iFlySpFaceRequest;

@property (nonatomic,retain) NSString *resultStings;

@property (nonatomic,retain) CALayer *imgToUseCoverLayer;

@property (nonatomic,retain) FaceModel *faceModel;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIView *middleView;

@property (nonatomic,strong)UIView *bottomView;
//证件照
@property (nonatomic,strong)UIImageView *imageSide;

@property (nonatomic,strong)UIImageView *imageOther;

@property (nonatomic,strong)UIButton *faceImage;

//盛放所有的图片数组
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSString *doctorAuthImage;
@property (nonatomic,strong)NSString *workBordImage;
@property (nonatomic,strong)NSString *faceAuthImage;
//
@property (nonatomic,strong)ACActionSheet *actionsheet3;

@property (nonatomic,strong)ACActionSheet *actionsheet2;

@property (nonatomic,strong)ACActionSheet *actionsheet1;

@property (nonatomic,strong)YYImageClipViewController *cliper1;

@property (nonatomic,strong)YYImageClipViewController *cliper2;

@property (nonatomic,strong)YYImageClipViewController *cliper3;

@property (nonatomic,strong)UIImagePickerController *picker1;

@property (nonatomic,strong)UIImagePickerController *picker2;

@property (nonatomic,strong)UIImagePickerController *picker3;

@property (nonatomic,strong)UIImage *cerImage;

@property (nonatomic,strong)UIImage *workImage;

@property (nonatomic,strong)UIImage *facImage;

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSApi *Ossapi1;

@property (nonatomic,strong)OSSApi *Ossapi2;

@property (nonatomic,strong)OSSModel *ossmodel;

@property (nonatomic,strong)NSString *cerImageurl;

@property (nonatomic,strong)NSString *workImageurl;

@property (nonatomic,strong)NSString *facImageurl;

@end

@implementation NextStepViewController

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)setTopView{

    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 110)];
    
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
    
    stepline.backgroundColor = DividerDarkGrayColor;
    
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
    
//    UIView *normalFlag1 = [[UIView alloc]init];
//    
//    normalFlag1.backgroundColor = [UIColor whiteColor];
//    
//    normalFlag1.layer.cornerRadius = 3.5;
//    
//    normalFlag1.layer.masksToBounds = YES;
//    
//    [normalFlag addSubview:normalFlag1];
//    
//    [normalFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.mas_equalTo(normalFlag.mas_centerX);
//        
//        make.width.height.mas_equalTo(7);
//        
//        make.centerY.mas_equalTo(normalFlag.mas_centerY);
//    }];
    
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
    
    
    UIView *authFlag1 = [[UIView alloc]init];
    
    authFlag1.backgroundColor = [UIColor whiteColor];
    
    authFlag1.layer.cornerRadius = 3.5;
    
    authFlag1.layer.masksToBounds = YES;
    
    [authFlag addSubview:authFlag1];
    
    [authFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(authFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(authFlag.mas_centerY);
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
    
    
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    
    [topView addSubview:noteLabel];
    
    noteLabel.textColor = DefaultGrayTextClor;
    
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
        
        make.height.mas_equalTo(225);
        
    }];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.font = Font(14);
    
    label.textColor = DefaultGrayTextClor;
    
    label.text = @"请上传相关证件";
    
    [self.middleView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.font = Font(16);
    desLabel.textColor = DefaultBlackLightTextClor;
    desLabel.text = @"医师资格证--正面部分";
    desLabel.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(label.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
    }];
    
    self.imageSide = [[UIImageView alloc]init];
    
    self.imageSide.userInteractionEnabled = YES;
    
    [self.middleView addSubview:self.imageSide];
    
    [self.imageSide mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(24);
        
        make.top.mas_equalTo(desLabel.mas_bottom).mas_equalTo(10);
        
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
        
        make.height.mas_equalTo(110);
        
    }];
    
    [self.imageSide sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"auth_certi"]];
    self.imageSide.contentMode = UIViewContentModeScaleAspectFill;
    self.imageSide.clipsToBounds = YES;
    [self.imageSide addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCer)]];
    
    UILabel *cer1 = [[UILabel alloc]init];
    
    cer1.font = Font(16);
    
    cer1.textColor = DefaultBlackLightTextClor;
    
    cer1.textAlignment = NSTextAlignmentCenter;

    cer1.text = @"点击图片替换证件样例";
    
    [self.middleView addSubview:cer1];
    
    [cer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageSide.mas_centerX);
        make.top.mas_equalTo(self.imageSide.mas_bottom).mas_equalTo(5);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
    }];
    
    UILabel *desLabel1 = [[UILabel alloc]init];
    desLabel1.font = Font(16);
    desLabel1.textColor = DefaultBlackLightTextClor;
    desLabel1.text = @"工作牌--正面部分";
    desLabel1.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:desLabel1];
    [desLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageSide.mas_right).mas_equalTo(24);
        make.top.mas_equalTo(label.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
    }];
    self.imageOther = [[UIImageView alloc]init];
    
    self.imageOther.userInteractionEnabled = YES;

    [self.middleView addSubview:self.imageOther];
    
    [self.imageOther mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.imageSide.mas_right).mas_equalTo(24);
        
        make.top.mas_equalTo(desLabel1.mas_bottom).mas_equalTo(10);
        
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
        
        make.height.mas_equalTo(110);
        
    }];
    
    [self.imageOther sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"auth_workb"]];
    self.imageOther.contentMode = UIViewContentModeScaleAspectFill;
    self.imageOther.clipsToBounds = YES;
     [self.imageOther addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCer1)]];
    UILabel *cer2 = [[UILabel alloc]init];
    
    cer2.font = Font(16);
    
    cer2.textColor = DefaultBlackLightTextClor;
    
    cer2.textAlignment = NSTextAlignmentCenter;
    
    cer2.text = @"点击图片替换证件样例";
    
    [self.middleView addSubview:cer2];
    
    [cer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageOther.mas_centerX);
        make.top.mas_equalTo(self.imageOther.mas_bottom).mas_equalTo(5);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kScreenWidth - 48- 24)/2);
    }];

    
}


- (void)setbottomView{
    
    self.bottomView = [[UIView alloc]init];
    
    [self.view addSubview:self.bottomView];
    
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.middleView.mas_bottom).mas_equalTo(20);
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(240);
        
    }];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.font = Font(14);
    
    label.textColor = DefaultGrayTextClor;
    
    label.text = @"2.人脸识别认证";
    
    [self.bottomView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
        
    }];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    
    [skipButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    skipButton.titleLabel.font  =Font(16);
    
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:skipButton];
    
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(25);
        
        make.centerY.mas_equalTo(label.mas_centerY);
    }];
    
    self.faceImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceImage setTitle:@"开始人脸认证" forState:UIControlStateNormal];
    [self.faceImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.faceImage setBackgroundImage:bgImg forState:UIControlStateNormal];
    self.faceImage.layer.cornerRadius = 4;
    self.faceImage.layer.masksToBounds= YES;
    [self.faceImage addTarget:self action:@selector(addFaceRecongnise) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.faceImage];
    [self.faceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(label.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(64);
    }];
    
}

- (OSSApi *)Ossapi
{
    if (!_Ossapi) {
        _Ossapi = [[OSSApi alloc]init];
        _Ossapi.delegate  =self;
    }
    return _Ossapi;
}

- (OSSApi *)Ossapi1
{
    if (!_Ossapi1) {
        _Ossapi1 = [[OSSApi alloc]init];
        _Ossapi1.delegate  =self;
    }
    return _Ossapi1;
}


- (OSSApi *)Ossapi2
{
    if (!_Ossapi2) {
        _Ossapi2 = [[OSSApi alloc]init];
        _Ossapi2.delegate  =self;
    }
    return _Ossapi2;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
 
    if (api == _Ossapi) {
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        [OSSImageUploader asyncUploadImages:@[self.facImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [Utils removeHudFromView:self.view];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    self.facImageurl = url;
//                    [self.faceImage sd_setImageWithURL:[NSURL URLWithString:url]];
                }
            });
        }];
    }
    
    if (api == _Ossapi1) {
        OSSModel *model = responsObject;
        [OSSImageUploader asyncUploadImages:@[self.workImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [Utils removeHudFromView:self.view];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    self.workImageurl = url;
                    [self.imageOther sd_setImageWithURL:[NSURL URLWithString:url]];
                }
            });
            
        }];
        
    }
    
    if (api == _Ossapi2) {
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        [OSSImageUploader asyncUploadImages:@[self.cerImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [Utils removeHudFromView:self.view];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    self.cerImageurl = url;
                    [self.imageSide sd_setImageWithURL:[NSURL URLWithString:self.cerImageurl]];
                }
            });
            
        }];
    }
    
}

- (void)addCer{

    self.actionsheet3 = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }else{
                self.picker3 = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    self.picker3 = [[UIImagePickerController alloc] init];
                    self.picker3.delegate = self;
                    self.picker3.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker3.allowsEditing = YES;
                    self.picker3.showsCameraControls = YES;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker3.mediaTypes = mediaTypes;
                    self.picker3.delegate = self;
                    [self presentViewController: self.picker3
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertV show];
                }
            }
            
        }else if(buttonIndex == 1){
            
            ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"权限设置" message:@"请您在手机设置里面打开相机读取和写入权限" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }
                }];
                [alert show];
                
            }else{
                // 从相册中选取
                if ([self isPhotoLibraryAvailable]) {
                    self.picker3 = [[UIImagePickerController alloc] init];
                    self.picker3.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker3.mediaTypes = mediaTypes;
                    self.picker3.delegate = self;
                    [self presentViewController:self.picker3
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }
            }
        }
    }];
    
    self.actionsheet3.delegate = self;
    
    [self.actionsheet3 show];
    
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == self.picker3) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.cliper3 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        self.cliper3.delegate = self;
        [picker pushViewController:self.cliper3 animated:NO];
    }
    
    if (picker == self.picker2) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.cliper2 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        self.cliper2.delegate = self;
        [picker pushViewController:self.cliper2 animated:NO];
    }
//
//    if (picker == self.picker1) {
//        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        self.cliper1 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
//        self.cliper1.delegate = self;
//        [picker pushViewController:self.cliper1 animated:NO];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (cropperViewController == self.cliper3) {
        self.cerImage = editedImage;
        if (!self.cerImage) {
            [Utils postMessage:@"请上传医师资格证" onView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在上传...";
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
        
        [self.Ossapi2 getoss:requester.mj_keyValues.mutableCopy];
        
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (cropperViewController == self.cliper2) {
        self.workImage = editedImage;
        if (!self.workImage) {
            [Utils postMessage:@"请上传工作牌证件图" onView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在上传...";
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
        
        [self.Ossapi1 getoss:requester.mj_keyValues.mutableCopy];
        
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
 
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark - camera utility
- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)addCer1{
    
    self.actionsheet2 = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }else{
                self.picker2 = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    self.picker2 = [[UIImagePickerController alloc] init];
                    self.picker2.delegate = self;
                    self.picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker2.allowsEditing = YES;
                    self.picker2.showsCameraControls = YES;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker2.mediaTypes = mediaTypes;
                    self.picker2.delegate = self;
                    [self presentViewController: self.picker2
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertV show];
                }
            }
            
        }else if(buttonIndex == 1){
            
            ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"权限设置" message:@"请您在手机设置里面打开相机读取和写入权限" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }
                }];
                [alert show];
                
            }else{
                // 从相册中选取
                if ([self isPhotoLibraryAvailable]) {
                    self.picker2 = [[UIImagePickerController alloc] init];
                    self.picker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker2.mediaTypes = mediaTypes;
                    self.picker2.delegate = self;
                    [self presentViewController:self.picker2
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }
            }
        }
    }];
    
    self.actionsheet2.delegate = self;
    
    [self.actionsheet2 show];

}


- (void)addFaceRecongnise{

    FaceViewController *face = [[FaceViewController alloc]init];
    
    face.title = @"人脸识别";
    
    [self.navigationController pushViewController:face animated:YES];
    
    
//    FaceStreamDetectorViewController *face = [[FaceStreamDetectorViewController alloc]init];
//    
//    face.title = @"脸部识别";
//    
//    face.faceDelegate = self;
//
//    [self.navigationController pushViewController:face animated:YES];
    
}


-(void)sendFaceImage:(UIImage *)faceImage
{
    self.facImage = faceImage;
 
    if (!self.facImage) {
        [Utils postMessage:@"请选择头像进行人脸注册" onView:self.view];
        return;
    }
    //请求签名
    [Utils addHudOnView:self.view];

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
    //验证人脸识别
    
    [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_VERIFY] forKey:[IFlySpeechConstant FACE_SST]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:@"auth_id"];
   
    NSString* gid=[User LocalUser].gid;
    
    if(!gid){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"结果" message:@"请先注册，或在设置中输入已注册的gid" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
     
        return;
    }
    
    [self.iFlySpFaceRequest setParameter:gid forKey:[User LocalUser].gid];
    [self.iFlySpFaceRequest setParameter:@"2000" forKey:@"wait_time"];

    //  压缩图片大小
    NSData* imgData=[faceImage compressedData];
    NSLog(@"verify image data length: %lu",(unsigned long)[imgData length]);
    [self.iFlySpFaceRequest sendRequest:imgData];
    
}


//

- (void)skipAction{
    
    if ([User LocalUser].certification.length <= 0) {
        [Utils postMessage:@"请上传医生资格证" onView:self.view];
        return;
    }
    if ([User LocalUser].workcard.length <= 0) {
        [Utils postMessage:@"请上传医生执业工作牌" onView:self.view];
        return;
    }
    NoteAuthViewController *note = [NoteAuthViewController new];
    note.token = self.token;
    note.name = self.name;
    note.sex = self.sex;
    note.email = self.email;
    note.hosId = self.hosId;
    note.keshiId = self.keshiId;
    note.jopId = self.jopId;
    note.addHos = self.addHos;
    note.addKeshi = self.addKeshi;
    note.workImageurl = self.workImageurl;
    note.facImageurl = self.facImageurl;
    note.cerImageurl = self.cerImageurl;
    note.title  =@"认证";
    [self.navigationController pushViewController:note animated:YES];
}

//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [_imgToUseCoverLayer removeFromSuperlayer];
//    if (actionSheet == self.actionsheet1) {
//        PhotoPickManager *pickManager = [PhotoPickManager shareInstance];
//        [pickManager presentPicker:buttonIndex
//                            target:self
//                     callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
//                         NSLog(@"%@",[infoDict valueForKey:UIImagePickerControllerOriginalImage]);
//                         UIImage *image = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
//                         if (!image) {
//                             return ;
//                         }else{
//                             [Utils addHudOnView:self.view];
//                             [Utils uploadImgs:@[image] withResult:^(id imgs, NSInteger status) {
//                                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                         [Utils removeHudFromView:self.view];
//                                     });
//                                 });
//                                 NSArray *images = imgs;
//                                 self.doctorAuthImage = [images firstObject];
//                                 [self.imageSide sd_setImageWithURL:[NSURL URLWithString:self.doctorAuthImage] placeholderImage:[UIImage imageNamed:@"placehoder"]];
//                             }];
//                         }
//                     }];
//
//    }else{
//
//        PhotoPickManager *pickManager1 = [PhotoPickManager shareInstance];
//        [pickManager1 presentPicker:buttonIndex
//                            target:self
//                     callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
//
//                         NSLog(@"%@",[infoDict valueForKey:UIImagePickerControllerOriginalImage]);
//                         UIImage *image = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
//                         if (!image) {
//                             return ;
//                         }else{
//                             [Utils addHudOnView:self.view];
//                             [Utils uploadImgs:@[image] withResult:^(id imgs, NSInteger status) {
//                                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                         [Utils removeHudFromView:self.view];
//                                     });
//                                 });
//                                 NSArray *images = imgs;
//                                 self.workBordImage = [images firstObject];
//                                 [self.imageOther sd_setImageWithURL:[NSURL URLWithString:self.workBordImage] placeholderImage:[UIImage imageNamed:@"placehoder"]];
//                             }];
//
//                         }
//
//                     }];
//
//    }
//
//
//}


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
    
    
//    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//    NSLog(@"字典：%@",resultDictionary);
//    
//    if ([resultDictionary[@"rst"] isEqualToString:@"success"]) {
//        
//        [User LocalUser].gid = resultDictionary[@"gid"];
//        
//        [User saveToDisk];
//        
//        [Utils postMessage:@"人脸注册成功" onView:self.view];
//    
//    }else{
//    
//        [Utils postMessage:@"人脸注册失败！" onView:self.view];
//
//    }
    
    
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
        
        //关键点
        if([strSessionType isEqualToString:KCIFlyFaceResultAlign]){
            [self praseAlignResult:result];
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
                }else{
                    resultInfo=[resultInfo stringByAppendingString:[rst isEqualToString:KCIFlyFaceResultSuccess]?@"检测到人脸轮廓":@"未检测到人脸轮廓"];
                    
                    [Utils postMessage:resultInfo onView:self.view];
                    
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
                    if(self.imageOther.image.size.width/self.imageOther.image.size.height > self.imageOther.frame.size.width/self.imageOther.frame.size.height){
                        image_width = self.imageOther.frame.size.width;
                        image_height = image_width/self.imageOther.image.size.width * self.imageOther.image.size.height;
                        image_x = 0;
                        image_y = (self.imageOther.frame.size.height - image_height)/2;
                        
                    }else if(self.imageOther.image.size.width/self.imageOther.image.size.height < self.imageOther.frame.size.width/self.imageOther.frame.size.height)
                    {
                        image_height = self.imageOther.frame.size.height;
                        image_width = image_height/self.imageOther.image.size.height * self.imageOther.image.size.width;
                        image_y = 0;
                        image_x = (self.imageOther.frame.size.width - image_width)/2;
                        
                    }else{
                        image_x = 0;
                        image_y = 0;
                        image_width = self.imageOther.frame.size.width;
                        image_height = self.imageOther.frame.size.height;
                    }
                    
                    CGFloat resize_scale = image_width/self.imageOther.image.size.width;
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
                
                
                [self.imageOther.layer addSublayer:_imgToUseCoverLayer];
            }
            
        
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
                    
                    [Utils postMessage:@"人脸注册失败！" onView:self.view];
  
                }else{
                    
                    if(rst && [rst isEqualToString:KCIFlyFaceResultSuccess]){
                        NSString* gid=[dic objectForKey:KCIFlyFaceResultGID];
                        [Utils postMessage:resultInfo onView:self.view];

                        [User LocalUser].gid = gid;
                        
                        [User saveToDisk];
                        
                        [Utils postMessage:@"人脸注册成功" onView:self.view];

                        //2然后人脸关键点检测
                        [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_DETECT] forKey:[IFlySpeechConstant FACE_SST]];
                        [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
                        //  压缩图片大小
                        NSData* imgData=[self.imageOther.image compressedData];
                        NSLog(@"detect image data length: %lu",(unsigned long)[imgData length]);
                        [self.iFlySpFaceRequest sendRequest:imgData];
                    }else{
                        
                        [Utils postMessage:resultInfo onView:self.view];
                        
                    }
                }
            }
        
//            [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:resultInfo waitUntilDone:NO];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
    
    
}


//关键点监测

-(void)praseAlignResult:(NSString*)result{
    NSString *resultInfo = @"";
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            //关键点
            if([strSessionType isEqualToString:KCIFlyFaceResultAlign]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                if([ret integerValue]!=0){
                    resultInfo=[resultInfo stringByAppendingFormat:@"检测关键点错误\n错误码：%@",ret];
                    
                    [Utils postMessage:resultInfo onView:self.view];
                    
                    
                }else{
                    resultInfo=[resultInfo stringByAppendingString:[rst isEqualToString:@"success"]?@"检测到人脸关键点":@"未检测到人脸关键点"];
                    
                    [Utils postMessage:resultInfo onView:self.view];
                    
                }
           
                _imgToUseCoverLayer = [[CALayer alloc] init];
                
                float image_x, image_y, image_width, image_height;
                if(self.imageOther.image.size.width/self.imageOther.image.size.height > self.imageOther.frame.size.width/self.imageOther.frame.size.height){
                    image_width = self.imageOther.frame.size.width;
                    image_height = image_width/self.imageOther.image.size.width * self.imageOther.image.size.height;
                    image_x = 0;
                    image_y = (self.imageOther.frame.size.height - image_height)/2;
                    
                }else if(self.imageOther.image.size.width/self.imageOther.image.size.height < self.imageOther.frame.size.width/self.imageOther.frame.size.height)
                {
                    image_height = self.imageOther.frame.size.height;
                    image_width = image_height/self.imageOther.image.size.height * self.imageOther.image.size.width;
                    image_y = 0;
                    image_x = (self.imageOther.frame.size.width - image_width)/2;
                    
                }else{
                    image_x = 0;
                    image_y = 0;
                    image_width = self.imageOther.frame.size.width;
                    image_height = self.imageOther.frame.size.height;
                }
                
                CGFloat resize_scale = image_width/self.imageOther.image.size.width;
                
                NSArray* resultArray=[dic objectForKey:KCIFlyFaceResultResult];
                for (id anRst in resultArray) {
                    if(anRst && [anRst isKindOfClass:[NSDictionary class]]){
                        NSDictionary* landMarkDic=[anRst objectForKey:KCIFlyFaceResultLandmark];
                        NSEnumerator* keys=[landMarkDic keyEnumerator];
                        for(id key in keys){
                            id attr=[landMarkDic objectForKey:key];
                            if(attr && [attr isKindOfClass:[NSDictionary class]]){
                                id attr=[landMarkDic objectForKey:key];
                                CGFloat x=[[attr objectForKey:KCIFlyFaceResultPointX] floatValue];
                                CGFloat y=[[attr objectForKey:KCIFlyFaceResultPointY] floatValue];
                                
                                CALayer* layer= [[CALayer alloc] init];
                                NSLog(@"resize_scale:%f",resize_scale);
                                CGFloat radius=5.0f*resize_scale;
                                //关键点大小限制
                                if(radius>10){
                                    radius=10;
                                }
                                [layer setCornerRadius:radius];
                                CGRect innerRect = CGRectMake( resize_scale*x+image_x-radius/2, resize_scale*y+image_y-radius/2, radius, radius);
                                [layer setFrame:innerRect];
                                layer.backgroundColor = [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor];
                                
                                [_imgToUseCoverLayer addSublayer:layer];
                                
                                
                            }
                        }
                    }
                }
                
                [self.imageOther.layer addSublayer:_imgToUseCoverLayer];
                
            }
            
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

#pragma mark - UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
   
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setMiddleView];
    
//    [self setbottomView];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];

    [self setRightNavigationItemWithTitle:@"下一步" action:@selector(NextStep)];
    
//    self.imageSide.contentMode = UIViewContentModeScaleAspectFit;
//
//    self.imageOther.contentMode = UIViewContentModeScaleAspectFit;

    self.faceImage.contentMode = UIViewContentModeScaleAspectFit;

    // Do any additional setup after loading the view from its nib.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)NextStep{
    
    if (self.cerImageurl.length <= 0) {
        [Utils postMessage:@"请上传医生资格证" onView:self.view];
        return;
    }
    if (self.workImageurl.length <= 0) {
        [Utils postMessage:@"请上传医生执业工作牌" onView:self.view];
        return;
    }
    NoteAuthViewController *next = [NoteAuthViewController new];
    
    next.token = self.token;

    next.name = self.name;
    
    next.sex = self.sex;

    next.email = self.email;

    next.hosId = self.hosId;

    next.keshiId = self.keshiId;

    next.jopId = self.jopId;
    next.addHos = self.addHos;
    next.addKeshi = self.addKeshi;
    next.workImageurl = self.workImageurl;
    next.facImageurl = self.facImageurl;
    next.cerImageurl = self.cerImageurl;
    next.title = @"认证";
    [self.navigationController pushViewController:next animated:YES];
    
}



@end
