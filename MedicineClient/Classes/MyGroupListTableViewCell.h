//
//  MyGroupListTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/12/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MyGroupListModel;
@class MySendModel;

@interface MyGroupListTableViewCell : UITableViewCell

- (void)refreshWithModel:(MyGroupListModel *)model;

- (void)refreshWithModel1:(MySendModel *)model;


@end
