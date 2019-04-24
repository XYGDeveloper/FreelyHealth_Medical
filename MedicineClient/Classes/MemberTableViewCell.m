//
//  MemberTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "ConditionTeamModel.h"
@interface MemberTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *hname;


@end

@implementation MemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.shadowColor = DefaultGrayLightTextClor.CGColor;//shadowColor阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.bgView.layer.shadowRadius = 1;//阴影半径，默认3
    self.bgView.backgroundColor = [UIColor whiteColor];

    // Initialization code
}


- (void)refreshWithModel:(MemberModel *)model
{

    self.name.text = model.name;
    
    self.hname.text = [NSString stringWithFormat:@"%@:%@",model.hname,model.job];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
