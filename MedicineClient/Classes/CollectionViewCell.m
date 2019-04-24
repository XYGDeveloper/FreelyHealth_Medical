//
//  CollectionViewCell.m
//  testTX
//
//  Created by hackxhj on 15/9/7.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//

#import "CollectionViewCell.h"
#import "GroupConSearchModel.h"
@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibs=[[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[CollectionViewCell class]]) {
                self =(CollectionViewCell *)obj;
                self.backgroundColor = DefaultBackgroundColor;
                
                self.tx.layer.cornerRadius = 2;
                
                self.tx.layer.masksToBounds = YES;
                
            }
        }
        
    }
    return self;
}

- (void)refreshWithModel:(GroupConSearchModel *)model
{
    
    self.mem.text = model.dusername;
    
    [self.tx sd_setImageWithURL:[NSURL URLWithString:model.dfacepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
}


@end
