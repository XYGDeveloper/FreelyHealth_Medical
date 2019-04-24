//
//  MyGroupListTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/12/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyGroupListTableViewCell.h"
#import "MyGroupListModel.h"
#import "MySendModel.h"
@interface MyGroupListTableViewCell()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *themeLabel;

@property (nonatomic,strong)UILabel *timeLabel;

@end

@implementation MyGroupListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.nameLabel  = [[UILabel alloc]init];
        
        self.nameLabel.textColor = DefaultBlackLightTextClor;
        
        self.nameLabel.font = FontNameAndSize(16);
        
        self.nameLabel.text = @"会诊任务";
        
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(25);
        }];
        
        self.themeLabel  = [[UILabel alloc]init];
        
        self.themeLabel.textColor = DefaultGrayLightTextClor;
        
        self.themeLabel.font = FontNameAndSize(15);

        self.themeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:self.themeLabel];
        
        [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(25);
            
        }];
        
        self.timeLabel = [[UILabel alloc]init];
        
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabel.font = FontNameAndSize(14);
        
        self.timeLabel.textColor = DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.top.mas_equalTo(self.themeLabel.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(20);
        }];
    }
    
    return self;
}

- (void)refreshWithModel:(MyGroupListModel *)model{
    
    self.themeLabel.text = [NSString stringWithFormat:@"会诊主题：%@",model.item];
    
    self.timeLabel.text = model.createtime;
    
}

- (void)refreshWithModel1:(MySendModel *)model{
    self.themeLabel.text = [NSString stringWithFormat:@"会诊主题：%@",model.item];
    self.timeLabel.text = model.createtime;
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
