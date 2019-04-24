//
//  WailtToPayNoticeTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WailtToPayNoticeTableViewCell.h"
#import "HZListDetailModel.h"
@interface WailtToPayNoticeTableViewCell()
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UILabel *notice;
@property (nonatomic,strong)UILabel *attend;
@property (nonatomic,strong)UILabel *stateButton;

@end

@implementation WailtToPayNoticeTableViewCell
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.textColor = DefaultGrayLightTextClor;
        _time.font = FontNameAndSize(16);
    }
    return _time;
}
- (UILabel *)notice{
    if (!_notice) {
        _notice = [[UILabel alloc]init];
        _notice.textAlignment = NSTextAlignmentLeft;
        _notice.textColor = DefaultGrayLightTextClor;
        _notice.font = FontNameAndSize(16);
    }
    return _notice;
}
- (UILabel *)attend{
    if (!_attend) {
        _attend = [[UILabel alloc]init];
        _attend.textAlignment = NSTextAlignmentLeft;
        _attend.textColor = DefaultGrayLightTextClor;
        _attend.font = FontNameAndSize(16);
    }
    return _attend;
}

- (UILabel *)stateButton{
    if (!_stateButton) {
        _stateButton = [[UILabel alloc]init];
        _stateButton.textAlignment = NSTextAlignmentRight;
        _stateButton.textColor = DefaultGrayLightTextClor;
        _stateButton.font = FontNameAndSize(16);
    }
    return _stateButton;
}

- (void)layOut{
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(15);
    }];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.time.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(80);
    }];
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.time.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.attend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.notice.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.notice];
        [self.contentView addSubview:self.attend];
        [self.contentView addSubview:self.stateButton];
        [self layOut];
    }
    return self;
}

- (void)refreshWithAppionmentDetailModel:(HZListDetailModel *)model{
    _time.text = [NSString stringWithFormat:@"时    间：%@",[Utils timeFormatterWithTimeString:model.huizhentime]];
    _notice.text = @"提    醒：提前1个小时  应用内";
    _attend.text = [NSString stringWithFormat:@"%@ | %@",model.faqiname,[Utils timeFormatterWithTimeString:model.starttime]];
    if ([model.status isEqualToString:@"2"]) {
        self.stateButton.text = @"已取消";
    }else if ([model.status isEqualToString:@"3"]){
        self.stateButton.text = @"已完成";
    }else{
        self.stateButton.text = @"";
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
