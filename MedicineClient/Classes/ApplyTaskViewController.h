//
//  ApplyTaskViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
@interface ApplyTaskViewController : UIViewController

//获取oss签名

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSModel *model;

@property (nonatomic,strong)NSString *nameString;

@property (nonatomic,strong)NSString *ageString;

@property (nonatomic,strong)NSString *sexal;

@property (nonatomic,strong)NSString *phoneString;

@property (nonatomic,strong)NSArray *imageArr;

@property (nonatomic,strong)NSString *des;

@property (nonatomic,strong)NSString *taskid;

@property (nonatomic,assign)BOOL isFill;

@end
