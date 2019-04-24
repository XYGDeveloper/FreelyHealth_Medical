//
//  AgentDetailApi.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"
@class AgentDetailModel;

@interface AgentDetailApi : BaseApi

- (void)getagentDetail:(NSMutableDictionary *)detail;


@end
