//
//  HZListNormalTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZListNormalTableViewCell.h"
@interface HZListNormalTableViewCell()
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *resonLabel;

@end


@implementation HZListNormalTableViewCell
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [UIImageView new];
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
        _headImage.backgroundColor = DefaultBackgroundColor;
    }
    return _headImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = Font(16);
        _nameLabel.textColor = DefaultBlackLightTextClor;
    }
    return _nameLabel;
}
- (UILabel *)resonLabel{
    if (!_resonLabel) {
        _resonLabel = [UILabel new];
        _resonLabel.textAlignment = NSTextAlignmentLeft;
        _resonLabel.font = Font(14);
        _resonLabel.textColor = DefaultGrayTextClor;
    }
    return _resonLabel;
}

- (void)layOutsubview{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.headImage.mas_top);
    }];
    
    [self.resonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.resonLabel];
        [self layOutsubview];
        //
        self.nameLabel.text = @"吴亦凡";
        self.resonLabel.text = @"时间太晚我要做面膜";
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
