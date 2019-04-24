//
//  AppionmentMessageListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentMessageListTableViewCell.h"
#import "MyMessageModel.h"
@implementation AppionmentMessageListTableViewCell

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@"message_notice"];
    }
    return _headImage;
}
- (UILabel *)messageNameLabel{
    if (!_messageNameLabel) {
        _messageNameLabel = [[UILabel alloc]init];
        _messageNameLabel.textAlignment = NSTextAlignmentLeft;
        _messageNameLabel.textColor = DefaultBlackLightTextClor;
        _messageNameLabel.font = Font(16);
    }
    return _messageNameLabel;
}

- (UILabel *)messageContentLabel{
    if (!_messageContentLabel) {
        _messageContentLabel = [[UILabel alloc]init];
        _messageContentLabel.textAlignment = NSTextAlignmentLeft;
        _messageContentLabel.font = FontNameAndSize(15);
        _messageContentLabel.textColor = DefaultGrayTextClor;
        _messageContentLabel.numberOfLines = 0;
    }
    return _messageContentLabel;
}
- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = FontNameAndSize(10);
        _badgeLabel.layer.cornerRadius = 6;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.textColor = [UIColor whiteColor];
    }
    return _badgeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = FontNameAndSize(15);
        _timeLabel.textColor = DefaultGrayTextClor;
    }
    return _timeLabel;
}



- (void)layOut{
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(25);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(-10.5);
        make.bottom.mas_equalTo(self.headImage.mas_top).mas_equalTo(10.5);
    }];
    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImage.mas_centerY);
        make.width.mas_equalTo(120);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
    }];
    
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.messageNameLabel.mas_bottom).mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.messageNameLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(self.messageNameLabel.mas_right);
        make.height.mas_equalTo(15);
    }];
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.messageNameLabel];
        [self.contentView addSubview:self.messageContentLabel];
        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.timeLabel];

        [self layOut];
    }
    return self;
}

- (void)refreshWithMessageModel:(MyMessageModel *)model{
    self.messageNameLabel.text = @"会诊消息";
    self.messageContentLabel.text = model.msg;
    if ([model.status isEqualToString:@"0"]) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
        self.badgeLabel.hidden = YES;
        self.badgeLabel.backgroundColor = [UIColor clearColor];
    }
    self.timeLabel.text = [Utils formateDate:model.createtime];
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
