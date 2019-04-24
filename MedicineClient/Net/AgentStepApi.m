//
//  AgentStepApi.m
//  MedicineClient
//
//  Created by L on 2017/8/22.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentStepApi.h"

@implementation AgentStepApi

- (void)getStep:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}



@end
