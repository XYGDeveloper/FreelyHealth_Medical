//
//  SelectHospitalTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectHospitalTableViewCell.h"
#import "JopModel.h"
@interface SelectHospitalTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *hostitalLabel;

@end

@implementation SelectHospitalTableViewCell

- (void)refreshWithModel:(JopModel *)model
{
    if (model.hname && model.name) {
        
        self.hostitalLabel.text = [NSString stringWithFormat:@"%@ | %@",model.name,model.hname];

    }else{
        
        self.hostitalLabel.text = [NSString stringWithFormat:@"%@",model.name];

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
