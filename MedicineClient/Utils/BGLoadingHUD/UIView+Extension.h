//
//  UIView+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
/**
 *  x方向最大值(控件不超出右侧边界为前提)
 */
@property(assign, nonatomic) CGFloat maxX;
/**
 *  y方向最大值（控件不超出下编辑为前提）
 */
@property(assign, nonatomic) CGFloat maxY;
@end
