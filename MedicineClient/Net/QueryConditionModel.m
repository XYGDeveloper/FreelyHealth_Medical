//
//  QueryConditionModel.m
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QueryConditionModel.h"

@implementation AllmemberModel


@end


@implementation allCityModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"AllmemberModel"
             };
}

@end

@implementation AlldepartModel



@end

@implementation QueryConditionModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"citys":@"allCityModel",
             @"departments":@"AlldepartModel",
             };
}



@end
