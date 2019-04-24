//
//  AgentDetailTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentDetailTableViewCell.h"
#import "AgentDetailModel.h"
@interface AgentDetailTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *stepNum;


@property (weak, nonatomic) IBOutlet UILabel *stepDes;

@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UIImageView *stepBg;


@property (weak, nonatomic) IBOutlet UIButton *SelButton;



@end


@implementation AgentDetailTableViewCell


- (void)refreshWithModel:(itemModel *)model
{

    if ([model.id isEqualToString:@"1"]) {
        
        self.line.hidden = YES;
    }else{
    
        self.line.hidden = NO;
    }
    
    self.line.backgroundColor = AppStyleColor;
    
    if ([model.finish isEqualToString:@"Y"]) {
        
        self.SelButton.selected = YES;
        
        self.SelButton.userInteractionEnabled = NO;
        
        
        
    }else{
    
        self.SelButton.selected = NO;

        self.SelButton.userInteractionEnabled = YES;

    }
    
    self.stepBg.image = [UIImage imageNamed:@"step_nifinish"];
    
    self.stepNum.text = model.no;
    
    self.stepDes.text = model.name;
    
    
}


- (IBAction)senAc:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.action) {
        
        self.action();
        
    }
    
}


@end
