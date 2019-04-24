//
//  VersionUpdateRequest.h
//  MedicineClient
//
//  Created by L on 2017/11/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.

#import <Foundation/Foundation.h>


@interface versionHeader : NSObject

@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy) NSString *versioncode;
@property (nonatomic , copy) NSString *devicenum;
@property (nonatomic , copy) NSString *fromtype;
@property (nonatomic , copy) NSString *token;

@end

@interface versionBody : NSObject

@end

@interface VersionUpdateRequest : NSObject

@property (nonatomic,strong)versionHeader *head;
@property (nonatomic,strong)versionBody *body;

@end
