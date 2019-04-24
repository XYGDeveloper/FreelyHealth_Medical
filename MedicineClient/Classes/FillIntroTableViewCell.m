//
//  FillIntroTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/2/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FillIntroTableViewCell.h"
#import "SZTextView.h"

@interface FillIntroTableViewCell()<UITextViewDelegate>
@property (nonatomic, strong, readwrite) UILabel *typeName;
@property (nonatomic, strong, readwrite) UIView *sepLine;
@property (nonatomic, strong, readwrite) SZTextView *textField;
@end

@implementation FillIntroTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxEditCount = INT16_MAX;
        _typeName = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth -40, 40)];
        _typeName.textAlignment = NSTextAlignmentLeft;
        _typeName.font = FontNameAndSize(16);
        _typeName.textColor = DefaultGrayTextClor;
        [self.contentView addSubview:self.typeName];
        _sepLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.typeName.frame), kScreenWidth- 20, 0.5)];
        _sepLine.backgroundColor = DividerDarkGrayColor;
        [self.contentView addSubview:self.sepLine];
        _textField = [[SZTextView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.sepLine.frame), kScreenWidth - 40, 50)];
        _textField.delegate = self;
        _textField.font = FontNameAndSize(16);
        _textField.textColor = DefaultBlackLightTextClor;
        _textField.placeholderTextColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public Methods

- (void)setTypeName:(NSString *)typeName placeholder:(NSString *)placeholder
{
    self.typeName.text = typeName;
    self.textField.placeholder = placeholder;
}

- (NSString *)text {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setText:(NSString *)text {
    self.textField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

- (void)setEditAble:(BOOL)editAble {
    self.textField.editable = editAble;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= self.maxEditCount && string.length > range.length) {
        return NO;
    }
    return YES;
}

@end
