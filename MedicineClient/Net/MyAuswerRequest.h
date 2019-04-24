//
//  MyAuswerRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyAuswerHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface MyAuswerBody : NSObject


@end


@interface MyAuswerRequest : NSObject


@property (nonatomic,strong)MyAuswerHeader *head;

@property (nonatomic,strong)MyAuswerBody *body;



@end
