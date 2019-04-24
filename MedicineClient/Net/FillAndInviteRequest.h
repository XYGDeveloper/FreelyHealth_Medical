//
//  FillAndInviteRequest.h
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FillHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface FillBody : NSObject

@property (nonatomic , copy) NSString *patientname;

@property (nonatomic , copy) NSString *item;

@property (nonatomic , copy) NSString *des;

@property (nonatomic , copy) NSString *imagepath;

@property (nonatomic , copy) NSString *taskno;

@end

@interface FillAndInviteRequest : NSObject

@property (nonatomic,strong)FillHeader *head;

@property (nonatomic,strong)FillBody *body;

@end
