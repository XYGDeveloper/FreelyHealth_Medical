//
//  MySendsApi.m
//  MedicineClient
//
//  Created by L on 2017/12/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MySendsApi.h"
#import "MySendModel.h"
@implementation MySendsApi

- (void)MyInvite:(NSMutableDictionary *)detail{
    
    [self startRequestWithParams:detail];
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSArray *arr = [MySendModel mj_objectArrayWithKeyValuesArray:responseObject[@"yaoqings"]];
    return arr;
    
}


@end
