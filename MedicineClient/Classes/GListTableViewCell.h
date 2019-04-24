//
//  GListTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyInviteModel;
@class MySendModel;

@interface GListTableViewCell : UITableViewCell

- (void)refreshWithModel:(MyInviteModel *)model;

- (void)refreshWithModel1:(MySendModel *)model;


@end
