//
//  cancelHZRequest.h
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface cancelHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface cancelBody : NSObject
@property (nonatomic , copy) NSString *id;   //会诊信息id
@property (nonatomic , copy) NSString *reason;


@end
@interface cancelHZRequest : NSObject
@property (nonatomic , strong)cancelHeader *head;
@property (nonatomic , strong)cancelBody *body;
@end
