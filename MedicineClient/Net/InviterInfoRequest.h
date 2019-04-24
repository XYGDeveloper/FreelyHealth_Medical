//
//  InviterInfoRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5./Users/xyg/Desktop/DoctorClientProject最新修改的副本 3/MedicineClient/Net
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitorHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface InvitorBody : NSObject

@property (nonatomic , copy) NSString *id;

@end



@interface InviterInfoRequest : NSObject

@property (nonatomic , strong) InvitorHeader *head;

@property (nonatomic , strong) InvitorBody *body;

@end
