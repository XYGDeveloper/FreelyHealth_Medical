//
//  DeleGroupRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface delePeople : NSObject

@property (nonatomic,  copy)NSString *did;

@end

@interface deleGroupHead : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface deleGroupBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , strong) NSArray *peoples;

@end

@interface DeleGroupRequest : NSObject

@property (nonatomic,strong)deleGroupHead *head;

@property (nonatomic,strong)deleGroupBody *body;

@end
