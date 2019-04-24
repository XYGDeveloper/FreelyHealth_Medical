//
//  TaskDetailModel.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TaskDetailModel.h"

@implementation TaskDetailModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{
             
             @"des":@"description"
             
             };
    
}


@end
