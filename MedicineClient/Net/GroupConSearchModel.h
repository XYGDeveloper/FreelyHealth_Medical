//
//  GroupConSearchModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupConSearchModel : NSObject

@property (nonatomic,copy)NSString *dname;  //医生名

@property (nonatomic,copy)NSString *dusername;  //医生名

@property (nonatomic,copy)NSString *dhospital;  //医生医院

@property (nonatomic,copy)NSString *dpost;  //医生职务

@property (nonatomic,copy)NSString *did;  //医生id

@property (nonatomic,copy)NSString *dfacepath;  //医生头像

@end
