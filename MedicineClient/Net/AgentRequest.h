//
//  AgentRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/22.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface agentStepHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface agentStepBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *no;

@end


@interface AgentRequest : NSObject

@property (nonatomic,strong)agentStepHeader *head;

@property (nonatomic,strong)agentStepBody *body;


@end
