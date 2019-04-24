//
//  JoinHZRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface joinHZHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface joinHZBody : NSObject
@property (nonatomic , copy) NSString *iscanyu;  
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *refuse;
@end
@interface JoinHZRequest : NSObject
@property (nonatomic , strong) joinHZHeader *head;
@property (nonatomic , strong) joinHZBody *body;

@end
