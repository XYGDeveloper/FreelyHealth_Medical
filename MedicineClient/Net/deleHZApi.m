//
//  deleHZApi.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "deleHZApi.h"

@implementation deleHZApi
- (void)deleHZ:(NSMutableDictionary *)detail{
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
