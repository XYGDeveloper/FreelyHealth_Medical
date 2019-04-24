//
//  ReferDetailApi.m
//  MedicineClient
//
//  Created by L on 2017/10/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReferDetailApi.h"
#import "ReferDetailModel.h"
@implementation ReferDetailApi

- (void)referDetail:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    
    ReferDetailModel *model = [ReferDetailModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
