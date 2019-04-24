//
//  DetailInfoTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DetailInfoTableViewCell.h"
#import "TaskDetailModel.h"
@interface DetailInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;


@end

@implementation DetailInfoTableViewCell


- (void)refreshWithModel:(TaskDetailModel *)model
{

    self.infoLabel.text = [NSString stringWithFormat:@"患者信息   姓名:%@, 性别:%@, 年龄:%@",model.patientname,model.patientsex,model.patientage];

//    self.telephoneLabel.text = model.patientphone;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.infoLabel.font = FontNameAndSize(16);
    
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    
    self.infoLabel.textColor = DefaultGrayLightTextClor;
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        
        make.top.mas_equalTo(0);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-5);
        
    }];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
