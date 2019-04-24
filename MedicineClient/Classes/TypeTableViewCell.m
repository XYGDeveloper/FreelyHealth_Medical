//
//  TypeTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TypeTableViewCell.h"

#import "TeamDetalModel.h"

@interface TypeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *goodCount;

@property (weak, nonatomic) IBOutlet UILabel *auswerCount;

@end

@implementation TypeTableViewCell

- (void)refreshWirthModel:(TeamDetalModel *)model
{
    
    self.goodCount.text = model.agreenum;
    
    self.auswerCount.text = model.backnum;
    
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
