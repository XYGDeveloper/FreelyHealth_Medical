//
//  InvitorDetailModel.m
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "InvitorDetailModel.h"


@implementation membersModel

@end



@implementation teamModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"peoples":@"membersModel"};
    
}


@end

@implementation InvitorDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"teams":@"teamModel"};
    
}


@end
