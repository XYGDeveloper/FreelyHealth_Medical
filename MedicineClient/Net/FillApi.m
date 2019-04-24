//
//  FillApi.m
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FillApi.h"

@implementation FillApi

- (void)fillAndCommit:(NSMutableDictionary *)list
{
    [self startRequestWithParams:list];

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
