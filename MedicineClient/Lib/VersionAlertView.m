//
//  VersionAlertView.m
//  LeYiZhu-iOS
//
//  Created by L on 2017/7/4.
//  Copyright © 2017年 lyz. All rights reserved.
//

#import "VersionAlertView.h"
// AlertW 宽
#define AlertW SCREEN_WIDTH- 40
// 各个栏目之间的距离
#define MKPSpace 10.0
#import <Masonry.h>
@interface VersionAlertView()

@property (nonatomic,strong)UIView *imgv;



@end


@implementation VersionAlertView

-(instancetype)initWithTitle:(UIImage *)image message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(UIImage *)cancleTitle{
    
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.97f;
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = [UIColor clearColor];
        self.alertView.layer.cornerRadius = 5.0;
        self.alertView.frame = CGRectMake(20, 0, kScreenWidth- 40, kScreenHeight/2);
        self.alertView.layer.position = self.center;
        
        if(image)
        {
            
            self.titleLbl = [[UIImageView alloc]initWithFrame:CGRectMake(0,50, kScreenWidth - 40, 100)];
            self.titleLbl.image = [UIImage imageNamed:@"versionbg"];
            [self.titleLbl setContentMode:UIViewContentModeScaleAspectFit];
            self.titleLbl.backgroundColor = [UIColor colorWithRed:253/255.0 green:241/255.0 blue:240/255.0 alpha:1.0f];
            [self.alertView addSubview:self.titleLbl];
            UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,1,kScreenWidth - 40,100) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(6,6)];//圆角大小
            CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
            maskLayer1.path = maskPath1.CGPath;
            self.titleLbl.layer.mask = maskLayer1;
            self.titleLbl.layer.borderColor = [UIColor whiteColor].CGColor;
            self.titleLbl.layer.borderWidth = 0.0f;
            UIImageView *imageCor = [[UIImageView alloc]init];
            
            imageCor.image = [UIImage imageNamed:@"Imagecor"];
            
            imageCor.layer.cornerRadius = 50;
            
            imageCor.layer.masksToBounds = YES;
            
            [self.alertView addSubview:imageCor];
            
            [imageCor mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(0);
                
                make.centerX.mas_equalTo(self.alertView.mas_centerX);
                
                make.width.height.mas_equalTo(100);
                
            }];
            
            self.imgv = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLbl.frame), kScreenWidth - 40,15)];
            self.imgv.backgroundColor = [UIColor whiteColor];
            self.imgv.layer.borderColor = [UIColor whiteColor].CGColor;
            self.imgv.layer.borderWidth = 1.0f;
            [self.alertView addSubview:self.imgv];
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(0, CGRectGetMaxY(self.imgv.frame)-1, kScreenWidth - 40, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentLeft;
            self.msgLbl.backgroundColor = [UIColor whiteColor];
            [self.alertView addSubview:self.msgLbl];
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.frame = self.titleLbl?CGRectMake(0, CGRectGetMaxY(self.imgv.frame)-1, kScreenWidth - 40, msgH):CGRectMake((kScreenWidth - 40-msgW)/2,0, msgW, msgH);
            
        }
        
//        self.lineView = [[UIView alloc] init];
//        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame), AlertW, 0):CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame), AlertW, 0);
//        self.lineView.backgroundColor = [UIColor whiteColor];
//        [self.alertView addSubview:self.lineView];
        
        self.buttonBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame), kScreenWidth - 40, 80)];
        self.buttonBg.backgroundColor = [UIColor whiteColor];
        [self.alertView addSubview:self.buttonBg];
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,-1,kScreenWidth - 40,80) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(6,6)];//圆角大小
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.path = maskPath1.CGPath;
        self.buttonBg.layer.mask = maskLayer1;
        self.buttonBg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.buttonBg.layer.borderWidth = 1.0f;
        //两个按钮
    
//        if (cancleTitle && sureTitle) {
//            self.verLineView = [[UIView alloc] init];
//            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame), 1, 40);
//            self.verLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
//            [self.alertView addSubview:self.verLineView];
//        }
        
        if(sureTitle && cancleTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            // 改颜色
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:5];
            self.sureBtn.backgroundColor = AppStyleColor;
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.sureBtn.layer.cornerRadius = 4.0f;
            self.sureBtn.layer.masksToBounds = YES;
            
            [self.alertView addSubview:self.sureBtn];
            
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.buttonBg.mas_centerY);
                make.centerX.mas_equalTo(self.buttonBg.mas_centerX);
                make.width.mas_equalTo(kScreenWidth- 60);
                make.height.mas_equalTo(50);
            }];
            
            
        }
        
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(CGRectGetMidX(self.buttonBg.frame)-20, CGRectGetMaxY(self.buttonBg.frame) + 25, 40, 40);
            self.cancleBtn.backgroundColor = [UIColor whiteColor];
            self.cancleBtn.layer.cornerRadius = 20;
            self.cancleBtn.layer.masksToBounds = YES;
            
            [self.cancleBtn setBackgroundImage:cancleTitle forState:UIControlStateNormal];
            
            [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.cancleBtn.tag = 1;
            
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(0,0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.cancleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.cancleBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //只有取消按钮
//        if (cancleTitle && !sureTitle) {
//            
//            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
//            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
//            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
//            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
//            
//            self.cancleBtn.tag = 1;
//            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
//            
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = self.cancleBtn.bounds;
//            maskLayer.path = maskPath.CGPath;
//            self.cancleBtn.layer.mask = maskLayer;
//            
//            [self.alertView addSubview:self.cancleBtn];
//        }
        
        //只有确定按钮
//        if(sureTitle && !cancleTitle){
//            
//            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//            self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
//            
//            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
//            self.sureBtn.tag = 2;
//            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
//            
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = self.sureBtn.bounds;
//            maskLayer.path = maskPath.CGPath;
//            self.sureBtn.layer.mask = maskLayer;
//            
//            [self.alertView addSubview:self.sureBtn];
//            
//        }
        
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, kScreenWidth - 40, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        
    }
    return self;
}
-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.textColor = DefaultGrayTextClor;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont systemFontOfSize:16.0f];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:16.0f];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:8.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 弹出
-(void)showMKPAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    
}


-(void)creatShowAnimation
{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    self.alertView.layer.position = self.center;
    [self.alertView.layer addAnimation:animation forKey:nil];
    
}

#pragma mark - 回调 只设置2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    
    [self removeFromSuperview];
    
}
@end
