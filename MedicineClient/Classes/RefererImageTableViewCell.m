//
//  RefererImageTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/3/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "RefererImageTableViewCell.h"
@interface RefererImageTableViewCell()
@property (nonatomic,strong)UILabel *profileLabel;
@end

@implementation RefererImageTableViewCell

- (UILabel *)profileLabel{
    if (!_profileLabel) {
        _profileLabel = [[UILabel alloc]init];
        _profileLabel.textAlignment = NSTextAlignmentLeft;
        _profileLabel.text = @"病历资料";
        _profileLabel.textColor = DefaultBlackLightTextClor;
        _profileLabel.font = FontNameAndSize(16);
    }
    return _profileLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.profileLabel];
        [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
        }];
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
