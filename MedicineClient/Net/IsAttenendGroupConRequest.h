//
//  IsAttenendGroupConRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsAttendHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface IsAttendBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *choose;

//choose  string    是    选择   1  参与 2 拒绝

@end


@interface IsAttenendGroupConRequest : NSObject

@property (nonatomic , strong) IsAttendHeader *head;

@property (nonatomic , strong) IsAttendBody *body;


@end
