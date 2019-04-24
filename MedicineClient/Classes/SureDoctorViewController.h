//
//  SureDoctorViewController.h
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HuizhenCommitModel;
@interface SureDoctorViewController : UIViewController
@property (nonatomic,strong)HuizhenCommitModel *model;
@property (nonatomic,strong)NSString *yuyueid;
@property (nonatomic,strong)NSString *huizhenid;
@property (nonatomic,strong)NSString *huizhenidNokf;
//
@property (nonatomic,assign)BOOL isModify;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *zhengzhuang;
@property (nonatomic,strong)NSString *blimages;
@property (nonatomic,strong)NSString *topic;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *huizhentime;

@end
