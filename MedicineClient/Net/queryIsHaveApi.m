//
//  queryIsHaveApi.m
//  MedicineClient
//
//  Created by L on 2018/5/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "queryIsHaveApi.h"
#import "AgreeBookModel.h"
@implementation queryIsHaveApi

- (void)quqryAgreebook:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    AgreeBookModel *model = [AgreeBookModel mj_objectWithKeyValues:responseObject];
    return model;
}


@end
