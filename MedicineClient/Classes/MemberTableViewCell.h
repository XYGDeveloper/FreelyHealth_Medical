//
//  MemberTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberModel;

@interface MemberTableViewCell : UITableViewCell

- (void)refreshWithModel:(MemberModel *)model;


@end
