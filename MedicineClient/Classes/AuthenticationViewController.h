//
//  AuthenticationViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^getFillHospital)(NSString *hospital);
typedef void (^getFillKeshi)(NSString *Keshi);
@interface AuthenticationViewController : UIViewController
@property (nonatomic,strong)getFillHospital hospitalName;
@property (nonatomic,strong)getFillKeshi keshiName;
//添加控制器参数 1.从登录进入，0从其他页面进入
@property (nonatomic,assign)BOOL loginEnter;

@end
