//
//  BadgeTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/6/9.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BadgeTableViewCell.h"
#import "LKBadgeView.h"
@interface BadgeTableViewCell()

@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic,strong)LKBadgeView *badge;

@end


@implementation BadgeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.font = FontNameAndSize(16);
        [self.contentView addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        self.badge = [[LKBadgeView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 52/2 - 19, 42, 38)];
        self.badge.widthMode = LKBadgeViewWidthModeSmall;
        [self.contentView addSubview:self.badge];
    }
    return self;
}


- (void)refreshWith:(NSString *)letImage textlabeltext:(NSString *)textlabel count:(NSString *)counts{
    self.imageView.image = [UIImage imageNamed:letImage];
    self.textLabel.text = textlabel;
    self.textLabel.font = FontNameAndSize(16);
    if ([counts integerValue] > 0) {
        self.badge.badgeColor = DefaultRedTextClor;
        self.badge.textColor = [UIColor whiteColor];
        self.badge.text = [NSString stringWithFormat:@"%d",[counts intValue]];
    }
    else{
        self.badge.textColor = [UIColor whiteColor];
        self.badge.badgeColor = [UIColor whiteColor];
        self.badge.outlineColor = [UIColor whiteColor];
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
