//
//  PhotoImgTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyProfilwModel;

typedef void (^modififyPic1)();

typedef void (^modififyPic2)();


@interface PhotoImgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *firPth;

@property (weak, nonatomic) IBOutlet UIImageView *sedPh;

@property (nonatomic,strong)modififyPic1 pic1;

@property (nonatomic,strong)modififyPic2 pic2;


- (void)refreshWithModel:(MyProfilwModel *)model;

- (void)refreshWithUpdateModel:(MyProfilwModel *)model;

@end
