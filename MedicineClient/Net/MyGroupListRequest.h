//
//  MyGroupListRequest.h
//  MedicineClient
//
//  Created by L on 2017/12/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupListHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface MyGroupListBody : NSObject

@property (nonatomic , copy) NSString *id;

@end

@interface MyGroupListRequest : NSObject

@property (nonatomic , strong)  MyGroupListHeader *head;

@property (nonatomic , strong) MyGroupListBody *body;


@end
