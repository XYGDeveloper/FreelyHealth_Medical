//
//  LoginOutTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "LoginOutTableViewCell.h"

@interface LoginOutTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end


@implementation LoginOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loginButton.layer.cornerRadius = 8;
    
    self.loginButton.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)refreshWith:(BOOL)loginOut
{

    if (loginOut == YES) {
        
        self.loginButton.hidden = NO;
        
    }else{
    
        self.loginButton.hidden = YES;

    }


}



- (IBAction)loginOutAction:(id)sender {
    
    if (self.loginOutAc) {
        
        self.loginOutAc();
        
    }
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
