//
//  HZListdetailApi.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZListdetailApi.h"
#import "HZListDetailModel.h"
@implementation HZListdetailApi
- (void)gethzDetail:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    HZListDetailModel *model = [HZListDetailModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
