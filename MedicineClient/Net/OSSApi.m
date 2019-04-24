//
//  OSSApi.m
//  FreelyHeath
//
//  Created by xyg on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OSSApi.h"
#import "OSSModel.h"
@implementation OSSApi


- (void)getoss:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    OSSModel *model = [OSSModel mj_objectWithKeyValues:responseObject];
    return model;
    
    
    
}


@end
