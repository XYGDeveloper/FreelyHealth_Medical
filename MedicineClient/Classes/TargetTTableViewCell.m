//
//  TargetTTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/10/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TargetTTableViewCell.h"
#import "ReferDetailModel.h"

@interface TargetTTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetContent;

@property (weak, nonatomic) IBOutlet UILabel *title1Label;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;


@end


@implementation TargetTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.targetLabel.textColor = DefaultBlackLightTextClor;
    
    self.title1Label.textColor = DefaultBlackLightTextClor;

    self.targetContent.textColor = DefaultGrayLightTextClor;

    self.labelContent.textColor = DefaultGrayLightTextClor;
                              
    [self.targetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                                  
        make.left.mas_equalTo(8);

    }];
    [self.title1Label mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
    }];
    
}

- (void)refreshWithModel:(ReferDetailModel *)model
{
    
    if ([model.status isEqualToString:@"2"]) {
        
        self.targetLabel.text = @"转诊目标";
        
        self.title1Label.text = @"接受时间";
        
        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
        
        self.labelContent.text = model.accepttime;
        
    }else if ([model.status isEqualToString:@"3"])
    {
        
        self.targetLabel.text = @"完成医生";
        
        self.title1Label.text = @"完成时间";
        
        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
        
        self.labelContent.text = model.finishtime;
        
        
    }else if ([model.status isEqualToString:@"4"])
    {
        
        self.targetLabel.text = @"转诊目标";
        
        self.title1Label.text = @"拒绝时间";
        
        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
        
        self.labelContent.text = model.refusetime;
        
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
