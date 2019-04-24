//
//  SelectHanzheTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectHanzheTableViewCell.h"
#import "HuanZheModel.h"
@interface SelectHanzheTableViewCell()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *infoLabel;

@end

@implementation SelectHanzheTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = Font(16);
        self.nameLabel.textColor = DefaultBlackLightTextClor;
        self.infoLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.infoLabel];
        self.infoLabel.textAlignment = NSTextAlignmentLeft;
        self.infoLabel.font = FontNameAndSize(14);
        self.infoLabel.textColor = DefaultGrayTextClor;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(-20);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(-20);
        }];
        //test
    }
    return self;
}
- (void)refreshWithModel:(HuanZheModel *)model{
    self.nameLabel.text = model.topic;
    self.infoLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",model.name,model.sex,model.age,model.phone];
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
