//
//  DetailDesTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DetailDesTableViewCell.h"
#import "TaskDetailModel.h"
#import "ReferDetailModel.h"
@interface DetailDesTableViewCell()

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UILabel *infoLabel;

@end

@implementation DetailDesTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        self.infoLabel = [[UILabel alloc]init];
        
        self.infoLabel.numberOfLines = 0;
        
        self.infoLabel.font = FontNameAndSize(16);
        
        self.infoLabel.textAlignment = NSTextAlignmentLeft;
        
        self.infoLabel.textColor = DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.infoLabel];
    
        [self layOut];
        
    }
    
    return self;
    
    

}


- (void)layOut{


    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        
        make.top.mas_equalTo(0);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-5);
        
    }];

}


- (void)refreshWithModel:(TaskDetailModel *)model
{

    self.infoLabel.text = [NSString stringWithFormat:@"详情描述     %@",model.des];
    
}


-(void)refreshWithreferModel:(ReferDetailModel *)model
{

    self.infoLabel.text = [NSString stringWithFormat:@"详情描述     %@",model.des];

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
