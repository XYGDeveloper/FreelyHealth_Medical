//
//  DetailTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DetailTableViewCell.h"

#import "MyProfilwModel.h"
@interface DetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *introLabel;



@end


@implementation DetailTableViewCell


- (void)refreshWirthModel:(MyProfilwModel *)model
{

    self.introLabel.text = model.introduction;
    
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
