//
//  GListTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GListTableViewCell.h"
#import "MyInviteModel.h"
#import "MySendModel.h"
@interface GListTableViewCell()

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *subject;

@property (nonatomic,strong)UILabel *timeLabel;

@end

@implementation GListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.name = [[UILabel alloc]init];
        
        self.name.textColor = DefaultBlackLightTextClor;
        
        self.name.textAlignment = NSTextAlignmentLeft;
        
        self.name.font = FontNameAndSize(18);
        
        [self.contentView addSubview:self.name];
        
        self.subject = [[UILabel alloc]init];
        
        self.subject.textColor = DefaultGrayLightTextClor;
        
        self.subject.textAlignment = NSTextAlignmentLeft;
        
        self.subject.font = FontNameAndSize(16);
        
        [self.contentView addSubview:self.subject];
        
        self.timeLabel = [[UILabel alloc]init];
        
        self.timeLabel.textColor = DefaultGrayLightTextClor;
        
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
        self.timeLabel.font = FontNameAndSize(14);
        
        [self.contentView addSubview:self.timeLabel];
        
    }
    
    return self;
    
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        
        make.left.mas_equalTo(20);
        
        make.width.mas_equalTo(kScreenWidth - 20- 10- 70);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(self.name.mas_left);
        make.width.mas_equalTo(self.name.mas_width);
        make.height.mas_equalTo(25);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_right);
        make.centerY.mas_equalTo(self.name.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)refreshWithModel:(MyInviteModel *)model
{
    
    self.name.text = [NSString stringWithFormat:@"会诊邀请发起人：%@",model.createuser];
    
    self.subject.text = [NSString stringWithFormat:@"会诊主题：%@",model.item];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@月%@日",[[[[model.createtime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] safeObjectAtIndex:1],[[[[model.createtime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] safeObjectAtIndex:2]];
}

-  (void)refreshWithModel1:(MySendModel *)model{
    
    NSString *isAgree;
    
    self.name.font = FontNameAndSize(16);
    
    if ([model.canyu isEqualToString:@"Y"]) {
        isAgree = @"同意了";
    }else{
        isAgree = @"拒绝了";
    }
    if ([model.createuser isEqualToString:[User LocalUser].name]) {
        self.name.text = [NSString stringWithFormat:@"你%@ %@ 的会诊请求",isAgree,model.createuser];
    }else{
        self.name.text = [NSString stringWithFormat:@"%@ %@你的会诊请求",model.dusername,isAgree];
    }
    
    self.subject.text = [NSString stringWithFormat:@"会诊主题：%@",model.item];

    self.timeLabel.text = [NSString stringWithFormat:@"%@月%@日",[[[[model.canyutime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] safeObjectAtIndex:1],[[[[model.canyutime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] safeObjectAtIndex:2]];
    
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
