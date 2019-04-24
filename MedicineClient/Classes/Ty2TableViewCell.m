//
//  Ty2TableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/10/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "Ty2TableViewCell.h"
#import "ReferDetailModel.h"

@interface Ty2TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *reMach;
@property (weak, nonatomic) IBOutlet UILabel *remachContent;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *timeContent;

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UILabel *infoContent;

@property (weak, nonatomic) IBOutlet UIView *sepLine;

@end

@implementation Ty2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.reMach.textColor = DefaultBlackLightTextClor;
    self.time.textColor = DefaultBlackLightTextClor;
    self.info.textColor = DefaultBlackLightTextClor;

    self.remachContent.textColor = DefaultGrayTextClor;

    self.timeContent.textColor = DefaultGrayTextClor;

    self.infoContent.textColor = DefaultGrayTextClor;
    self.sepLine.backgroundColor = DefaultBackgroundColor;
    
    [self.reMach mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        
    }];
    
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
    }];
    [self.info mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
    }];
    
    
}


- (void)refreshWithModel:(ReferDetailModel *)model
{
    
            self.reMach.text = @"拒绝医生";
    
            self.time.text = @"拒绝时间";
    
            self.info.text = @"患者信息";

            self.remachContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
    
            self.timeContent.text = model.refusetime;
    
            self.infoContent.text = [NSString stringWithFormat:@"%@, %@，%@岁",model.patientname,model.patientsex,model.patientage];

//    if ([model.status isEqualToString:@"2"]) {
//        
//        self.targetLabel.text = @"转诊目标";
//        
//        self.title1Label.text = @"接受时间";
//        
//        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
//        
//        self.labelContent.text = model.accepttime;
//        
//    }else if ([model.status isEqualToString:@"3"])
//    {
//        
//        self.targetLabel.text = @"完成医生";
//        
//        self.title1Label.text = @"完成时间";
//        
//        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
//        
//        self.labelContent.text = model.finishtime;
//        
//        
//    }else if ([model.status isEqualToString:@"4"])
//    {
//        
//        self.targetLabel.text = @"转诊目标";
//        
//        self.title1Label.text = @"拒绝时间";
//        
//        self.targetContent.text = [NSString stringWithFormat:@"%@,%@",model.target,model.targethospital];
//        
//        self.labelContent.text = model.refusetime;
//        
//    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
