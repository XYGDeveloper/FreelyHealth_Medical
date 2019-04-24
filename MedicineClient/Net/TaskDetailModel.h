//
//  TaskDetailModel.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetailModel : NSObject

//patientname	string	是	服务对象名
//patientsex	string	是	服务对象性别
//patientage	string	是	服务对象年龄
//createtime	string	是	发布时间
//description	string	是	描述
//imagepath	string	是	病历资料
//id	string	是	任务id
//patientphone	string	是	服务对象电话

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *patientphone;

@property (nonatomic,copy)NSString *imagepath;

@property (nonatomic,copy)NSString *des;

@property (nonatomic,copy)NSString *createtime;

@property (nonatomic,copy)NSString *patientage;

@property (nonatomic,copy)NSString *patientsex;

@property (nonatomic,copy)NSString *patientname;


@end
