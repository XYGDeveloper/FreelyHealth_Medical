//
//  MySendsInviteApi.m
//  MedicineClient
//
//  Created by L on 2018/3/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MySendsInviteApi.h"
#import "MySendModel.h"
@implementation MySendsInviteApi

- (void)MysendInvite:(NSMutableDictionary *)detail{
    
    [self startRequestWithParams:detail];
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSArray *arr = [MySendModel mj_objectArrayWithKeyValuesArray:responseObject[@"mdts"]];
    return arr;
    
}
@end
