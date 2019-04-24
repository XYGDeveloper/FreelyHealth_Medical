//
//  AgentDetailTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^stepAction)();

@class itemModel;


@interface AgentDetailTableViewCell : UITableViewCell


@property (nonatomic,strong)stepAction action;


- (void)refreshWithModel:(itemModel *)model;



@end
