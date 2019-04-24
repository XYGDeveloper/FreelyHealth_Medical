//
//  SelectAdviceTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectAdviceTableViewCell.h"
@interface SelectAdviceTableViewCell()
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameLabel;
@end
@implementation SelectAdviceTableViewCell
- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.layer.cornerRadius = 4;
        _headImg.layer.masksToBounds = YES;
        _headImg.backgroundColor = AppStyleColor;
    }
    return _headImg;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = FontNameAndSize(15);
        _nameLabel.textColor = DefaultBlackLightTextClor;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (void)setLayOut{
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(47);
        make.left.mas_equalTo(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nameLabel];
        [self setLayOut];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kuang_sel"]];
    }else
    {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kuang_normal"]];
    }
}

@end
