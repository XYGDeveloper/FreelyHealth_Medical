//
//  JopApi.m
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "JopApi.h"
#import "JopModel.h"
@implementation JopApi

- (void)getJopList:(NSMutableDictionary *)acha
{

    [self startRequestWithParams:acha];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    
    NSLog(@"请求成功%@",responseObject);
    
    NSArray *jopArr = [JopModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
    
    return jopArr;
    
    
}


@end
