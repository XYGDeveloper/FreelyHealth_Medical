//
//  AgentDetailModel.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface itemModel : NSObject

//{"id":"1","finish":"Y","name":"免费专家号源代预约","no":1},{"id":"2","finish":"Y","name":"专属护士诊前提醒","no":2}

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *finish;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *no;


@end


@interface AgentDetailModel : NSObject

//hname	string	是	医院名称
//patientname	string	是	服务对象名
//patientphone	string	是	服务对象电话
//goodname	string	是	服务名
//remark	string	是	说明
//id	string	是	当前订单id
//items	JSONArray	是	对应服务项目列表
//
//items参数：
//
//字段	类型	必填	说明
//name	string	是	项目名称
//id	string	是	项目id
//finish	string	是	流程是否处理  “Y”已处理, “N” 未处理
//no	string	是	流程号
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *patientname;

@property (nonatomic,copy)NSString *patientphone;

@property (nonatomic,copy)NSString *goodname;

@property (nonatomic,copy)NSString *remark;

@property (nonatomic,copy)NSArray *items;

@end
