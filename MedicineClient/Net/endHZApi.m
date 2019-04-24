//
//  endHZApi.m
//  MedicineClient
//
//  Created by L on 2018/5/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "endHZApi.h"

@implementation endHZApi
- (void)endHZ:(NSMutableDictionary *)detail{
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
