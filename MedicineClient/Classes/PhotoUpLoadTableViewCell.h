//
//  PhotoUpLoadTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXPhotoView.h"

static const CGFloat kPhotoViewMargin = 12.0;

typedef void (^selectArr)(NSArray *arr);

@interface PhotoUpLoadTableViewCell : UITableViewCell

@property (nonatomic,strong)selectArr select;

@property (strong, nonatomic) HXPhotoView *onePhotoView;

@property (strong, nonatomic) HXPhotoManager *oneManager;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *arr;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withApp:(NSArray *)arr;

@end
