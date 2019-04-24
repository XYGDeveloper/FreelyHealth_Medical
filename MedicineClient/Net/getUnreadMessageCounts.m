//
//  getUnreadMessageCounts.m
//  MedicineClient
//
//  Created by L on 2018/6/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "getUnreadMessageCounts.h"

@implementation getUnreadMessageCounts
- (void)getUnreadMessageCounts:(NSMutableDictionary *)appionment{
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
