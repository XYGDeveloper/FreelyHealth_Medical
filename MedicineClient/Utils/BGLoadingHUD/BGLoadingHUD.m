//
//  BGLoadingHUD.m
//  HotelClient
//
//  Created by 黄雄彪 on 16/6/30.
//  Copyright © 2016年 sihan. All rights reserved.
//

#import "BGLoadingHUD.h"
#import "GifView.h"
#import "UIView+Extension.h"

@interface BGLoadingHUD ()
{
    UIImageView *_imageView;
}

@property(nonatomic,strong)UIActivityIndicatorView *activeView;
@property(nonatomic,strong)GifView *loadingGifview;
@property (nonatomic, assign) NSString *messageText;
@property (nonatomic, readonly) BOOL isAnimating;

@end

@implementation BGLoadingHUD

static BGLoadingHUD *_hud = nil;

+(BGLoadingHUD*)shareBGLoadingHUD {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_hud) {
            _hud = [BGLoadingHUD new];
        }
    });
    return _hud;
}

#pragma mark------------加载gif

+(BGLoadingHUD *)showMessage:(NSString *)message toView:(UIView *)view withGifFilePath:(NSString*)filePath
{
    BGLoadingHUD *hud = [BGLoadingHUD shareBGLoadingHUD];
    hud.backgroundColor = [UIColor lightGrayColor];
    
    hud.alpha = 0.6;
    
    hud.frame = view.bounds;
    [hud creatAnimationUI:filePath];
    if (message) {
        hud.messageText = message;
    }
    [view addSubview:hud];
    [hud startAnimation];
    return hud;
}

+(BGLoadingHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
   return [self showMessage:message toView:view withGifFilePath:nil];
}

+(void)hideHUDForView:(UIView *)view
{
    for (UIView *hud in view.subviews) {
        if ([hud isKindOfClass:[BGLoadingHUD class]]){
            [((BGLoadingHUD*)hud) stopAnimationWithmessageText:@"加载成功..." withType:YES];
        }
    }
}

//加载动画
-(void)creatAnimationUI:(NSString*)gifFilePath
{
    NSString *path = gifFilePath?gifFilePath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    UIImage *image = [UIImage imageNamed:path];
    CGSize imageSize = image.size;
    
    _loadingGifview = [[GifView alloc] initWithFrame:CGRectMake(self.width/2-imageSize.width/4,self.height/2-imageSize.height/4-40, imageSize.width/2,imageSize.height/2) filePath:path];
    _isAnimating = NO;
    [self addSubview:_loadingGifview];
    [self addSubview:self.infolabel];
    self.infolabel.frame = CGRectMake(30, _loadingGifview.maxY+10, self.width-60, 20);
    self.layer.hidden = YES;
}
//动画运行
- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

-(void)doAnimation {
    self.infolabel.text = _messageText?_messageText:@"努力加载中...";
    self.bgView.width = [self.infolabel.text boundingRectWithSize:CGSizeMake(self.width-60, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.infolabel.font} context:nil].size.width+30;
    self.bgView.x = self.width/2-self.bgView.width/2;
}

//隐藏界面
- (void)stopAnimationWithmessageText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    self.infolabel.text = text;
    if (self.loadingGifview) {
        [self.loadingGifview stopGif];
        [self.loadingGifview removeFromSuperview];
    }
    self.layer.hidden = YES;
    [self removeFromSuperview];
}

-(void)setMessageText:(NSString *)messageText
{
    if(messageText){
        _messageText = messageText;
    }
}

#pragma mark------------加载菊花怪

+(BGLoadingHUD *)showCommonMessage:(NSString *)message toView:(UIView *)view
{
    BGLoadingHUD *hud = [[BGLoadingHUD alloc]initWithFrame:view.bounds];
    if (message) {
        hud.messageText = message;
    }
    [view addSubview:hud];
    [hud startCommon];
    return hud;
}

+(void)hideCommonHUDForView:(UIView *)view
{
    for (UIView *hud in view.subviews) {
        if ([hud isKindOfClass:[BGLoadingHUD class]]){
            [((BGLoadingHUD*)hud) stopCommon];
        }
    }
}

-(void)showSuccessWithIcon:(NSString *)icon
{
    [_loadingGifview stopGif];
    _loadingGifview.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:icon].CGImage);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-40, self.height/2-45, 80, 90)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

-(UIActivityIndicatorView *)activeView
{
    if (!_activeView) {
        self.backgroundColor = [UIColor clearColor];
        _activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activeView.center = CGPointMake(self.width/2, self.height/2-11);
        _activeView.color = [UIColor whiteColor];
//        _activeView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _activeView.hidesWhenStopped = YES;
        
    }
    return _activeView;
}

-(UILabel *)infolabel
{
    if (!_infolabel) {
        _infolabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.height/2, self.width-60, 40)];
        _infolabel.backgroundColor = [UIColor clearColor];
        _infolabel.textAlignment = NSTextAlignmentCenter;
        _infolabel.font = [UIFont systemFontOfSize:15.0f];
        _infolabel.textColor = kINFOCOLOR;
        _infolabel.numberOfLines = 0;
    }
    return _infolabel;
}

-(void)startCommon
{
    [self.activeView startAnimating];
    [self addSubview:self.bgView];
    [self addSubview:self.infolabel];
    [self addSubview:self.activeView];
    self.infolabel.frame = CGRectMake(30, _activeView.maxY, self.width-60, 40);
    self.infolabel.text = self.messageText?self.messageText:@"努力加载中...";
    self.infolabel.textColor = [UIColor whiteColor];
    [self doAnimation];
}

-(void)stopCommon
{
    [self.activeView stopAnimating];
    self.hidden = YES;
    [self removeFromSuperview];
}


@end
