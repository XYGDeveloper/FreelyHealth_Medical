//
//  AgentModel.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentModel : NSObject

//worktime	string	是	服务时间
//patientname	string	是	服务对象名
//patientphone	string	是	服务对象电话
//goodname	string	是	服务名
//itemssum	string	是	流程总数
//itemno	string	是	当前流程号
//orderid	string	是	当前订单号
//isfinish	string	是	是否完成  Y 已完成  N 未完成

@property (nonatomic,copy)NSString *isfinish;

@property (nonatomic,copy)NSString *orderid;

@property (nonatomic,copy)NSString *itemno;

@property (nonatomic,copy)NSString *itemssum;

@property (nonatomic,copy)NSString *goodname;

@property (nonatomic,copy)NSString *patientphone;

@property (nonatomic,copy)NSString *patientname;

@property (nonatomic,copy)NSString *worktime;

@end
