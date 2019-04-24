//
//  ReferDetailModel.h
//  MedicineClient
//
//  Created by L on 2017/10/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReferDetailModel : NSObject

@property (nonatomic,copy)NSString *patientname;

@property (nonatomic,copy)NSString *patientsex;

@property (nonatomic,copy)NSString *patientage;

@property (nonatomic,copy)NSString *createtime;

@property (nonatomic,copy)NSString *des;

@property (nonatomic,copy)NSString *imagepath;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *target;

@property (nonatomic,copy)NSString *targethospital;

@property (nonatomic,copy)NSString *accepttime;

@property (nonatomic,copy)NSString *refusetime;

@property (nonatomic,copy)NSString *finishtime;

@property (nonatomic,copy)NSString *refusetarget;

@property (nonatomic,copy)NSString *refusetargethospital;

@property (nonatomic,copy)NSString *status;

//patientname	string	是	服务对象名
//patientsex	string	是	服务对象性别
//patientage	string	是	服务对象年龄
//createtime	string	是	发布时间
//description	string	是	描述
//imagepath	string	是	病历资料
//id	string	是	任务id
//target	string	是	目标医生
//targethospital	string	是	目标医生所在医院
//accepttime	string	是	接受时间
//refusetime
//string	是	拒绝时间
//finishtime	string	是	完成时间
//refusetarget
//string	是	目标拒绝医生
//refusetargethospital
//string	是	目标拒绝医生所在医院
//status	String	是	1已转诊 2已被接受 3已完成 4 已被拒绝





@end
