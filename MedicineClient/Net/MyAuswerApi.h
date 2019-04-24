//
//  MyAuswerApi.h
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"
@class MyAuswerModel;

@interface MyAuswerApi : BaseApi

- (void)getMyAuswer:(NSMutableDictionary *)detail;



@end
