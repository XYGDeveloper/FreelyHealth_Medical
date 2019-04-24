//
//  ReferDesTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReferDesTableViewCell.h"
#import "ReferDetailModel.h"

@interface ReferDesTableViewCell()

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UILabel *infoLabel;

@end

@implementation ReferDesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.infoLabel = [[UILabel alloc]init];
        
        self.infoLabel.numberOfLines = 0;

        self.infoLabel.font = FontNameAndSize(16);
        
        self.infoLabel.textAlignment = NSTextAlignmentLeft;
        
        self.infoLabel.textColor = DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.infoLabel];
        
        self.label = [[UILabel alloc]init];
        
        self.label.numberOfLines = 0;
        
        self.label.font = FontNameAndSize(16);
        
        self.label.textAlignment = NSTextAlignmentLeft;
        
        self.label.textColor = DefaultBlackLightTextClor;
        
        [self.contentView addSubview:self.label];
        
        [self layOut];
        
    }
    
    return self;
    
    
    
}


- (void)layOut{
    
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        
        make.top.mas_equalTo(0);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(30);
        
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.label.mas_right);
        
        make.top.mas_equalTo(5);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-5);
        
    }];
    
}


-(void)refreshWithreferModel:(ReferDetailModel *)model
{
    
    self.label.text  =@"详情描述";
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@",model.des];
    
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
