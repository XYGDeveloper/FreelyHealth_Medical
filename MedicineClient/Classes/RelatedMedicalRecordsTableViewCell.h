//
//  RelatedMedicalRecordsTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/8/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LunTanModel;
@interface RelatedMedicalRecordsTableViewCell : UITableViewCell

- (void)cellDataWithModel:(LunTanModel *)model;

- (void)cellClickBt:(dispatch_block_t)clickBtBlock;


@end
