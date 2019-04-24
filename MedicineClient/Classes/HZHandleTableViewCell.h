//
//  HZHandleTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAppionmentModel;
typedef void(^attendBlock)();
typedef void(^notAttendBlock)();
@interface HZHandleTableViewCell : UITableViewCell

@property (nonatomic,strong)attendBlock attendblock;
@property (nonatomic,strong)notAttendBlock notattendblock;
- (void)refreshWITHModel:(MyAppionmentModel *)model;

@end
