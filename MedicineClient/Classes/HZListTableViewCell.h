//
//  HZListTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyHZlistModel;
@interface HZListTableViewCell : UITableViewCell

- (void)refreshWithmodel:(MyHZlistModel *)model;
@end
