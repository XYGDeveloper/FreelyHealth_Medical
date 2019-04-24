//
//  InvitorDetailModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface membersModel : NSObject


//"dteam": "团队2",
//"dfacepath": "http://zhiyi365.oss-cn-shanghai.aliyuncs.com/temp/4A248782-3057-4A79-A982-808525A9BB10.jpg",
//"dhospital": "复旦大学附属肿瘤医院",
//"did": "e36a6bbaa4e211e78fb400163e00b3a0",
//"dpost": "主任医师",
//"ddeptment": "肿瘤微创治疗",
//"dusername": "测试号"

@property (nonatomic,copy)NSString *dteam;     //参与会诊医生名称

@property (nonatomic,copy)NSString *dfacepath;    //参与会诊医生头像

@property (nonatomic,copy)NSString *dhospital;          //参与会诊人员id

@property (nonatomic,copy)NSString *did;          //参与会诊人员id

@property (nonatomic,copy)NSString *dpost;          //参与会诊人员id

@property (nonatomic,copy)NSString *ddeptment;          //参与会诊人员id

@property (nonatomic,copy)NSString *dusername;          //参与会诊人员id

@end

@interface teamModel : NSObject

@property (nonatomic,copy)NSString *tname;     //参与会诊医生名称

@property (nonatomic,strong)NSArray *peoples;  //该团队参与会诊成员

@end

@interface InvitorDetailModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,strong)NSArray *teams;

@property (nonatomic,copy)NSString *iscreater;

@end
