//
//  GlistModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlistModel : NSObject

@property (nonatomic,copy)NSString *id;     //参与会诊医生名称

@property (nonatomic,copy)NSString *patientname;    //参与会诊医生头像

@property (nonatomic,copy)NSString *item;          //参与会诊人员id

@property (nonatomic,copy)NSString *des;          //参与会诊人员id

@property (nonatomic,copy)NSString *imagepath;          //参与会诊人员id

@end
