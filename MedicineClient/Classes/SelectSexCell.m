//
//  SelectSexCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectSexCell.h"

@interface SelectSexCell ()

@property (nonatomic, strong) UIButton *maleButton;

@property (nonatomic, strong) UIButton *femaleButton;

@end

@implementation SelectSexCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.maleButton];
        [self.contentView addSubview:self.femaleButton];
        
        [self setEditAble:NO];
        [self.maleButton addTarget:self action:@selector(maleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.femaleButton addTarget:self action:@selector(femaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setIcon:[UIImage imageNamed:@"sex_nor"] editedIcon:[UIImage imageNamed:@"sex_sel"] placeholder:@"患者性别"];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@130);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleButton.mas_right).offset(50);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - Public Methods
- (NSString *)sex {
    if (self.maleButton.selected) {
        return SexMale;
    } else if (self.femaleButton.selected) {
        return SexFemale;
    }
    return @"";
}

- (void)setSex:(NSString *)sex {
    self.maleButton.selected = [sex isEqualToString:SexMale];
    self.femaleButton.selected = [sex isEqualToString:SexFemale];
    
    if (self.maleButton.selected || self.femaleButton.selected) {
        self.iconView.image = self.editedImage;
    } else {
        self.iconView.image = self.normalImage;
    }
    
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

#pragma mark - Events
- (void)maleButtonClicked:(id)sender {
    
    self.sex = SexMale;
    
    if (self.type) {
        
        self.type(self.sex);
    }
    
    
}

- (void)femaleButtonClicked:(id)sender {
    
    self.sex = SexFemale;
    
    if (self.type) {
        
        self.type(self.sex);
    }
}


#pragma mark - Properties
- (UIButton *)maleButton {
    if (!_maleButton) {
        _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleButton.backgroundColor = [UIColor clearColor];
        
        [_maleButton setImage:[UIImage imageNamed:@"sex_nor"] forState:UIControlStateNormal];
        [_maleButton setImage:[UIImage imageNamed:@"sex_sel"] forState:UIControlStateSelected];
        
        _maleButton.titleLabel.font = FontNameAndSize(16);
        [_maleButton setTitle:@"   男" forState:UIControlStateNormal];
        [_maleButton setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
        [_maleButton setTitleColor:HexColor(0x323232) forState:UIControlStateSelected];
    }
    return _maleButton;
}

- (UIButton *)femaleButton {
    if (!_femaleButton) {
        _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleButton.backgroundColor = [UIColor clearColor];
        
        [_femaleButton setImage:[UIImage imageNamed:@"sex_nor"] forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"sex_sel"] forState:UIControlStateSelected];
        
        _femaleButton.titleLabel.font = FontNameAndSize(16);
        [_femaleButton setTitle:@"   女" forState:UIControlStateNormal];
        [_femaleButton setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
        [_femaleButton setTitleColor:HexColor(0x323232) forState:UIControlStateSelected];
    }
    return _femaleButton;
}


@end
