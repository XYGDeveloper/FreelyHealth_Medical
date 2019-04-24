//
//  TaskTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "MyTaskModel.h"

@interface TaskTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *PatientInfo;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end


@implementation TaskTableViewCell


- (IBAction)scanDetaiAction:(id)sender {
    
    if (self.block) {
    
        self.block();
        
    }
    
}

- (void)refreshwithModel:(MyTaskModel *)model
{
    
    NSString *str = [NSString stringWithFormat:@"来自%@-%@的转诊",model.createuser,model.createhospital];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:FontNameAndSize(16)
     
                          range:NSMakeRange(0, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:DefaultGrayLightTextClor
     
                          range:NSMakeRange(0, 2)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:FontNameAndSize(16)
     
                          range:NSMakeRange(str.length - 3, 3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:DefaultGrayLightTextClor
     
                          range:NSMakeRange(str.length - 3, 3)];
    
    self.taskTypeLabel.attributedText = AttributedStr;
    
    self.PatientInfo.text = model.createtime;

    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)refreshwithModel1:(MyTaskModel *)model{
    
    self.taskTypeLabel.text = @"转诊任务";
    
    self.PatientInfo.text = [NSString stringWithFormat:@"患者信息  姓名:%@   性别:%@   年龄:%@岁",model.patientname,model.patientsex,model.patientage];
    
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
      
        [self.PatientInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.taskTypeLabel.mas_left);
            make.width.mas_equalTo(self.taskTypeLabel.mas_width);
            make.top.mas_equalTo(self.taskTypeLabel.mas_bottom).mas_equalTo(5);
            make.height.mas_equalTo(self.taskTypeLabel.mas_height);
        }];
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
