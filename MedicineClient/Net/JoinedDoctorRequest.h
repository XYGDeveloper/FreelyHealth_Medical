//
//  JoinedDoctorRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/17.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface joinedDoctorHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface joinedDoctorBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id

//添加会诊人员接口


@end
@interface JoinedDoctorRequest : NSObject
@property (nonatomic , strong)joinedDoctorHeader *head;
@property (nonatomic , strong)joinedDoctorBody *body;
@end
