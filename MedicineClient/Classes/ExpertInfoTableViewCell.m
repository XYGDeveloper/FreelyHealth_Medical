//
//  ExpertInfoTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ExpertInfoTableViewCell.h"

#import "TeamDetalModel.h"

@interface ExpertInfoTableViewCell()

@property (nonatomic,strong)UILabel *intro;

@property (nonatomic,strong)UILabel *sep;

@property (nonatomic,strong)UILabel *introContent;

@end


@implementation ExpertInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.intro = [[UILabel alloc]init];
        
        self.intro.textColor = DefaultGrayTextClor;
        
        self.intro.text = @"专家介绍";
        
        self.intro.textAlignment = NSTextAlignmentLeft;
        
        self.intro.font = Font(16);
        
        [self.contentView addSubview:self.intro];
        
        self.sep = [[UILabel alloc]init];
        
        self.sep.backgroundColor = DividerGrayColor;
        
        [self.contentView addSubview:self.sep];
        
        self.introContent = [[UILabel alloc]init];
        
        self.introContent.numberOfLines = 0;
        
        self.introContent.textColor = DefaultGrayLightTextClor;
        
        self.introContent.font = FontNameAndSize(16);
        
        [self.contentView addSubview:self.introContent];
        
        [self layOut];
        
        
    }
    
    return self;
    
}


- (void)layOut{
    
    [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        
        make.top.mas_equalTo(5);
        
        make.right.mas_equalTo(-16);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.introContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.sep.mas_bottom).mas_equalTo(10);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-15);
        
    }];
    
}


- (void)refreshWirthModel:(TeamDetalModel *)model
{
    
    self.introContent.textColor = DefaultBlackLightTextClor;

    if (model.introduction.length <=0) {
        self.introContent.text = @"暂无个人介绍，请更新您的个人详细介绍";
    }else{
        
        NSString *_test  = model.introduction;
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;
        paraStyle01.headIndent = 0.0f;
        CGFloat emptylen = self.introContent.font.pointSize * 2;
        paraStyle01.firstLineHeadIndent = emptylen;
        paraStyle01.tailIndent = 0.0f;
        paraStyle01.lineSpacing = 2.0f;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        self.introContent.attributedText = attrText;
    }
    
}

- (void)refreshWirthModeltime:(TeamDetalModel *)model
{
    self.intro.text = @"门诊时间";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.menzhen.length <=0) {
        self.introContent.text = @"暂无门诊时间";
    }else{
        self.introContent.text = model.menzhen;
    }
    
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
