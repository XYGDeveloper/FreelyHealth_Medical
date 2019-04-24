//
//  TeamListTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamListTableViewCell.h"
#import "MyTeamModel.h"
#import "UIView+AnimationProperty.h"
@interface TeamListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jopLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;


@end

@implementation TeamListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = 55/2;
    
    self.headImg.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)refreshWithModel:(memberModel *)model
{
    weakify(self);
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.facepath]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            strongify(self);
                            self.headImg.image = image;
                            self.headImg.alpha = 0;
                            self.headImg.scale = 1.1f;
                            [UIView animateWithDuration:0.5f animations:^{
                                self.headImg.alpha = 1.f;
                                self.headImg.scale = 1.f;
                            }];
                        }];
    self.nameLabel.text = model.name;
    
    if (!model.hname) {
        self.jopLabel.text = [NSString stringWithFormat:@"%@",model.job];
    }else{
        self.jopLabel.text = [NSString stringWithFormat:@"%@ %@",model.hname,model.job];
    }
    
//    self.introLabel.text = model.introduction;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
