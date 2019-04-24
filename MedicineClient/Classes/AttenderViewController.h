//
//  AttenderViewController.h
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Block)(NSString *member,NSString *count);
@interface AttenderViewController : UIViewController
@property (nonatomic,strong)NSString *huizhenID;
@property (nonatomic,strong)NSString *huizhenIDNokf;
@property (nonatomic,assign)BOOL selectSecond;
@property (nonatomic,strong)NSArray *temparray;

@property (nonatomic,strong)Block Fillblock;

//
@property (nonatomic,assign)BOOL isModify;

@end
