//
//  ConditionTeamModel.m
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConditionTeamModel.h"

@implementation MemberModel

@end

@implementation ConditionTeamModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"MemberModel"};
}


@end
