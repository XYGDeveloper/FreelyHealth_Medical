//
//  MyappionmentListApi.m
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyappionmentListApi.h"
#import "MyAppionmentModel.h"
@implementation MyappionmentListApi
- (void)getAppionmentList:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    NSArray *list = [MyAppionmentModel mj_objectArrayWithKeyValuesArray:responseObject[@"myhuizhens"]];
    return list;
}

@end
