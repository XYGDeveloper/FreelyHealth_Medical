//
//  TargetTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/10/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TargetTableViewCell.h"
#import "ReferDetailModel.h"
@interface TargetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *targetTitle;

@property (weak, nonatomic) IBOutlet UILabel *targetContent;

@end

@implementation TargetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.targetTitle.textAlignment = NSTextAlignmentLeft;
    
    self.targetTitle.textColor = [UIColor blackColor];
    
    self.targetContent.textAlignment = NSTextAlignmentLeft;
    
    self.targetContent.textColor = DefaultGrayLightTextClor;
    
    [self.targetTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        
        make.top.mas_equalTo(0);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(30);
        
    }];
    
    [self.targetContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.targetTitle.mas_right);
        
        make.top.mas_equalTo(5);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-5);
        
    }];
    
    
}

- (void)refreshWithModel:(ReferDetailModel *)model
{

    self.targetTitle.text = @"转诊目标";

    if ([model.targethospital isEqualToString:@"待后台分配"]) {
        
        model.targethospital = @"";
        
    }
    
    self.targetContent.text = [NSString stringWithFormat:@"%@  %@",model.target,model.targethospital];

    
}

- (void)refreshWithModel1:(ReferDetailModel *)model
{
    
    self.targetTitle.text = @"患者信息";
    
    self.targetContent.text = [NSString stringWithFormat:@"%@,%@，%@岁",model.patientname,model.patientsex,model.patientage];
    
}



@end
