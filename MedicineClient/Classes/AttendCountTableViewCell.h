//
//  AttendCountTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/5/22.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZListDetailModel;
@interface AttendCountTableViewCell : UITableViewCell

- (void)refreshWithmodel:(HZListDetailModel *)model;

@end
