//
//  NoteAuthViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteAuthViewController : UIViewController
//添加控制器参数 1.从登录进入，0从其他页面进入
@property (nonatomic,assign)BOOL loginEnter;

@property (nonatomic,strong)NSString *token;


@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *email;

@property (nonatomic,strong)NSString *hosId;

@property (nonatomic,strong)NSString *keshiId;

@property (nonatomic,strong)NSString *jopId;

@property (nonatomic,strong)NSString *addHos;

@property (nonatomic,strong)NSString *addKeshi;

@property (nonatomic,strong)NSString *workImageurl;

@property (nonatomic,strong)NSString *facImageurl;

@property (nonatomic,strong)NSString *cerImageurl;

@end
