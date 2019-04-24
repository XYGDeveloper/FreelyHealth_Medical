//
//  VersionAlertView.h
//  LeYiZhu-iOS
//
//  Created by L on 2017/7/4.
//  Copyright © 2017年 lyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface VersionAlertView : UIView

/** 弹窗 */
@property(nonatomic,retain) UIView *alertView;
/** title */
@property(nonatomic,retain) UIImageView *titleLbl;
/** 内容 */
@property(nonatomic,retain) UILabel *msgLbl;
/** 确认按钮 */
@property(nonatomic,retain) UIButton *sureBtn;
/** 取消按钮 */
@property(nonatomic,retain) UIButton *cancleBtn;
/** 横线 */
@property(nonatomic,retain) UIView *lineView;
/** 竖线 */
@property(nonatomic,retain) UIView *verLineView;

@property(nonatomic,retain) UIView *buttonBg;


/**  */
@property(nonatomic,copy) AlertResult resultIndex;

-(instancetype)initWithTitle:(UIImage *)image message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(UIImage *)cancleTitle;


-(void)showMKPAlertView;



@end
