//
//  PhotoArrTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCerImageView.h"
@class MyProfilwModel;

@interface PhotoArrTableViewCell : UITableViewCell

- (void)refreshWithModel:(MyProfilwModel *)model;

@end
