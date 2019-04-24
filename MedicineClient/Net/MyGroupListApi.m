//
//  MyGroupListApi.m
//  MedicineClient
//
//  Created by L on 2017/12/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyGroupListApi.h"
#import "MyGroupListModel.h"
@implementation MyGroupListApi

- (void)getGroupList:(NSMutableDictionary *)detail
{
    [self startRequestWithParams:detail];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSArray *list = [MyGroupListModel mj_objectArrayWithKeyValuesArray:responseObject[@"mdts"]];
    
    return list;
    
}



@end
