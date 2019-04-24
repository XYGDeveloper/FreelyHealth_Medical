//
//  CancelCollectionRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topicModel : NSObject

@property (nonatomic,  copy)NSString *topicid;

@end

@interface CancelCollectionHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface CancelCollectionBody : NSObject

@property (nonatomic , copy) NSArray *topicids;

@end


@interface CancelCollectionRequest : NSObject

@property (nonatomic,strong)CancelCollectionHeader *head;

@property (nonatomic,strong)CancelCollectionBody *body;

@end
