//
//  getroupListApi.m
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "getroupListApi.h"
#import "GroupConSearchModel.h"
@implementation getroupListApi

- (void)getDoctorSearchList:(NSMutableDictionary *)list
{
    [self startRequestWithParams:list];
}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}


- (id)reformData:(id)responseObject {
    
    NSArray *searchList = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responseObject[@"doctors"]];
    return searchList;
}

@end
