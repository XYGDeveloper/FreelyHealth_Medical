//
//  TableViewCell.m
//  UISearchDisplayControllerDemo
//
//  Created by litt1e-p on 15/12/8.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
