//
//  GetGroupInfoRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getGroupHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface getGroupBody : NSObject

@property (nonatomic , copy) NSString *id;

@end

@interface GetGroupInfoRequest : NSObject

@property (nonatomic , strong) getGroupHeader *head;

@property (nonatomic , strong) getGroupBody *body;

@end
