//
//  MulChooseCell.m
//  MulChooseDemo
//
//  Created by L2H on 16/7/13.
//  Copyright © 2016年 ailk. All rights reserved.
//

#import "TableChooseCell.h"
#define HorizonGap 15
#define TilteBtnGap 10
#define ColorRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation TableChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, ColorRGB(0xf7f7f7).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self MakeView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)MakeView{
    
    self.headImg = [[UIImageView alloc]init];
    self.headImg.backgroundColor = AppStyleColor;
    self.headImg.userInteractionEnabled = NO;
    self.headImg.image = [UIImage imageNamed:@"1.jpg"];
    [self.contentView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(66);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    self.headImg.layer.cornerRadius = 66/2;
    self.headImg.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    self.nameLabel.textColor = DefaultBlackLightTextClor;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(10);
        make.top.equalTo(self.headImg.mas_top);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];
    
    self.jopLabel = [[UILabel alloc]init];
    self.jopLabel.font = [UIFont systemFontOfSize:16];
    self.jopLabel.textAlignment = NSTextAlignmentLeft;
    self.jopLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
//    self.jopLabel.text = @"复旦大学肿瘤附属医院  副主任医师";
    self.jopLabel.textColor = [UIColor colorWithRed:66/255.0f green:66/255.0f  blue:66/255.0f  alpha:1.0f];
    [self.contentView addSubview:self.jopLabel];
    [self.jopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-30);
    }];
    self.SelectIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.SelectIconBtn setImage:[UIImage imageNamed:@"kuang_normal"] forState:UIControlStateNormal];
    [self.SelectIconBtn setImage:[UIImage imageNamed:@"kuang_sel"] forState:UIControlStateSelected];
    self.SelectIconBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.SelectIconBtn];
    [self.SelectIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(45);
    }];
    
}

-(void)UpdateCellWithState:(BOOL)select{
    self.SelectIconBtn.selected = select;
    _isSelected = select;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.SelectIconBtn.selected = !self.SelectIconBtn.selected;

}

@end
