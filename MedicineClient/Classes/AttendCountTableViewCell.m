//
//  AttendCountTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/22.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AttendCountTableViewCell.h"
#import "HZListDetailModel.h"
@interface AttendCountTableViewCell()
@property (nonatomic,strong)UILabel *leftlabel;
@property (nonatomic,strong)UILabel *rightlabel;

@end

@implementation AttendCountTableViewCell
- (UILabel *)leftlabel{
    if (!_leftlabel) {
        _leftlabel = [[UILabel alloc]init];
        _leftlabel.textAlignment = NSTextAlignmentLeft;
        _leftlabel.textColor = DefaultGrayLightTextClor;
        _leftlabel.font = FontNameAndSize(16);
    }
    return _leftlabel;
}

- (UILabel *)rightlabel{
    if (!_rightlabel) {
        _rightlabel = [[UILabel alloc]init];
        _rightlabel.textAlignment = NSTextAlignmentRight;
        _rightlabel.textColor = DefaultGrayLightTextClor;
        _rightlabel.font = FontNameAndSize(16);
    }
    return _rightlabel;
}

- (void)layOut{
    [self.leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/2-15);
        make.height.mas_equalTo(20);
    }];
    [self.rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth/2 - 15);
    }];
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftlabel];
        [self.contentView addSubview:self.rightlabel];
        [self layOut];
    }
    return self;
}

- (void)refreshWithmodel:(HZListDetailModel *)model{
    self.leftlabel.text = [NSString stringWithFormat:@"参会人员：%@等%@人",model.canyuname,model.membercount];
    NSString *startstr = [NSString stringWithFormat:@"%@/%@人确定参加",model.canyucount,model.membercount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:startstr];
    NSLog(@"==========%lu",(unsigned long)startstr.length);
    [str addAttribute:NSForegroundColorAttributeName value:AppStyleColor range:NSMakeRange(0,1)];
    self.rightlabel.attributedText = str;
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
