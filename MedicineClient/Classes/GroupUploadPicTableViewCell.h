//
//  GroupUploadPicTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/11/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXPhotoView.h"

typedef void (^selectArr)(NSArray *arr);

@interface GroupUploadPicTableViewCell : UITableViewCell

@property (nonatomic,strong)selectArr select;

@property (strong, nonatomic) HXPhotoView *onePhotoView;

@property (strong, nonatomic) HXPhotoManager *oneManager;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *arr;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withApp:(NSArray *)arr;
@end
