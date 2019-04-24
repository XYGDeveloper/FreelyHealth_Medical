//
//  AllCollectionViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/12/10.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AllCollectionViewCell.h"
@interface AllCollectionViewCell()

@end

@implementation AllCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.headImage =[[UIImageView alloc]init];
        
        self.headImage.layer.cornerRadius = 2;
        
        self.headImage.layer.masksToBounds = YES;
        
        self.headImage.backgroundColor = AppStyleColor;
        
        [self.contentView addSubview:self.headImage];
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(60);
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.nameLabel];
        
        self.nameLabel.textColor = DefaultGrayLightTextClor;
        
        self.nameLabel.font = FontNameAndSize(14);
        
        self.nameLabel.text = @"王佳琪";
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
            
        }];
        
    }
    
    return self;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

@end
