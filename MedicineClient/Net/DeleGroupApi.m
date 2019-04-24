//
//  DeleGroupApi.m
//  MedicineClient
//
//  Created by xyg on 2017/12/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DeleGroupApi.h"

@implementation DeleGroupApi

- (void)deleGroup:(NSMutableDictionary *)list{
    
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
