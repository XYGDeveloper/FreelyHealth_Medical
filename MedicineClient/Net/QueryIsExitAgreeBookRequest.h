//
//  QueryIsExitAgreeBookRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QGBHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface QGBBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id
@end
@interface QueryIsExitAgreeBookRequest : NSObject
@property (nonatomic , strong)QGBHeader *head;
@property (nonatomic , strong)QGBBody *body;
@end
