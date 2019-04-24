//
//  ListTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ListTableViewCell.h"

#import "FrumDetailModel.h"
@interface ListTableViewCell()

@property (nonatomic,strong) UIImageView * headImage;

@property (nonatomic,strong) UILabel * name;

@property (nonatomic,strong) UILabel * jop;

@property (nonatomic,strong) UILabel * auswer;

@property (nonatomic,strong) UILabel * timeLabel1;    //发布时间

@property (nonatomic,strong) UIImageView * scanImg1;

@property (nonatomic,strong) UILabel * scanCount1;

@property (nonatomic,strong) UIImageView * sep;

@property (nonatomic,strong) UIView * bottomView;


@end


@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setConstant];
    }
    
    return self;
}

#pragma mark - 设置UI
- (void)setupUI
{
    
        self.sep = [LTUITools lt_creatImageView];
    
        self.sep.backgroundColor = DividerGrayColor;
    
        [self.contentView addSubview:self.sep];
    
        self.headImage = [LTUITools lt_creatImageView];
    
        self.headImage.layer.cornerRadius = 20;
    
        self.headImage.layer.masksToBounds = YES;
    
        [self.contentView addSubview:self.headImage];
    
        self.name = [LTUITools lt_creatLabel];
    
        self.name.textColor  =DefaultBlackLightTextClor;
    
        self.name.font  =Font(15);
    
        self.name.textAlignment = NSTextAlignmentLeft;
    
        [self.contentView addSubview:self.name];
    
        self.jop = [LTUITools lt_creatLabel];
    
        self.jop.textColor  =DefaultGrayLightTextClor;
    
        self.jop.font  =Font(14);
    
        self.jop.textAlignment = NSTextAlignmentLeft;
    
        [self.contentView addSubview:self.jop];
    
        self.auswer = [LTUITools lt_creatLabel];
    
        self.auswer.font = Font(16);
        self.auswer.numberOfLines = 0;
        self.auswer.textColor = DefaultGrayTextClor;
    
        [self.contentView addSubview:self.auswer];
    
    
        self.timeLabel1 = [LTUITools lt_creatLabel];
    
        self.timeLabel1.font = Font(12);
    
        self.timeLabel1.textColor = DefaultGrayLightTextClor;
    
        [self.contentView addSubview:self.timeLabel1];
    
        self.scanImg1 = [LTUITools lt_creatImageView];
    
        self.scanImg1.image = [UIImage imageNamed:@"thumb_up_button"];
    
        [self.contentView addSubview:self.scanImg1];
    
        self.scanCount1 = [LTUITools lt_creatLabel];
    
        self.scanCount1.font = Font(12);
    
        self.scanCount1.textAlignment = NSTextAlignmentLeft;
    
        self.scanCount1.textColor = DefaultGrayLightTextClor;
    
        [self.contentView addSubview:self.scanCount1];
    
    
    self.bottomView = [LTUITools lt_creatImageView];
    
    self.bottomView.backgroundColor = DefaultBackgroundColor;
    
    [self.contentView addSubview:self.bottomView];
    
    
}

#pragma mark - 设置约束
- (void)setConstant
{
    

    //
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(16);
            make.width.height.mas_equalTo(40);
        }];
    //
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImage.mas_top).mas_equalTo(2);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(20);
        }];
    //
        [self.jop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom).mas_equalTo(0);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(20);
        }];
    //
    
        [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImage.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(0.5);
        }];
    
        [self.auswer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sep.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
    //
        [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.auswer.mas_bottom).mas_equalTo(5);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(25);
    
        }];
    
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel1.mas_bottom).mas_equalTo(20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
            make.bottom.mas_equalTo(0);
        }];
    
    
    //
        [self.scanImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scanCount1.mas_right);
            make.centerY.mas_equalTo(self.timeLabel1.mas_centerY);
            make.width.height.mas_equalTo(14);
        }];
    //
        [self.scanCount1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel1.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(self.timeLabel1.mas_centerY);
            make.width.mas_equalTo(20);
        }];
    
}

- (void)cellDataWithModel:(AuswerModel *)model
{
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
    self.name.text = model.dname;
    
    self.jop.text = [NSString stringWithFormat:@"%@ | %@",model.job,model.hname];
    
    self.auswer.text = model.answer;

    self.timeLabel1.text = [NSString stringWithFormat:@"%@ 回复",model.backtime];
    
    self.scanCount1.text = model.agreenum;

}


- (CGFloat)contentHeight:(NSString *)content
{
    CGRect textRect = [content boundingRectWithSize:CGSizeMake([self contentLabelMaxWidth], MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];
    return textRect.size.height;
}

- (CGFloat)contentLabelMaxWidth
{
    return kScreenWidth - 40;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
