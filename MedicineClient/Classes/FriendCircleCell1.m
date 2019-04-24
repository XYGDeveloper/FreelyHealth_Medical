//
//  FriendCircleCell1.m
//  MedicineClient
//
//  Created by L on 2017/8/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FriendCircleCell1.h"
#import "FriendCircleImageView.h"
#import "FrumDetailModel.h"
#import "LTUITools.h"

@interface FriendCircleCell1()



///** <#des#> */
//@property (nonatomic,strong) UIImageView * iconView;

/** <#des#> */

@property (nonatomic,strong) UIImageView * nameIcon;    //客服咨询


@property (nonatomic,strong) UILabel * nameLabel;    //客服咨询

/** <#des#> */
@property (nonatomic,strong) UILabel * contentLabel;  //问题内容

@property (nonatomic,strong) UILabel * timeLabelContent;  //问题内容


/** 全文/收起 */
@property (nonatomic,strong) UIButton * allContentButton;

/** <#des#> */
@property (nonatomic,strong) UILabel * timeLabel;    //发布时间

@property (nonatomic,strong) UIImageView * scanImg;

@property (nonatomic,strong) UILabel * scanCount;

@property (nonatomic,strong) UIImageView * commentImg;

@property (nonatomic,strong) UILabel * commentCount;


@property (nonatomic,strong) UIImageView * sep;

@property (nonatomic,strong) UIImageView * headImage;

@property (nonatomic,strong) UILabel * name;

@property (nonatomic,strong) UILabel * jop;

@property (nonatomic,strong) UILabel * auswer;

@property (nonatomic,strong) UILabel * timeLabel1;    //发布时间

@property (nonatomic,strong) UIImageView * scanImg1;

@property (nonatomic,strong) UILabel * scanCount1;

/** <#des#> */
@property (nonatomic,strong) FriendCircleImageView * friendCircleImageView;   //图片

/** <#des#> */
@property (nonatomic,strong) FrumDetailModel * model;

/** <#des#> */
@property (nonatomic,copy) dispatch_block_t btClickBlock;


@end

@implementation FriendCircleCell1

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
    //    self.iconView = [LTUITools lt_creatImageView];
    //    [self.contentView addSubview:self.iconView];
    
    self.nameIcon = [LTUITools lt_creatImageView];
    
    self.nameIcon.image = [UIImage imageNamed:@"frum_questionIcon"];
    
    [self.contentView addSubview:self.nameIcon];
    
    self.nameLabel = [LTUITools lt_creatLabel];
    
    self.nameLabel.font = Font(15);
    
    self.nameLabel.textAlignment  = NSTextAlignmentLeft;
    
    self.nameLabel.textColor = DefaultGrayLightTextClor;
    
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [LTUITools lt_creatLabel];
    
    self.contentLabel.font = Font(17);
    
    self.contentLabel.textColor = DefaultBlackLightTextClor;
    
    [self.contentView addSubview:self.contentLabel];
    
    self.friendCircleImageView = [FriendCircleImageView new];
    
    [self.contentView addSubview:self.friendCircleImageView];
    
    self.timeLabel = [LTUITools lt_creatLabel];
    
    self.timeLabel.font = Font(12);
    
    self.timeLabel.textColor = DefaultGrayLightTextClor;
    
    [self.contentView addSubview:self.timeLabel];
    
    
    self.scanImg = [LTUITools lt_creatImageView];
    
    self.scanImg.image = [UIImage imageNamed:@"frum_scanIcon"];
    
    [self.contentView addSubview:self.scanImg];
    
    self.scanCount = [LTUITools lt_creatLabel];
    
    self.scanCount.font = Font(12);
    
    self.scanCount.textAlignment = NSTextAlignmentLeft;
    
    self.scanCount.textColor = DefaultGrayLightTextClor;
    
    [self.contentView addSubview:self.scanCount];
    
    self.commentImg = [LTUITools lt_creatImageView];
    
    self.commentImg.image = [UIImage imageNamed:@"comment"];
    
    [self.contentView addSubview:self.commentImg];
    
    self.commentCount = [LTUITools lt_creatLabel];
    
    self.commentCount.font = Font(12);
    
    self.commentCount.textAlignment = NSTextAlignmentLeft;
    
    self.commentCount.textColor = DefaultGrayLightTextClor;
    
    [self.contentView addSubview:self.commentCount];
    
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
    
    [self.contentView addSubview:self.contentLabel];
    self.allContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.allContentButton.backgroundColor = [UIColor redColor];
    [self.allContentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.allContentButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.allContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.allContentButton];
    
    //    [self.allContentButton bk_whenTapped:^{
    //        self.model.select = !self.model.select;
    //        if (self.btClickBlock) {
    //            self.btClickBlock();
    //        }
    //    }];
    
    self.timeLabelContent = [LTUITools lt_creatLabel];
    
    self.timeLabelContent.font = Font(12);
    
    self.timeLabelContent.textColor = DefaultGrayTextClor;
    
    self.timeLabelContent.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.timeLabelContent];
    
}

#pragma mark - 设置约束
- (void)setConstant
{
    [self.nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameIcon.mas_right).mas_equalTo(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.nameIcon.mas_centerY);
        make.height.mas_equalTo(25);
    }];
    
    //    [self.timeLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(200);
    //        make.height.mas_equalTo(25);
    //        make.right.equalTo(self.contentView).offset(-20);
    //        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    //    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.nameIcon.mas_left);
        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
    }];
    
    [self.allContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(16);
    }];
    
#pragma mark - friendCircleImageView每部已经自动自动计算高度
    [self.friendCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allContentButton.mas_bottom).offset(10);
        make.right.left.equalTo(self.nameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.scanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.width.height.mas_equalTo(14);
    }];
    
    [self.scanCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scanImg.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scanCount.mas_right);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.width.height.mas_equalTo(14);
    }];
    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentImg.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
//    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_equalTo(15);
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.height.mas_equalTo(0.5);
//    }];
    
//    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.sep.mas_bottom).mas_equalTo(15);
//        make.left.mas_equalTo(16);
//        make.width.height.mas_equalTo(40);
//    }];
//    
//    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headImage.mas_top).mas_equalTo(2);
//        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
//        make.right.mas_equalTo(-16);
//        make.height.mas_equalTo(20);
//    }];
//    
//    [self.jop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.name.mas_bottom).mas_equalTo(0);
//        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
//        make.right.mas_equalTo(-16);
//        make.height.mas_equalTo(20);
//    }];
//    
//    [self.auswer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headImage.mas_bottom).mas_equalTo(10);
//        make.left.mas_equalTo(16);
//        make.right.mas_equalTo(-16);
//        make.height.mas_equalTo(55);
//    }];
    
//    [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.top.mas_equalTo(self.auswer.mas_bottom).mas_equalTo(5);
//        make.width.mas_equalTo(160);
//        make.height.mas_equalTo(25);
//        make.bottom.mas_equalTo(-20);
//        
//    }];
//    
//    [self.scanImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.scanCount1.mas_right);
//        make.centerY.mas_equalTo(self.timeLabel1.mas_centerY);
//        make.width.height.mas_equalTo(14);
//    }];
//    
//    [self.scanCount1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.timeLabel1.mas_right).mas_equalTo(0);
//        make.centerY.mas_equalTo(self.timeLabel1.mas_centerY);
//        make.width.mas_equalTo(20);
//    }];
    
    
}

- (void)cellDataWithModel:(FrumDetailModel *)model
{
    self.model = model;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *imgArray;
    
    
    if (model.imagepath.length <= 0) {
        
        imgArray = nil;
        
    }else{
        
        
        imgArray = [model.imagepath componentsSeparatedByString:@","];
        
        for (NSString *obj in imgArray) {
            
            if (![obj isEqualToString:@""]) {
                
                [arr addObject:obj];
                
            }
            
        }
        
    }
    
    NSLog(@"llll----lllll%@",imgArray);
    self.scanCount.text  =model.readnum;
    self.commentCount.text = model.answernum;
    self.nameIcon.image = [UIImage imageNamed:@"frum_questionIcon"];
    self.scanImg.image = [UIImage imageNamed:@"frum_scanIcon"];
    self.commentImg.image = [UIImage imageNamed:@"comment"];
    NSRange range = {3,4};
    
    NSString *phone = [model.phone stringByReplacingCharactersInRange:range withString:@"****"];
    self.nameLabel.text = [NSString stringWithFormat:@"%@提出的问题",phone];
    self.contentLabel.text = model.title;
    
    [self.friendCircleImageView cellDataWithImageArray:arr];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 发布",model.createtime];
    self.timeLabelContent.text = model.createtime;
    
    //    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.facepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    //
    //    self.name.text = model.dname;
    //
    //    self.jop.text = [NSString stringWithFormat:@"%@ | %@",model.job,model.hname];
    //
    //    self.auswer.text = model.answer;
    //
    //    self.timeLabel1.text = [NSString stringWithFormat:@"%@ 回复",model.backtime];
    //
    //    self.scanCount1.text = model.agreenum;
    
    [self layoutUI:model.title imgArr:imgArray];
    
}

- (void)layoutUI:(NSString *)content imgArr:(NSArray *)imagesArray
{
    //计算正文高度
    CGFloat contentHeight = [self contentHeight:content];
    //friendCircleImageView 图片参照view
    UIView * targetViewOfFriendCircleImageView;
    //如果大于60  显示全部查看按钮
    if (contentHeight >60) {
        [self.allContentButton setTitle:@"" forState:UIControlStateNormal];
        [self.allContentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16);
        }];
        //限制正文label高度小于60
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_lessThanOrEqualTo(60);
        }];
        targetViewOfFriendCircleImageView = self.allContentButton;
        
    } else{
        [self.allContentButton setTitle:@"" forState:UIControlStateNormal];
        //这里得重置contentLabel的约束
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.nameIcon.mas_left);
            make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
        }];
        
        [self.allContentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        targetViewOfFriendCircleImageView = self.contentLabel;
        
    }
    //设置friendCircleImageView 参数
    [self.friendCircleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(targetViewOfFriendCircleImageView.mas_bottom).offset(10);
        make.right.equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameIcon.mas_left);
    }];
    
    //如果 "查看全部" 按钮被点击 则重置label约束
    //    if (self.model.isSelect == YES) {
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameIcon.mas_left);
        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
    }];
    //        [self.allContentButton setTitle:@"收起" forState:UIControlStateNormal];
    //    }
    //timeLabel 参照View
    UIView * targetViewOfTimeLabel;
    //如果没有图片并且正文高度大于60
    if (imagesArray.count == 0 && contentHeight > 60) {
        targetViewOfTimeLabel = self.allContentButton;
        //如果没有图片并且正文内容小于等于60
    } else if (imagesArray.count == 0 && contentHeight <= 60) {
        targetViewOfTimeLabel = self.contentLabel;
        //如果有图片
    } else {
        targetViewOfTimeLabel = self.friendCircleImageView;
    }
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameIcon.mas_left);
        make.width.mas_equalTo(160);
        make.top.equalTo(targetViewOfTimeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(-20);
    }];
    
}

- (void)cellClickBt:(dispatch_block_t)clickBtBlock
{
    self.btClickBlock = clickBtBlock;
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

@end
