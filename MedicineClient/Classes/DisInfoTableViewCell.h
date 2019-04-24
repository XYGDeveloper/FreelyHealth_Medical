//
//  DisInfoTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReferDetailModel;

@interface DisInfoTableViewCell : UITableViewCell

- (void)refreshWithModel1:(ReferDetailModel *)model;

@end
