//
//  AgreeBookTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgreeBookTableViewCell.h"
#import "AgreeBookModel.h"
@interface AgreeBookTableViewCell()
@property (nonatomic,strong)UILabel *content;
@end
@implementation AgreeBookTableViewCell

- (UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.font = FontNameAndSize(16);
        _content.textColor = DefaultGrayTextClor;
        _content.numberOfLines = 0;
    }
    return _content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)refreshWithModel:(AgreeBookModel *)model{
    self.content.text = model.diagnose;
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
