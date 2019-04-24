//
//  UpdateProfileViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^getFillHospital)(NSString *hospital);
typedef void (^getFillKeshi)(NSString *Keshi);
@class MyProfilwModel;

@interface UpdateProfileViewController : UIViewController
@property (nonatomic,strong)getFillHospital hospitalName;
@property (nonatomic,strong)getFillKeshi keshiName;
@property (nonatomic,strong)MyProfilwModel *model;


@end
