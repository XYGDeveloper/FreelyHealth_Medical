//
//  AgentIndexReruest.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface AgentBody : NSObject

@property (nonatomic , copy) NSString *isfinish;

@end

@interface AgentIndexReruest : NSObject

@property (nonatomic,strong)AgentHeader *head;

@property (nonatomic,strong)AgentBody *body;


@end
