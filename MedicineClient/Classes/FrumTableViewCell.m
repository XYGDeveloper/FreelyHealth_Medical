//
//  FrumTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FrumTableViewCell.h"
#import "LTUITools.h"
#import "LunTanModel.h"
#import "MyAuswerModel.h"
#import "MyCollectionModel.h"
@interface FrumTableViewCell()

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

@property (nonatomic,strong)UILabel *line;


@end


@implementation FrumTableViewCell

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIView * v in self.subviews) {
        if ( [v isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")] ) {
            
            for (UIView * v2  in v.subviews) {
                if ( [v2 isKindOfClass:[UIImageView class]]) {
                    UIImageView *  imgView = (UIImageView *)v2;
                    
                    self.selected ? :[imgView setImage:[UIImage imageNamed:@"mycollection_dele_nor"]] ;
                    
                }
            }
            
        }
    }
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

//        UIView * v = [UIView new];
//        v.backgroundColor = [UIColor whiteColor];
//        //  self.selected = YES  Cell 显示的颜色
//        self.multipleSelectionBackgroundView = v;
//        //  self.selected = YES  钩 显示的颜色
//        self.tintColor = [UIColor whiteColor];
  
        //questionIcon
        self.QuestionIcon = [LTUITools lt_creatImageView];
        
        self.QuestionIcon.image = [UIImage imageNamed:@"frum_questionIcon"];
        
        [self.contentView addSubview:self.QuestionIcon];
        
        //question title
        self.QuestionTitle = [LTUITools lt_creatLabel];
        
        self.QuestionTitle.font  =Font(15);
        
        self.QuestionTitle.textAlignment = NSTextAlignmentLeft;
        
        self.QuestionTitle.textColor  =DefaultGrayLightTextClor;
        
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
        
        self.QuestionContent.font  =Font(17);
        
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
        
        //sep line
        self.SepIcon = [LTUITools lt_creatImageView];
        
        self.SepIcon.backgroundColor = DividerGrayColor;
        
        [self.contentView addSubview:self.SepIcon];
        
        //head image
        self.headIcon = [LTUITools lt_creatImageView];
        
        self.headIcon.layer.cornerRadius = 41/2;
        
        self.headIcon.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.headIcon];
        
        //name
        self.nameLabel = [LTUITools lt_creatLabel];
        
        self.nameLabel.font  =Font(15);
        
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.nameLabel.textColor  =DefaultBlackLightTextClor;
        
        [self.contentView addSubview:self.nameLabel];
        
        //jop and hotel
        self.JopAndHotelNameLabel = [LTUITools lt_creatLabel];
        
        self.JopAndHotelNameLabel.font  =Font(15);
        
        self.JopAndHotelNameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.JopAndHotelNameLabel.textColor  =DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.JopAndHotelNameLabel];
            
        //auswer content
        self.AuswerLabel = [LTUITools lt_creatLabel];
        
        self.AuswerLabel.font  =Font(16);
        
        self.AuswerLabel.textAlignment = NSTextAlignmentLeft;
        
        self.AuswerLabel.textColor  =DefaultGrayTextClor;
        
        [self.contentView addSubview:self.AuswerLabel];
        
        //thump count
        
        self.thumpUpCount = [LTUITools lt_creatLabel];
        
        self.thumpUpCount.font  =Font(14);
        
        self.thumpUpCount.textColor = DefaultGrayLightTextClor;
        
        self.thumpUpCount.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.thumpUpCount];
        
        self.AuswerLabel.font  =Font(16);
        
        self.AuswerLabel.textAlignment = NSTextAlignmentLeft;
        
        self.AuswerLabel.textColor  = DefaultGrayTextClor;
        
        //thump button
        
        self.thumpUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.thumpUpButton setBackgroundImage:[UIImage imageNamed:@"thumb_up_button"] forState:UIControlStateNormal];
        
        
        [self.contentView addSubview:self.thumpUpButton];
        
        
        self.ReplayTime = [LTUITools lt_creatLabel];
        
        self.ReplayTime.font  =Font(12);
        
        self.ReplayTime.textAlignment = NSTextAlignmentLeft;
        
        self.ReplayTime.textColor  =DefaultGrayLightTextClor;
        
        [self.contentView addSubview:self.ReplayTime];
        
        self.line = [LTUITools lt_creatLabel];
        
        self.line.backgroundColor = DefaultBackgroundColor;
        
        [self.contentView addSubview:self.line];
        
    
        [self layOutUI];
        
        
        
    }
    
    return self;
    

}


- (void)layOutUI{

    CGFloat margin = 16;
    
    [self.QuestionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        
        make.width.height.mas_equalTo(18);
        
        make.top.mas_equalTo(10);
        
    }];
    
    [self.QuestionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.QuestionIcon.mas_right).mas_equalTo(6);
        
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
        
        make.top.mas_equalTo(self.QuestionContent.mas_bottom);
        
        make.width.mas_equalTo(kScreenWidth/3 + 60);
        
        make.height.mas_equalTo(25);
        
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
        
        make.left.mas_equalTo(self.scanCount.mas_right).mas_equalTo(4);
        
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
    
    
    [self.SepIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.PublishTime.mas_bottom);
        make.left.mas_equalTo(self.QuestionContent);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_SepIcon.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(16);
        make.width.height.mas_equalTo(41);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.headIcon.mas_right).mas_equalTo(15);
        
        make.top.mas_equalTo(self.headIcon);
        
        make.width.mas_equalTo(100);
        
        make.height.mas_equalTo(20);
        
    }];
    
    
    [self.JopAndHotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.AuswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headIcon.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.headIcon.mas_left);
        make.right.mas_equalTo(-16);
    }];
    
    [self.ReplayTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.QuestionContent.mas_left);
        
        make.top.mas_equalTo(self.AuswerLabel.mas_bottom);
        
        make.width.mas_equalTo(kScreenWidth/3 + 60);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.thumpUpCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.thumpUpButton.mas_left).mas_equalTo(-3);
        
        make.centerY.mas_equalTo(self.thumpUpButton.mas_centerY);
        
        make.width.mas_equalTo(self.nameLabel);
        
        make.height.mas_equalTo(20);
        
    }];
    
    [self.thumpUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.ReplayTime.mas_right);
        
        make.centerY.mas_equalTo(self.self.ReplayTime.mas_centerY);
        
        make.width.height.mas_equalTo(14);
        
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.ReplayTime.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(0);
    }];
    
    

}



- (void)layoutSubviews
{

    for (UIView * v in self.subviews) {
        if ( [v isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")] ) {
            for (UIView * v2  in v.subviews) {
                if ( [v2 isKindOfClass:[UIImageView class]]) {
                    UIImageView *  imgView = (UIImageView *)v2;
                    self.selected ? [imgView setImage:[UIImage imageNamed:@"mycollection_dele_sel"]] : [imgView setImage:[UIImage imageNamed:@"mycollection_dele_nor"]];
                    
                    
                }
            }
            
        }
    }
    
    [super layoutSubviews];
    
    
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


- (void)cellDataWithModel:(LunTanModel *)model
{

    self.QuestionTitle.text = [NSString stringWithFormat:@"%@提出的问题",model.phone];
    
    self.scanCount.text  = model.readnum;
    
    self.PublishTime.text  = @"2017-07-08 18:39发布";
    
    self.commentCount.text = @"23";
    
    self.ReplayTime.text = @"2017-07-08 18:39回复";
    
//    NSString *question = @"中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？";
//    
//    CGFloat height = [self contentHeight:question];
//    
//    [self.QuestionContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.QuestionIcon.mas_bottom).offset(10);
//        make.left.equalTo(self.QuestionIcon);
//        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
//        make.height.mas_equalTo(height);
//    }];
    
    self.headIcon.image = [UIImage imageNamed:@""];
    
    self.nameLabel.text  =@"张六三";

    self.JopAndHotelNameLabel.text = @"副主任医师 | 上海交通大学附属医院";
    
    self.thumpUpCount.text = @"100";
    
    self.QuestionContent.text = @"中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展";
    
    self.AuswerLabel.text = @"病情分析：什么是酒后失忆症，失忆症一词，很多人对失忆症是很敏感的，失忆症也是分好......";

    
}

- (void)cellDataWithauswertModel:(MyAuswerModel *)model
{

    self.QuestionTitle.text = [NSString stringWithFormat:@"%@",model.phone];
    
    self.scanCount.text  = model.readnum;
    
    self.PublishTime.text  = [NSString stringWithFormat:@"%@发布",model.createtime];
    
    self.commentCount.text = model.answernum;
    
    self.ReplayTime.text = [NSString stringWithFormat:@"%@回复",model.backtime];
    
    //    NSString *question = @"中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？中西医治疗乳腺癌应该遵循哪些原则？乳腺癌中西医结合治疗进展？";
    //
    //    CGFloat height = [self contentHeight:question];
    //
    //    [self.QuestionContent mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.QuestionIcon.mas_bottom).offset(10);
    //        make.left.equalTo(self.QuestionIcon);
    //        make.width.mas_lessThanOrEqualTo([self contentLabelMaxWidth]);
    //        make.height.mas_equalTo(height);
    //    }];
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.facepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
    self.nameLabel.text  = model.dname;
    
    self.JopAndHotelNameLabel.text = [NSString stringWithFormat:@"%@ |%@",model.job,model.hname];
    
    self.thumpUpCount.text = model.agreenum;
    
    self.QuestionContent.text = model.title;
    
    self.AuswerLabel.text = model.answer;
    
}

- (void)cellDataWithCollectionModel:(MyCollectionModel *)model
{

    NSRange range = {3,4};
    
    NSString *phone = [model.phone stringByReplacingCharactersInRange:range withString:@"****"];
    
    self.QuestionTitle.text = [NSString stringWithFormat:@"%@提出的问题",phone];
    
    self.scanCount.text  = model.readnum;
    
    self.PublishTime.text  = [NSString stringWithFormat:@"%@发布",model.createtime];
    
    self.commentCount.text = model.answernum;
    
    self.ReplayTime.text = [NSString stringWithFormat:@"%@回复",model.backtime];
    

    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.facepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
    self.nameLabel.text  = model.dname;
    
    self.JopAndHotelNameLabel.text = [NSString stringWithFormat:@"%@ |%@",model.job,model.hname];
    
    self.thumpUpCount.text = model.agreenum;
    
    self.QuestionContent.text = model.title;
    
    self.AuswerLabel.text = model.answer;


}





@end
