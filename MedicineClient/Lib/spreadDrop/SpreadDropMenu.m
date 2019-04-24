//
//  SpreadDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpreadDropMenu.h"

@interface SpreadDropMenu ()
@end

@implementation SpreadDropMenu


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *handleButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [handleButton1 addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    
    [handleButton1 setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:handleButton1];
    
    [handleButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        make.top.mas_equalTo(0);
        
        make.width.height.mas_equalTo(70);

    }];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.font = Font(15);
    
    label.textColor= DefaultGrayLightTextClor;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"申请转诊";
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(handleButton1.mas_bottom).mas_equalTo(-4);
        make.centerX.mas_equalTo(handleButton1.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
    }];
    
    
    
}





- (void)makeSure
{
    if (self.callback) {
        self.callback(@"点击了确定");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}


- (void)cancel
{
    if (self.callback) {
        self.callback(@"点击了取消");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}




@end
