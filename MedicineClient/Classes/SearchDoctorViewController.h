//
//  SearchDoctorViewController.h
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureCount)();

@interface SearchDoctorViewController : UIViewController
@property (nonatomic,strong,readwrite)NSString *count;
@property (nonatomic,strong,readwrite)NSArray *preArray;
@property (nonatomic,strong,readwrite)NSString *huizhenid;
@property (nonatomic,strong,readwrite)NSArray *passArray;

@property (nonatomic,strong)sureCount sure;

@property (nonatomic,assign)BOOL isModify;

@end
