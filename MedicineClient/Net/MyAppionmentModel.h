//
//  MyAppionmentModel.h
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAppionmentModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *huizhentime;
@property (nonatomic,copy)NSString *topic;
@property (nonatomic,copy)NSString *issystem;
@property (nonatomic,copy)NSString *starttime;
@property (nonatomic,copy)NSString *iscanyu;
@property (nonatomic,copy)NSString *membercount;
@property (nonatomic,copy)NSString *canyucount;
@property (nonatomic,copy)NSString *dname;
@property (nonatomic,copy)NSString *status;

//id    string    是    会诊id
//huizhentime    string    是    会诊时间
//topic    string    是    会诊主题
//issystem    string    是    是否系统发起
//starttime    string    是    发起时间
//iscanyu    string    是    是否参与   如果返回是“D”需要显示按钮  0 不参与1参与
//membercount    string    是    成员数
//canyucount    string    是    确认参与数
//dname    string    是    系统发起显示直医客服；不是系统发起显示发起医生名
//status    string    是    1待会诊2 待处理 3取消 4完成 5不参加

@end
