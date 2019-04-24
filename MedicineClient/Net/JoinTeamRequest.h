//
//  JoinTeamRequest.h
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface joinHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface joinBody : NSObject

@property (nonatomic , copy) NSString *id;

@end


@interface JoinTeamRequest : NSObject

@property (nonatomic,strong)joinHeader *head;

@property (nonatomic,strong)joinBody *body;


@end
