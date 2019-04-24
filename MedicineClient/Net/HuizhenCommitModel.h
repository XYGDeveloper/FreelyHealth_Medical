//
//  HuizhenCommitModel.h
//  MedicineClient
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuizhenCommitModel : NSObject

@property (nonatomic,copy)NSString *HuiZhenJoiner;   //参与会诊患者
@property (nonatomic,copy)NSString *HuiZhenSubject;  //会诊主题
@property (nonatomic,copy)NSString *HuanZheName;     //会诊患者
@property (nonatomic,copy)NSString *HuanZheSex;      //患者性别
@property (nonatomic,copy)NSString *name;            //患者姓名
@property (nonatomic,copy)NSString *HuiZhenDes;      //会诊描述
@property (nonatomic,strong)NSArray *HuiZhenimgs;     //会诊图片

@end
