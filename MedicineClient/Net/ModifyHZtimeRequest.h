//
//  ModifyHZtimeRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface modifyHZtimeHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface modifyHZtimeBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id
@property (nonatomic , copy) NSString *huizhentime;   //会诊时间
@property (nonatomic , copy) NSString *topic;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , copy) NSString *age;
@property (nonatomic , copy) NSString *zhengzhuang;
@property (nonatomic , copy) NSString *blimages;

@end
@interface ModifyHZtimeRequest : NSObject
@property (nonatomic , strong)modifyHZtimeHeader *head;
@property (nonatomic , strong)modifyHZtimeBody *body;
@end
