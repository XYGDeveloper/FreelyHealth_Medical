//
//  AppionmentListDetailModel.m
//  FreelyHeath
//
//  Created by L on 2018/5/15.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListDetailModel.h"
@implementation AppionmentDetailModel

@end

@implementation AppionmentListDetailModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"AppionmentDetailModel",
             };
}
@end
