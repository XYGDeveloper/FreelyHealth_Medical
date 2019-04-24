//
//  EmptyConversation.m
//  MedicineClient
//
//  Created by xyg on 2017/12/9.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "EmptyConversation.h"
#import "ApiResponse.h"

@implementation EmptyConversation

+ (instancetype)sharedManager {
    static EmptyConversation *__manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[EmptyConversation alloc] init];
    });
    return __manager;
}

- (EmptyconversionView *)showEmptyOnView:(UIView *)parentView
                     withImage:(UIImage *)image
                       explain:(NSString *)explain
                 operationText:(NSString *)opText
                operationBlock:(void(^)(void))opBlock {
    
    [self removeEmptyFromView:parentView];
    
    EmptyconversionView *view = [[EmptyconversionView alloc] initWithFrame:CGRectMake(0,50, parentView.width, parentView.height)];;
    
    [view refreshWithImage:image explain:explain operationText:opText operationBlock:opBlock];
    
    [parentView addSubview:view];
    
    return view;
}



- (EmptyconversionView *)showNetErrorOnView:(UIView *)parentView
                         response:(ApiResponse *)response
                   operationBlock:(void(^)(void))opBlock {
    if (parentView == nil) {
        return nil;
    }
    
    [self removeEmptyFromView:parentView];
    
    EmptyconversionView *view = [[EmptyconversionView alloc] initWithFrame:CGRectMake(0, 0, parentView.width, parentView.height)];
    [view netErrorLayout];
    
    [view refreshWithImage:[UIImage imageNamed:@"global_netError"] explain:@"抱歉：~~~~网络迷路了" operationText:@"重试" operationBlock:^{
        [self removeEmptyFromView:parentView];
        if (opBlock) {
            opBlock();
        }
    }];
    [parentView addSubview:view];
    
    return view;
}

- (void)removeEmptyFromView:(UIView *)parentView {
    for (UIView *subView in parentView.subviews) {
        if ([subView isKindOfClass:[EmptyconversionView class]]) {
            [subView removeFromSuperview];
        }
    }
}

@end






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface EmptyconversionView ()

@property (nonatomic, strong) UIImageView *emptyImgView;

@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void(^operationBlock)();

@end

@implementation EmptyconversionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DefaultBackgroundColor;
        [self.operationButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.emptyImgView];
        [self addSubview:self.emptyLabel];
        [self addSubview:self.operationButton];
        
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self.emptyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(self);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImgView.mas_bottom).offset(43);
        make.left.right.equalTo(@0);
    }];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self);
        make.width.equalTo(@141);
        make.height.equalTo(@44);
    }];
    
    
    
    
}

- (void)netErrorLayout {
    [self.emptyImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.width.height.equalTo(@100);
        make.top.equalTo(@50);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Public Methods
- (void)refreshWithImage:(UIImage *)image
                 explain:(NSString *)explain
           operationText:(NSString *)opText
          operationBlock:(void(^)(void))opBlock {
    self.emptyImgView.image = image;
    self.emptyImgView.size = image.size;
    
    self.emptyLabel.text = explain;
    
    self.operationButton.hidden = opText.length <= 0;
    [self.operationButton setTitle:opText forState:UIControlStateNormal];
    self.operationBlock = opBlock;
}





#pragma mark - Events
- (void)operationButtonClicked:(id)sender {
    if (self.operationBlock) {
        self.operationBlock();
    }
}

#pragma mark - Properties
- (UIImageView *)emptyImgView {
    if (!_emptyImgView) {
        _emptyImgView = [[UIImageView alloc] init];
        _emptyImgView.contentMode = UIViewContentModeScaleAspectFill;
        _emptyImgView.clipsToBounds = YES;
    }
    return _emptyImgView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.backgroundColor = [UIColor clearColor];
        _emptyLabel.font = FontNameAndSize(14);
        _emptyLabel.textColor = TextColor2;
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIHelper generalRaundCornerButtonWithTitle:@" "];
    }
    return _operationButton;
}

@end
