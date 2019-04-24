//
//  SearchDoctorRequest.h
//  MedicineClient
//
//  Created by L on 2018/4/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface searchHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface searchBody : NSObject

@property (nonatomic , copy) NSString *keyword;

@end

@interface SearchDoctorRequest : NSObject

@property (nonatomic , strong)   searchHeader *head;

@property (nonatomic , strong) searchBody *body;

@end
