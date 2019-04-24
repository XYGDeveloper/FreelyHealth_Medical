//
//  AuthCommitApi.m
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuthCommitApi.h"
#import "AuModel.h"
@implementation AuthCommitApi


- (void)AuthCommit:(NSMutableDictionary *)acha
{

    [self startRequestWithParams:acha];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    AuModel *model = [AuModel mj_objectWithKeyValues:responseObject];
    return model;
}



@end
