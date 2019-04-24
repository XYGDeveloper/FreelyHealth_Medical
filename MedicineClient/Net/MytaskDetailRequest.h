//
//  MytaskDetailRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTaskDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface MyTaskDetailBody : NSObject

@property (nonatomic , copy) NSString *id;

@end


@interface MytaskDetailRequest : NSObject

@property (nonatomic,strong)MyTaskDetailHeader *head;

@property (nonatomic,strong)MyTaskDetailBody *body;

@end
