//
//  MyTaskModel.h
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTaskModel : NSObject

@property (nonatomic,copy)NSString *taskno;   //taskno    string    是    taskno

@property (nonatomic,copy)NSString *id;       //id    string    是    id

@property (nonatomic,copy)NSString *orderid;  //orderid    string    是    订单id

@property (nonatomic,copy)NSString *createtime;    //createtime    string    是    发布时间

@property (nonatomic,copy)NSString *status;        //status    string    是    请求详情状态码

@property (nonatomic,copy)NSString *patientage;   //patientage    string    是    服务对象年龄

@property (nonatomic,copy)NSString *patientsex;   //patientsex    string    是    服务对象性别

@property (nonatomic,copy)NSString *patientname;  //patientname    string    是    服务对象名

@property (nonatomic,copy)NSString *createuser;   //createuser    string    是    来自医生

@property (nonatomic,copy)NSString *createhospital;   //createhospital    string    是    来自医生的医院

@end
