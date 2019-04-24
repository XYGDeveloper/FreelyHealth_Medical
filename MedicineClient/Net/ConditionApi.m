//
//  ConditionApi.m
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConditionApi.h"
#import "ConditionTeamModel.h"
@implementation ConditionApi

- (void)AllteamQuaryList:(NSMutableDictionary *)detail
{
    
    [self startRequestWithParams:detail];
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
//    NSLog(@"%@",responseObject);
    
    NSArray *arr = [ConditionTeamModel mj_objectArrayWithKeyValuesArray:responseObject[@"teams"]];
    
    return arr;
    
}



@end
