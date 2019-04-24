//
//  IsHaveApi.m
//  MedicineClient
//
//  Created by L on 2017/12/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IsHaveApi.h"
#import "IsHaveGroupModel.h"
@implementation IsHaveApi

- (void)IsInvite:(NSMutableDictionary *)detail{
    
    [self startRequestWithParams:detail];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    IsHaveGroupModel *model = [IsHaveGroupModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
