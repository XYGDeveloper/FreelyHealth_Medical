//
//  TeamListTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class memberModel;

@interface TeamListTableViewCell : UITableViewCell

- (void)refreshWithModel:(memberModel *)model;


@end
