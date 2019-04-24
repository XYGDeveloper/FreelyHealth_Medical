//
//  ImgProfileTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/2/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ImgProfileTableViewCell.h"

@interface ImgProfileTableViewCell()

@end

@implementation ImgProfileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
                self.imageSide = [[UIImageView alloc]init];
                self.imageSide.contentMode = UIViewContentModeScaleAspectFill;
                self.imageSide.clipsToBounds = YES;
                self.imageSide.userInteractionEnabled = YES;
                [self.contentView addSubview:self.imageSide];
                [self.imageSide addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic1)]];
                [self.imageSide mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.top.mas_equalTo(10);
                    make.height.mas_equalTo(100);
                    make.width.mas_equalTo((kScreenWidth-48)/2);
                }];
        //
                self.imageOther = [[UIImageView alloc]init];
                self.imageOther.contentMode = UIViewContentModeScaleAspectFill;
                self.imageOther.clipsToBounds = YES;
                self.imageOther.userInteractionEnabled = YES;
        
                [self.contentView addSubview:self.imageOther];
        
                [self.imageOther addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic2)]];
        
                [self.imageOther mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.imageSide.mas_right).mas_equalTo(16);
                    make.top.mas_equalTo(10);
                    make.height.mas_equalTo(100);
                    make.width.mas_equalTo(self.imageSide.mas_width);
                }];
        //
                UILabel *imageSideLabel = [[UILabel alloc]init];
                imageSideLabel.textColor = DefaultGrayTextClor;
                imageSideLabel.font = Font(16);
                imageSideLabel.text = @"医师资格证";
                imageSideLabel.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:imageSideLabel];
                [imageSideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.imageSide.mas_bottom).mas_equalTo(10);
                    make.centerX.mas_equalTo(self.imageSide.mas_centerX);
                    make.width.mas_equalTo(120);
                    make.height.mas_equalTo(30);
                }];
        //
                UILabel *imageOtherSideLabel = [[UILabel alloc]init];
                imageOtherSideLabel.textColor = DefaultGrayTextClor;
                imageOtherSideLabel.font = Font(16);
                imageOtherSideLabel.text = @"工作牌";
                imageOtherSideLabel.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:imageOtherSideLabel];
                [imageOtherSideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.imageOther.mas_bottom).mas_equalTo(10);
                    make.centerX.mas_equalTo(self.imageOther.mas_centerX);
                    make.width.mas_equalTo(120);
                    make.height.mas_equalTo(30);
                }];
        
    }
    return self;
}

- (void)addPic1{
    if (self.leftimage) {
        self.leftimage();
    }
}

- (void)addPic2{
    if (self.rightimage) {
        self.rightimage();
    }
}

- (void)setTypeleftImage:(NSString *)letimg rightImg:(NSString *)rightImg{
        [self.imageSide sd_setImageWithURL:[NSURL URLWithString:letimg] placeholderImage:[UIImage imageNamed:@"111.jpg"]];
        [self.imageOther sd_setImageWithURL:[NSURL URLWithString:rightImg] placeholderImage:[UIImage imageNamed:@"111.jpg"]];
}


@end
