//
//  PhotoImgTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhotoImgTableViewCell.h"
#import "MyProfilwModel.h"
@interface PhotoImgTableViewCell()


@property (weak, nonatomic) IBOutlet UIButton *del1;

@property (weak, nonatomic) IBOutlet UIButton *del2;


@end

@implementation PhotoImgTableViewCell


- (void)refreshWithModel:(MyProfilwModel *)model
{

    self.del1.hidden = YES;
    
    self.del2.hidden = YES;

    [self.firPth sd_setImageWithURL:[NSURL URLWithString:model.certification] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
    [self.sedPh sd_setImageWithURL:[NSURL URLWithString:model.workcard] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
    
}


- (void)refreshWithUpdateModel:(MyProfilwModel *)model
{
    
    [self.firPth sd_setImageWithURL:[NSURL URLWithString:model.certification] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
    [self.sedPh sd_setImageWithURL:[NSURL URLWithString:model.workcard] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];

}



- (IBAction)delAction:(id)sender {
    
    
    [self.firPth sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
    
}


- (IBAction)del2:(id)sender {
    
    [self.sedPh sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"]];
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firPth.userInteractionEnabled  = YES;
    self.sedPh.userInteractionEnabled = YES;
    
    [self.firPth addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePic1)]];
    
     [self.sedPh addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePic2)]];
    // Initialization code
}

- (void)changePic1{

    if (self.pic1) {
        
        self.pic1();
    }
    
}

- (void)changePic2{

    if (self.pic2) {
        
        self.pic2();
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
