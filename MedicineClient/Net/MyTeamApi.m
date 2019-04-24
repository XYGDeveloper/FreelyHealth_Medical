//
//  MyTeamApi.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyTeamApi.h"
#import "MyTeamModel.h"
@implementation MyTeamApi


- (void)getTeamList:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSLog(@"请求成功%@",responseObject);
    
    MyTeamModel *model = [MyTeamModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
