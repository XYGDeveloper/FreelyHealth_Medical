//
//  GetHuanZheListRequest.h
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HuanZheListHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface HuanZheListBody : NSObject

@end

@interface GetHuanZheListRequest : NSObject
@property (nonatomic , strong) HuanZheListHeader *head;
@property (nonatomic , strong) HuanZheListBody *body;

@end
