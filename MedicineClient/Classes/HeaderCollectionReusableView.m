//
//  HeaderCollectionReusableView.m
//  MedicineClient
//
//  Created by xyg on 2017/12/10.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
       
        self.headLabel = [[UILabel alloc]init];
        
        self.headLabel.textColor = DefaultGrayTextClor;
        
        self.headLabel.font = FontNameAndSize(18);
        
        [self addSubview:self.headLabel];
        
        self.headLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jump)];;
        
        [self.headLabel addGestureRecognizer:tap];
        
        [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }
    
    return self;
    
}

- (void)jump{
    
    if (self.eve) {
        
        self.eve();
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
