//
//  GetJoinedDoctorApi.m
//  MedicineClient
//
//  Created by L on 2018/5/17.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetJoinedDoctorApi.h"
#import "GroupConSearchModel.h"
@implementation GetJoinedDoctorApi
- (void)getJoinedDoctorList:(NSMutableDictionary *)detail{
    [self startRequestWithParams:detail];

}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    NSArray *list = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responseObject[@"peoples"]];
    return list;
}
@end
