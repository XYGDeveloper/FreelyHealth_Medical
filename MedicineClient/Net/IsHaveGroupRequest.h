//
//  IsHaveGroupRequest.h
//  MedicineClient
//
//  Created by L on 2017/12/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface isHaveHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface isHaveBody : NSObject

@property (nonatomic , copy) NSString *taskno;

@end


@interface IsHaveGroupRequest : NSObject

@property (nonatomic , strong) isHaveHeader *head;

@property (nonatomic , strong) isHaveBody *body;

@end
