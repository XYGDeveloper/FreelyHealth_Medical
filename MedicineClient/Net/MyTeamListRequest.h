//
//  MyTeamListRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface teamHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface teamBody : NSObject

@property (nonatomic , copy) NSString *id;

@end

@interface MyTeamListRequest : NSObject

@property (nonatomic,strong)teamHeader *head;

@property (nonatomic,strong)teamBody *body;

@end
