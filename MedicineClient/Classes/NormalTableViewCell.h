//
//  NormalTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"

@interface NormalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftText;

@property (weak, nonatomic) IBOutlet UILabel *rightText;


@end
