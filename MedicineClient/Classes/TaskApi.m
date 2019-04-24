//
//  TaskApi.m
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TaskApi.h"
#import "MyTaskModel.h"
@implementation TaskApi

- (void)getMytask:(NSMutableDictionary *)detail
{
    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSArray *myTask = [MyTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"tasks"]];
    
    return myTask;
    
}




@end
