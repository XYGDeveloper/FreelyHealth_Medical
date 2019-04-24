//
//  GetHZInfoRequest.h
//  MedicineClient
//
//  Created by L on 2018/6/11.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface getHZinfoHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface getHZinfoBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id

@end
@interface GetHZInfoRequest : NSObject
@property (nonatomic , strong)getHZinfoHeader *head;
@property (nonatomic , strong)getHZinfoBody *body;
@end
