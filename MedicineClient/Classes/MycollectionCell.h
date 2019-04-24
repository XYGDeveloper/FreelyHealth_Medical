//
//  MycollectionCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/29.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCollectionModel;
@class MyAuswerModel;

@interface MycollectionCell : UITableViewCell

- (void)cellDataWithcollModel:(MyCollectionModel *)model;

- (void)cellDataWithausModel:(MyAuswerModel *)model;


@end
