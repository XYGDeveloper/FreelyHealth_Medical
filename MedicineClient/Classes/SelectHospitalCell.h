//
//  SelectHospitalCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "VipEditCell.h"

typedef void (^selectType)(NSString *);

static NSString *const khospMale = @"1";
static NSString *const khospiFemale = @"0";

@interface SelectHospitalCell : VipEditCell

@property (nonatomic, strong) selectType type;

@property (nonatomic, copy) NSString *sex;

@end
