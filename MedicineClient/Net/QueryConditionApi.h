//
//  QueryConditionApi.h
//  MedicineClient
//
//  Created by L on 2017/9/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"
@class AllTeamModel;

@interface QueryConditionApi : BaseApi

- (void)teamQuaryList:(NSMutableDictionary *)detail;


@end
