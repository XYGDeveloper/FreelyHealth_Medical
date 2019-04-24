//
//  InvitorModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invitor : NSObject

@property (nonatomic,copy)NSString *dusername;  //参与会诊医生名称
@property (nonatomic,copy)NSString *dfacepath;  //参与会诊医生头像
@property (nonatomic,copy)NSString *did;        //参与会诊人员id

@end

@interface InvitorModel : NSObject

@property (nonatomic,copy)NSString *id;        //会诊记录id

@property (nonatomic,strong)NSArray *invitors;        //人员列表

@end
