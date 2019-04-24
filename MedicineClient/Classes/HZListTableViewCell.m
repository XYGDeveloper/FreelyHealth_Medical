//
//  HZListTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZListTableViewCell.h"
#import "MyHZlistModel.h"
@interface HZListTableViewCell()
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *refuseLabel;

@end

@implementation HZListTableViewCell
- (UIImageView *)headImage{
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
- (UILabel *)refuseLabel{
    if (!_refuseLabel) {
        _refuseLabel = [UILabel new];
        _refuseLabel.textAlignment = NSTextAlignmentLeft;
        _refuseLabel.font = Font(16);
        _refuseLabel.textColor = DefaultGrayLightTextClor;
    }
    return _refuseLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.refuseLabel];
    }
    return self;
}

- (void)refreshWithmodel:(MyHZlistModel *)model{
    if (!model.refuse) {
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(50);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.headImage.mas_centerY);
        }];
    }else{
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
        [self.refuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(5);
        }];
        
    }
    self.nameLabel.text = model.name;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.facepath]];
    if (model.refuse) {
        self.refuseLabel.text = model.refuse;
    }else{
        self.refuseLabel.text = @"";
    }
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
