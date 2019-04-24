//
//  UpDateDetailTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UpDateDetailTableViewCell.h"
#import "LTUITools.h"
#import "SZTextView.h"
@interface UpDateDetailTableViewCell()<UITextViewDelegate>

@property (nonatomic,strong)UIImageView *imagesep;

@end


@implementation UpDateDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.label = [LTUITools lt_creatLabel];
        
        self.label.textColor = DefaultGrayLightTextClor;
        
        self.label.text = @"详细介绍";
        
        self.imagesep = [LTUITools lt_creatImageView];
        
        self.imagesep.backgroundColor = DividerGrayColor;
        
        [self.contentView addSubview:self.imagesep];
        
        self.label.font = Font(16);
        
        [self.contentView addSubview:self.label];
        
        [self.contentView addSubview:self.textView];
        
    }
    
    return self;
    
    
    
}


- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = Font(16);
        _textView.textColor = DefaultGrayTextClor;
        _textView.placeholder = @"";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        
        
    }
    return _textView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(25);
    }];
    
    [self.imagesep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.imagesep.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
