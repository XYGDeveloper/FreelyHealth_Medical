//
//  AddGroupRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addPeople : NSObject

@property (nonatomic,  copy)NSString *did;

@end

@interface AddGroupHead : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface AddGroupBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , strong) NSArray *peoples;

@end

@interface AddGroupRequest : NSObject

@property (nonatomic,strong)AddGroupHead *head;

@property (nonatomic,strong)AddGroupBody *body;

@end
