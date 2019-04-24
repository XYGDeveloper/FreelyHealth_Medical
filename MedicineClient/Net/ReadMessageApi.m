//
//  ReadMessageApi.m
//  FreelyHeath
//
//  Created by L on 2018/5/17.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReadMessageApi.h"

@implementation ReadMessageApi
- (void)readMessage:(NSMutableDictionary *)appionment{
    [self startRequestWithParams:appionment];
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
