//
//  MyAuswerApi.m
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyAuswerApi.h"
#import "MyAuswerModel.h"
@implementation MyAuswerApi


- (void)getMyAuswer:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSArray *myauswer = [MyAuswerModel mj_objectArrayWithKeyValuesArray:responseObject[@"questions"]];
    
    return myauswer;
    
    
    
}




@end
