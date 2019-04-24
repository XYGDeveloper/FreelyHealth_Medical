//
//  FrumDetailTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrumDetailModel;
@interface FrumDetailTableViewCell : UITableViewCell

- (void)cellDataWithModel:(FrumDetailModel *)model;

- (void)cellClickBt:(dispatch_block_t)clickBtBlock;

@end
