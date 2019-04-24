//
//  AppionmentInfoTableViewCell.m
//  app
//
//  Created by XI YANGUI on 2018/4/26.
//  Copyright © 2018年 XI YANGUI. All rights reserved.
//

#import "AppionmentInfoTableViewCell.h"
#import <Masonry.h>
#import "HZListDetailModel.h"
@interface AppionmentInfoTableViewCell()
@property (nonatomic,strong)UILabel *subject;
@property (nonatomic,strong)UILabel *subjectContent;
@property (nonatomic,strong)UILabel *info;
@property (nonatomic,strong)UILabel *infoContent;

@end

@implementation AppionmentInfoTableViewCell

- (UILabel *)subject{
    if (!_subject) {
        _subject = [[UILabel alloc]init];
        _subject.textAlignment = NSTextAlignmentLeft;
        _subject.textColor = DefaultGrayLightTextClor;
        _subject.font = FontNameAndSize(16);
        _subject.text = @"会诊主题";
    }
    return _subject;
}

- (UILabel *)subjectContent{
    if (!_subjectContent) {
        _subjectContent = [[UILabel alloc]init];
        _subjectContent.textAlignment = NSTextAlignmentLeft;
        _subjectContent.textColor = DefaultGrayTextClor;
        _subjectContent.font = FontNameAndSize(16);
    }
    return _subjectContent;
}

- (UILabel *)info{
    if (!_info) {
        _info = [[UILabel alloc]init];
        _info.textAlignment = NSTextAlignmentLeft;
        _info.textColor = DefaultGrayLightTextClor;
        _info.font = FontNameAndSize(16);
        _info.text = @"患者信息";
    }
    return _info;
}

- (UILabel *)infoContent{
    if (!_infoContent) {
        _infoContent = [[UILabel alloc]init];
        _infoContent.textAlignment = NSTextAlignmentLeft;
        _infoContent.textColor = DefaultGrayTextClor;
        _infoContent.font = FontNameAndSize(16);
    }
    return _infoContent;
}

- (void)layOut{
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.subjectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.subject.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.subjectContent.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.infoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.info.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.subject];
        [self.contentView addSubview:self.subjectContent];
        [self.contentView addSubview:self.info];
        [self.contentView addSubview:self.infoContent];
        
        [self layOut];

    }
    return self;
}

- (void)refreshWIithDetailModel:(HZListDetailModel *)model{
    self.subjectContent.text = model.topic;
    self.infoContent.text = [NSString stringWithFormat:@"%@,%@,%@",model.name,model.sex,model.age];
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
