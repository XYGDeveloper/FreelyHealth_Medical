//
//  TeamDetailApi.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamDetailApi.h"
#import "TeamDetalModel.h"
@implementation TeamDetailApi


- (void)getTeamDetailList:(NSMutableDictionary *)detail
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
    
    TeamDetalModel *model = [TeamDetalModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}



@end
