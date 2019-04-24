//
//  AgentApi.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentApi.h"
#import "AgentModel.h"
@implementation AgentApi

- (void)getagent:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    
    NSLog(@"------%@",responseObject);
    
    NSArray *agentarr = [AgentModel mj_objectArrayWithKeyValuesArray:responseObject[@"opeatorOrders"]];
    
    return agentarr;
    
}


@end
