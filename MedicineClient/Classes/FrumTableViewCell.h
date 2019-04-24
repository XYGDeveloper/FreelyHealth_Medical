//
//  FrumTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LunTanModel;

@class MyAuswerModel;

@class MyCollectionModel;


@interface FrumTableViewCell : UITableViewCell

- (void)cellDataWithModel:(LunTanModel *)model;

- (void)cellDataWithauswertModel:(MyAuswerModel *)model;

- (void)cellDataWithCollectionModel:(MyCollectionModel *)model;

@end
