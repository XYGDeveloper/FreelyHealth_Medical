//
//  MyHZlistApi.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/5/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyHZlistApi.h"
#import "MyHZlistModel.h"
@implementation MyHZlistApi
- (void)getMylist:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [MyHZlistModel mj_objectArrayWithKeyValuesArray:responseObject[@"myyaoqings"]];
    return list;
}
@end
