//
//  WailtToPayNoticeTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZListDetailModel;
@interface WailtToPayNoticeTableViewCell : UITableViewCell

- (void)refreshWithAppionmentDetailModel:(HZListDetailModel *)model;

@end
