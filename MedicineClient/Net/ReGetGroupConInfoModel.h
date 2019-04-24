//
//  ReGetGroupConInfoModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReGetGroupConInfoModel : NSObject

@property (nonatomic,copy)NSString *id;  //会诊记录id

@property (nonatomic,copy)NSString *patientname;  //服务对象名

@property (nonatomic,copy)NSString *item;  //会诊主题

@property (nonatomic,copy)NSString *des;  //描述详情

@property (nonatomic,copy)NSString *imagepath;  //图像资料


@end
