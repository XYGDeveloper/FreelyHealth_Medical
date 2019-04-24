//
//  MyIntroTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyIntroTableViewCell.h"
#import "GlistModel.h"
#import "MyProfilwModel.h"

@interface MyIntroTableViewCell()

@property (nonatomic,strong)UILabel *intro;

@property (nonatomic,strong)UILabel *sep;



@end

@implementation MyIntroTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        
        self.intro = [[UILabel alloc]init];
        
        self.intro.textColor = DefaultGrayTextClor;
        
        
        self.intro.textAlignment = NSTextAlignmentLeft;
        
        self.intro.font = FontNameAndSize(16);
        
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


- (void)refreshWirthModel:(MyProfilwModel *)model
{
    
    self.intro.text = @"专家介绍";

    self.introContent.textColor = DefaultBlackLightTextClor;

    if (model.introduction.length <=0) {
        
        self.introContent.text = @"暂无个人介绍，请更新您的个人详细介绍";
    }else{
    
        self.introContent.text = model.introduction;
        
    }
    
}

- (void)refreshWirthModeltime:(MyProfilwModel *)model{
    self.intro.text = @"门诊时间";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.menzhen.length <=0) {
        self.introContent.text = @"暂无设置门诊时间，请更新您的门诊时间";
    }else{
        self.introContent.text = model.menzhen;
    }
}

- (void)refreshWirthModel1:(NSString *)model{
    self.intro.text = @"详细介绍";
    self.intro.textColor = DefaultGrayLightTextClor;
    self.introContent.textColor = DefaultBlackLightTextClor;
    [self.sep mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    if (model.length <=0) {
        self.introContent.text = @"暂无详细介绍";
    }else{
        self.introContent.text = model;
        
    }
    
}

- (void)refreshWirthGlistModel:(GlistModel *)model{
    self.intro.text = @"详情描述";
    self.intro.textColor = DefaultGrayLightTextClor;
    self.introContent.textColor = DefaultBlackLightTextClor;
    [self.sep mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    if (model.des.length <=0) {
        self.introContent.text = @"无详情描述";
    }else{
        self.introContent.text = model.des;
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
