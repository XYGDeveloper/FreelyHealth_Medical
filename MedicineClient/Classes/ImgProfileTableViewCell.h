//
//  ImgProfileTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/2/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^changeLeftImg)();
typedef void (^changeRightImg)();
@interface ImgProfileTableViewCell : UITableViewCell
@property (nonatomic,strong)changeLeftImg leftimage;
@property (nonatomic,strong)changeRightImg rightimage;
@property (nonatomic,strong)UIImageView *imageSide;
@property (nonatomic,strong)UIImageView *imageOther;
- (void)setTypeleftImage:(NSString *)letimg
        rightImg:(NSString *)rightImg;
@end
