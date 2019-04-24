//
//  SeLectTeamListRequest.h
//  MedicineClient
//
//  Created by L on 2017/9/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface teamLHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface teamLBody : NSObject

@property (nonatomic , copy) NSString *name;

@end


@interface SeLectTeamListRequest : NSObject

@property (nonatomic,strong)teamLHeader *head;

@property (nonatomic,strong)teamLBody *body;


@end
