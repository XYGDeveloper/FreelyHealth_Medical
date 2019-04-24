//
//  RFRRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFRHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface RFRBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *type;

@end


@interface RFRRequest : NSObject

@property (nonatomic,strong)RFRHeader *head;

@property (nonatomic,strong)RFRBody *body;


@end
