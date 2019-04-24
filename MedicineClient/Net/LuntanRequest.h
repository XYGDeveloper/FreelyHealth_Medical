//
//  LuntanRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface luntanHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface luntanBody : NSObject

//status	String 	否	不填 所有 1未支付 2进行中 3 已完成



@end


@interface LuntanRequest : NSObject

@property (nonatomic,strong)luntanHeader *head;

@property (nonatomic,strong)luntanBody *body;


@end
