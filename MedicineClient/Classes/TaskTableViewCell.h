//
//  TaskTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTaskModel;

typedef void (^scanDetailBlock)();

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic,strong)scanDetailBlock block;

- (void)refreshwithModel:(MyTaskModel *)model;

- (void)refreshwithModel1:(MyTaskModel *)model;


@end
