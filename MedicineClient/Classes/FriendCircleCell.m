//
//  FriendCircleCell.m
//  ReactCocoaDemo
//
//  Created by letian on 16/12/5.
//  Copyright © 2016年 cmsg. All rights reserved.
//

#import "FriendCircleCell.h"
#import "FriendCircleImageView.h"
#import "LTUITools.h"
#import "HZListDetailModel.h"
#import "AgreeBookModel.h"
@interface FriendCircleCell ()

///** <#des#> */
//@property (nonatomic,strong) UIImageView * iconView;

/** <#des#> */
@property (nonatomic,strong) UILabel * nameLabel;    //客服咨询

/** <#des#> */
@property (nonatomic,strong) UILabel * contentLabel;  //问题内容

@property (nonatomic,strong) UILabel * timeLabelContent;  //问题内容

/** 全文/收起 */
@property (nonatomic,strong) UIButton * allContentButton;

/** <#des#> */
@property (nonatomic,strong) UILabel * timeLabel;    //发布时间

/** <#des#> */
@property (nonatomic,strong) FriendCircleImageView * friendCircleImageView;   //图片

/** <#des#> */

/** <#des#> */
@property (nonatomic,copy) dispatch_block_t btClickBlock;

@end

@implementation FriendCircleCell

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
    
    self.nameLabel = [LTUITools lt_creatLabel];
    
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    
    self.nameLabel.textAlignment  = NSTextAlignmentLeft;
    
    self.nameLabel.textColor = DefaultBlackLightTextClor;
    
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [LTUITools lt_creatLabel];

    self.contentLabel.textColor = DefaultGrayTextClor;
    
    self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];

    [self.contentView addSubview:self.contentLabel];
    
    self.friendCircleImageView = [FriendCircleImageView new];
    [self.contentView addSubview:self.friendCircleImageView];
    
    self.timeLabel = [LTUITools lt_creatLabel];
    
    self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];

    self.timeLabel.textColor = DefaultGrayTextClor;
    
    [self.contentView addSubview:self.timeLabel];
    
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
//    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(20);
//        make.left.equalTo(self.contentView).offset(10);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.timeLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(0);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.left.equalTo(self.nameLabel);
        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
    }];
    
    [self.allContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(0);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(0);
    }];
    
#pragma mark - friendCircleImageView每部已经自动自动计算高度
    [self.friendCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allContentButton.mas_bottom).offset(0);
        make.right.left.equalTo(self.nameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
    }];
    
}

//- (void)cellDataWithModel:(recordModel *)model
//{
//    self.model = model;
//
//    NSArray *imgArray = [model.imagepath componentsSeparatedByString:@","];
//
//    NSLog(@"llll----lllll%@",imgArray);
//
//    self.nameLabel.text = @"客服咨询";
//
//    self.contentLabel.text = [NSString stringWithFormat:@"问题：%@",model.content];
//
//
//    self.timeLabelContent.text = model.createtime;
//
//    NSMutableArray *arr = [NSMutableArray array];
//
//
//    if (model.imagepath.length <= 0) {
//
//        imgArray = nil;
//
//    }else{
//
//
//        imgArray = [model.imagepath componentsSeparatedByString:@","];
//
//        for (NSString *obj in imgArray) {
//
//            if (![obj isEqualToString:@""]) {
//
//                [arr addObject:obj];
//
//            }
//
//        }
//
//
//    }
//
//    [self layoutUI:model.content imgArr:arr];
//    [self.friendCircleImageView cellDataWithImageArray:arr];
//
//}

- (void)cellDataWithAppionmentModel:(HZListDetailModel *)model{
    NSArray *imgArray = [model.images componentsSeparatedByString:@";"];
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr removeAllObjects];
    for (NSString *str in imgArray) {
        if ([str isEqualToString:@""]) {
            return;
        }
        [tempArr addObject:str];
    }
    NSLog(@"llll----lllll%@",tempArr);
    self.nameLabel.font  =FontNameAndSize(16);
    [self layoutUI:@"" imgArr:tempArr];
    [self.friendCircleImageView cellDataWithImageArray:tempArr];
}

- (void)cellDataWithAppionmentagreeModel:(AgreeBookModel *)model{
    NSArray *imgArray = [model.diagnoseimages componentsSeparatedByString:@";"];
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr removeAllObjects];
    for (NSString *str in imgArray) {
        if ([str isEqualToString:@""]) {
            return;
        }
        [tempArr addObject:str];
    }
    NSLog(@"llll----lllll%@",tempArr);
    self.nameLabel.font  =FontNameAndSize(16);
    [self layoutUI:@"" imgArr:tempArr];
    [self.friendCircleImageView cellDataWithImageArray:tempArr];
}

//- (void)cellDataWithModel1:(CaseDetailModel *)model
//{
//    NSArray *imgArray = [model.ywimages componentsSeparatedByString:@";"];
//
//    NSLog(@"llll----lllll%@",imgArray);
//    self.nameLabel.text = @"处方单、口服药物图片记录";
//    self.nameLabel.font  =FontNameAndSize(16);
//    [self layoutUI:@"" imgArr:imgArray];
//    [self.friendCircleImageView cellDataWithImageArray:imgArray];
//}

//- (void)cellDataWithModel2:(CaseDetailModel *)model
//{
//    NSArray *imgArray = [model.blimages componentsSeparatedByString:@";"];
//
//    NSLog(@"llll----lllll%@",imgArray);
//
//    self.nameLabel.text = @"检查报告手术小结、出院小结";
//    self.nameLabel.font  =FontNameAndSize(16);
//    //    self.contentLabel.text = [NSString stringWithFormat:@"问题：%@",model.content];
//    //    self.timeLabelContent.text = model.createtime;
//    NSMutableArray *arr = [NSMutableArray array];
//
//    if (model.blimages.length <= 0) {
//
//        imgArray = nil;
//
//    }else{
//
//        imgArray = [model.blimages componentsSeparatedByString:@";"];
//
//        for (NSString *obj in imgArray) {
//
//            if (![obj isEqualToString:@""]) {
//
//                [arr addObject:obj];
//
//            }
//
//        }
//
//
//    }
//
//    [self layoutUI:@"" imgArr:arr];
//    [self.friendCircleImageView cellDataWithImageArray:arr];
//}
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
            make.left.equalTo(self.nameLabel);
            make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
        }];
        
        [self.allContentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        targetViewOfFriendCircleImageView = self.contentLabel;
        
    }
    //设置friendCircleImageView 参数
    [self.friendCircleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(targetViewOfFriendCircleImageView.mas_bottom).offset(5);
        make.right.left.equalTo(self.nameLabel);
        
    }];
    
    //如果 "查看全部" 按钮被点击 则重置label约束
//    if (self.model.isSelect == YES) {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.nameLabel);
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
        make.right.left.equalTo(self.nameLabel);
        make.top.equalTo(targetViewOfTimeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
