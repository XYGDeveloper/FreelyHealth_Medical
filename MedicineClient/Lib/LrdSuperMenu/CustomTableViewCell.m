//
//  CustomTableViewCell.m
//  LrdSuperMenu
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 键盘上的舞者. All rights reserved.
//

#import "CustomTableViewCell.h"
@interface CustomTableViewCell()
@end
@implementation CustomTableViewCell

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:18.0f];
    }
    return _label;
}

- (void)layOutsubview{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(25);
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self layOutsubview];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
