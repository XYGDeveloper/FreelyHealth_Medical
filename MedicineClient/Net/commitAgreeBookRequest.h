//
//  commitAgreeBookRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface commitAgreeBookHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface commitAgreeBookBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id
@property (nonatomic , copy) NSString *diagnose;   //会诊意见
@property (nonatomic , copy) NSString *diagnoseimages;   //会诊图片资料

@end
@interface commitAgreeBookRequest : NSObject
@property (nonatomic , strong)commitAgreeBookHeader *head;
@property (nonatomic , strong)commitAgreeBookBody *body;
@end
