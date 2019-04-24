//
//  QueryConditionModel.h
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllmemberModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@end


@interface AlldepartModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@end


@interface allCityModel : NSObject


@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,strong)NSArray *members;


@end




@interface QueryConditionModel : NSObject

@property (nonatomic,strong)NSArray *citys;

@property (nonatomic,strong)NSArray *departments;

@end
