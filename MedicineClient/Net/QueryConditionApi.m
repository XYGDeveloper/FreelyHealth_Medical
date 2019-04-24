//
//  QueryConditionApi.m
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QueryConditionApi.h"
#import "QueryConditionModel.h"
@implementation QueryConditionApi

- (void)teamQuaryList:(NSMutableDictionary *)detail{
    
    [self startRequestWithParams:detail];
    
}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
//    NSLog(@"ppp%@",responseObject);
    
    QueryConditionModel *model = [QueryConditionModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
