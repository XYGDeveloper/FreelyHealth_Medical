//
//  FindGroupApi.m
//  MedicineClient
//
//  Created by L on 2017/12/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FindGroupApi.h"
#import "GroupInfoModel.h"
@implementation FindGroupApi

- (void)getGroupInfo:(NSMutableDictionary *)detail
{
    
    [self startRequestWithParams:detail];

    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    GroupInfoModel *model = [GroupInfoModel mj_objectWithKeyValues:responseObject];
    return model;
    
}


@end
