//
//  GetHuanZheListApi.m
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetHuanZheListApi.h"
#import "HuanZheModel.h"
@implementation GetHuanZheListApi
- (void)huanzheList:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    NSArray *list = [HuanZheModel mj_objectArrayWithKeyValuesArray:responseObject[@"paidcases"]];
    return list;
}

@end
