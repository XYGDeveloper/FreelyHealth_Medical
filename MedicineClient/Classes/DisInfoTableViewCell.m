//
//  DisInfoTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DisInfoTableViewCell.h"

#import "ReferDetailModel.h"

@interface DisInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UILabel *desContent;

@end

@implementation DisInfoTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.des.textAlignment = NSTextAlignmentLeft;
    
    self.des.textColor = [UIColor blackColor];
   
    
    self.desContent.textAlignment = NSTextAlignmentLeft;
    
    self.desContent.textColor = DefaultGrayLightTextClor;
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        
        make.top.mas_equalTo(0);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(30);
        
    }];
    
    [self.desContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.des.mas_right);
        
        make.top.mas_equalTo(5);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-5);
        
    }];
    
    
    // Initialization code
}

- (void)refreshWithModel1:(ReferDetailModel *)model
{
    
    self.des.text = @"患者信息";
    
    self.desContent.text = [NSString stringWithFormat:@"姓名：%@，性别：%@，年龄：%@岁",model.patientname,model.patientsex,model.patientage];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
