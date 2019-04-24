//
//  LunTanApi.m
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "LunTanApi.h"
#import "LunTanModel.h"
@implementation LunTanApi

- (void)getLuntan:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    NSLog(@"%@",responseObject);
    NSArray *arr = [LunTanModel mj_objectArrayWithKeyValuesArray:responseObject[@"questions"]];
    
    return arr;

}



@end