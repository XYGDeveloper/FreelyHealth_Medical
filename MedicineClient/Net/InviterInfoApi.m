//
//  InviterInfoApi.m
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "InviterInfoApi.h"
#import "InvitorModel.h"
@implementation InviterInfoApi

- (void)getInvitorInfo:(NSMutableDictionary *)detail
{
    
    [self startRequestWithParams:detail];

}



- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    
    InvitorModel *model = [InvitorModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
