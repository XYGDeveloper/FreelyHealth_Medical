//
//  MyIntroTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyProfilwModel;
@class GlistModel;
@interface MyIntroTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *introContent;

- (void)refreshWirthModel:(MyProfilwModel *)model;

- (void)refreshWirthModeltime:(MyProfilwModel *)model;

- (void)refreshWirthModel1:(NSString *)model;

- (void)refreshWirthGlistModel:(GlistModel *)model;//会诊详情

@end
