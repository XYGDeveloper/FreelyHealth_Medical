//
//  ImageTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "TaskDetailModel.h"
#import "ReferDetailModel.h"
@interface ImageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ImageTableViewCell


- (void)refreshWithModel:(NSString *)model
{
    
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.clipsToBounds = YES;
    [self.img sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
}


- (void)refreshWithModel1:(NSString *)model
{

    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.clipsToBounds = YES;
    [self.img sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];

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
