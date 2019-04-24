//
//  sendHZRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/17.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface sendHZHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface sendHZBody : NSObject

@property (nonatomic , copy) NSString *id;      //会诊预约id
@property (nonatomic , copy) NSString *topic;   //会诊主题
@property (nonatomic , copy) NSString *name;    //会诊患者
@property (nonatomic , copy) NSString *sex;     //会诊性别
@property (nonatomic , copy) NSString *age;     //会诊年龄
@property (nonatomic , copy) NSString *zhengzhuang; //会诊情况
@property (nonatomic , copy) NSString *blimages;    //会诊图片资料
//beginHuizhen
@property (nonatomic , copy) NSString *huizhentime;    //会诊时间
@end
@interface sendHZRequest : NSObject
@property (nonatomic , strong)sendHZHeader *head;
@property (nonatomic , strong)sendHZBody *body;
@end
