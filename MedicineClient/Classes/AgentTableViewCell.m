//
//  AgentTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentTableViewCell.h"
#import "AgentModel.h"
@interface AgentTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *agentType;

@property (weak, nonatomic) IBOutlet UILabel *agentInfo;

@property (weak, nonatomic) IBOutlet UILabel *agentTime;



@end


@implementation AgentTableViewCell


- (IBAction)detailAction:(id)sender {
    
    if (self.block) {
        
        self.block();
        
    }
    
}


- (void)refreshWithModel:(AgentModel *)model
{

    self.agentType.text = [NSString stringWithFormat:@"%@(%@/%@)",model.goodname,model.itemno,model.itemssum];

    self.agentInfo.text = [NSString stringWithFormat:@"服务对象：%@(%@)",model.patientname,model.patientphone];
    
    self.agentTime.text = [NSString stringWithFormat:@"服务时间：%@",model.worktime];

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
