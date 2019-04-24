//
//  CollectionViewCell.h
//  testTX
//
//  Created by hackxhj on 15/9/7.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupConSearchModel;

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mem;
@property (weak, nonatomic) IBOutlet UIImageView *tx;

- (void)refreshWithModel:(GroupConSearchModel *)model;


@end
