//
//  VipSexSelectCell.h
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "VipEditCell.h"

typedef void (^selectType)(NSString *);

static NSString *const kSexMale = @"1";
static NSString *const kSexFemale = @"0";

@interface VipSexSelectCell : VipEditCell

@property (nonatomic, strong) selectType type;

@property (nonatomic, copy) NSString *sex;

@end