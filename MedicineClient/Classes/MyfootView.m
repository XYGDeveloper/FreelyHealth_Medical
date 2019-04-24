//
//  MyfootView.m
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyfootView.h"

@implementation MyfootView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = DefaultBackgroundColor;
        
        self.addEve = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:self.addEve];
        
        self.delEve = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self  addSubview:self.delEve];
        
        self.addEve.layer.cornerRadius = 2;
        
        self.delEve.layer.cornerRadius = 2;
        
        self.addEve.layer.masksToBounds = YES;
        
        self.delEve.layer.masksToBounds = YES;
        
        [self.addEve mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(16);
            
            make.top.mas_equalTo(0);
            
            make.width.mas_equalTo(45);
            
            make.height.mas_equalTo(45);
            
        }];
        
        [self.delEve mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.addEve.mas_right).mas_equalTo(16);
            
            make.top.mas_equalTo(0);
            
            make.width.mas_equalTo(45);
            
            make.height.mas_equalTo(45);
        }];
        
        [self.addEve setBackgroundImage:[UIImage imageNamed:@"adduser"] forState:UIControlStateNormal];
        
        [self.delEve setBackgroundImage:[UIImage imageNamed:@"subuser"] forState:UIControlStateNormal];

        [self.addEve addTarget:self action:@selector(addM) forControlEvents:UIControlEventTouchUpInside];
        [self.delEve addTarget:self action:@selector(jianM) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
    
}

- (void)addM{
    
    if (self.add) {
        self.add();
    }
}



- (void)jianM{
    
    if (self.mul) {
        self.mul();
    }
}

@end
