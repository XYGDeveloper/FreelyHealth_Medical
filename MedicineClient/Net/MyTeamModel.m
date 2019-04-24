//
//  MyTeamModel.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyTeamModel.h"


@implementation memberModel






@end

@implementation MyTeamModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"memberModel"};
}


@end
