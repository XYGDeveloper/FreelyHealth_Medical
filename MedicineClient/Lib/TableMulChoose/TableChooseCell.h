//
//  MulChooseCell.h
//  MulChooseDemo
//
//  Created by L2H on 16/7/13.
//  Copyright © 2016年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableChooseCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *jopLabel;
@property (nonatomic, strong)UIButton *SelectIconBtn;
@property (nonatomic,assign)BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;
@end
