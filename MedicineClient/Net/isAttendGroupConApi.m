//
//  isAttendGroupConApi.m
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "isAttendGroupConApi.h"

@implementation isAttendGroupConApi

- (void)getIsttendDetail:(NSMutableDictionary *)detail
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
