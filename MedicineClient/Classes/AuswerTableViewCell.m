//
//  AuswerTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuswerTableViewCell.h"
#import "LTUITools.h"
#import "FrumDetailModel.h"

@interface AuswerTableViewCell()

@property (nonatomic,strong)UIImageView *QuestionIcon;

@property (nonatomic,strong)UILabel *QuestionTitle;

@property (nonatomic,strong)UILabel *thumpUpCount;

@property (nonatomic,strong)UILabel *scanCount;

@property (nonatomic,strong)UIImageView *scanIcon;

@property (nonatomic,strong)UIButton *thumpUpButton;

@property (nonatomic,strong)UILabel *QuestionContent;

@property (nonatomic,strong)UIImageView *SepIcon;

@property (nonatomic,strong)UIImageView *headIcon;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *JopAndHotelNameLabel;

@property (nonatomic,strong)UILabel *AuswerLabel;

@property (nonatomic,strong)UILabel *PublishTime;

@property (nonatomic,strong)UIImageView *commentButton;

@property (nonatomic,strong)UILabel *commentCount;

@property (nonatomic,strong)UILabel *ReplayTime;


@end


@implementation AuswerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        UIView * v = [UIView new];
        v.backgroundColor = [UIColor brownColor];
        //  self.selected = YES  Cell 显示的颜色
        self.multipleSelectionBackgroundView = v;
        //  self.selected = YES  钩 显示的颜色
        self.tintColor = [UIColor yellowColor];
        
        //questionIcon
        self.QuestionIcon = [LTUITools lt_creatImageView];
        
        self.QuestionIcon.image = [UIImage imageNamed:@"frum_questionIcon"];
        
        [self.contentView addSubview:self.QuestionIcon];
        
        //question title
        self.QuestionTitle = [LTUITools lt_creatLabel];
        
        self.QuestionTitle.font  =Font(15);
        
        self.QuestionTitle.textAlignment = NSTextAlignmentLeft;
        
        self.QuestionTitle.textColor  =DefaultGrayTextClor;
        
        [self.contentView addSubview:self.QuestionTitle];
        
        //scan Count
        self.scanCount = [LTUITools lt_creatLabel];
        
        self.scanCount.font  =Font(12);
        
        self.scanCount.textAlignment = NSTextAlignmentLeft;
        
        self.scanCount.textColor  =DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.scanCount];
        
        //scan icon
        self.scanIcon = [LTUITools lt_creatImageView];
        
        self.scanIcon.image = [UIImage imageNamed:@"frum_scanIcon"];
        
        [self.contentView addSubview:self.scanIcon];
        
        self.QuestionContent = [LTUITools lt_creatLabel];
        
        self.QuestionContent.numberOfLines = 0;
        
        self.QuestionContent.font  = Font(17);
        
        self.QuestionContent.textAlignment = NSTextAlignmentLeft;
        
        self.QuestionContent.textColor  =DefaultBlackLightTextClor;
        
        [self.contentView addSubview:self.QuestionContent];
        //
        
        self.PublishTime = [LTUITools lt_creatLabel];
        
        self.PublishTime.font  =Font(12);
        
        self.PublishTime.textAlignment = NSTextAlignmentLeft;
        
        self.PublishTime.textColor  =DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.PublishTime];
        
        //
        
        self.commentButton = [LTUITools lt_creatImageView];
        
        self.commentButton.image = [UIImage imageNamed:@"comment"];
        
        self.commentCount.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.commentButton];
        
        self.commentCount = [LTUITools lt_creatLabel];
        
        self.commentCount.font  =Font(12);
        
        self.commentCount.textAlignment = NSTextAlignmentLeft;
        
        self.commentCount.textColor  =DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.commentCount];
        
        [self setLAYout];
        
    }
    
    return self;
    
    
}


- (void)setLAYout{

    CGFloat margin = 16;
    
    [self.QuestionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        
        make.width.height.mas_equalTo(18);
        
        make.top.mas_equalTo(10);
        
    }];
    
    [self.QuestionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.QuestionIcon.mas_right).mas_equalTo(10);
        
        make.centerY.mas_equalTo(self.QuestionIcon.mas_centerY);
        
        make.width.mas_equalTo(kScreenWidth - margin - 15 - 18 - 30 - 60);
        
        make.height.mas_equalTo(20);
        
    }];
    
    [self.QuestionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QuestionIcon.mas_bottom).offset(10);
        make.left.equalTo(self.QuestionIcon);
        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
    }];
    
    [self.PublishTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.QuestionContent.mas_left);
        
        make.top.mas_equalTo(self.QuestionContent.mas_bottom).mas_equalTo(10);
        
        make.width.mas_equalTo(kScreenWidth/3 + 60);
        
        make.height.mas_equalTo(25);
        
        make.bottom.mas_equalTo(-15);
        
    }];
    
    [self.scanCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.scanIcon.mas_right).mas_equalTo(4);
        
        make.centerY.mas_equalTo(self.PublishTime.mas_centerY);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(25);
        
    }];
    
    
    [self.scanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.PublishTime.mas_right);
        
        make.centerY.mas_equalTo(self.scanCount.mas_centerY);
        
        make.width.height.mas_equalTo(14);
        
        
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.scanCount.mas_right).mas_equalTo(8);
        
        make.centerY.mas_equalTo(self.scanCount.mas_centerY);
        
        make.width.mas_equalTo(14);
        
        make.height.mas_equalTo(14);
        
    }];
    
    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.commentButton.mas_right).mas_equalTo(5);
        
        make.centerY.mas_equalTo(self.commentButton.mas_centerY);
        
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(14);
        
        
    }];


}

- (CGFloat)contentHeight:(NSString *)content
{
    CGRect textRect = [content boundingRectWithSize:CGSizeMake([self contentLabelMaxWidth], MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];
    return textRect.size.height;
}

- (CGFloat)contentLabelMaxWidth
{
    return kScreenWidth - 32;
}


- (void)cellDataWithModel:(FrumDetailModel *)model
{
    
    NSRange range = {3,4};
    
    NSString *phone = [model.phone stringByReplacingCharactersInRange:range withString:@"****"];
    
    self.QuestionTitle.text = [NSString stringWithFormat:@"%@提出的问题",phone];
    
    self.QuestionContent.text = [NSString stringWithFormat:@"问题：%@",model.title];
    
    self.scanCount.text  = model.readnum;
    
    self.PublishTime.text  = [NSString stringWithFormat:@"%@发布",model.createtime];
    
    self.commentCount.text = model.answernum;
    
    self.scanCount.text = model.readnum;
    
    
}





@end
