//
//  HzDetailRequest.h
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HZListDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface HZListDetailBody : NSObject
@property (nonatomic , copy) NSString *type;   //1未结束 2结束 3我发起

//会诊详情
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *issystem;

@end
@interface HzDetailRequest : NSObject
@property (nonatomic , strong)HZListDetailHeader *head;
@property (nonatomic , strong)HZListDetailBody *body;
@end
