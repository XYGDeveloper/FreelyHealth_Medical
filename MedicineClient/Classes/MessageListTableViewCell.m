//
//  MessageListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "MyMessageModel.h"
@interface MessageListTableViewCell()

@end

@implementation MessageListTableViewCell

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@"message_notice"];
    }
    return _headImage;
}
- (UILabel *)messageNameLabel{
    if (!_messageNameLabel) {
        _messageNameLabel = [[UILabel alloc]init];
        _messageNameLabel.textAlignment = NSTextAlignmentLeft;
        _messageNameLabel.textColor = DefaultBlackLightTextClor;
        _messageNameLabel.font = Font(16);
    }
    return _messageNameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = DefaultGrayLightTextClor;
        _timeLabel.font = Font(14);
    }
    return _timeLabel;
}

- (UILabel *)messageContentLabel{
    if (!_messageContentLabel) {
        _messageContentLabel = [[UILabel alloc]init];
        _messageContentLabel.textAlignment = NSTextAlignmentLeft;
        _messageContentLabel.font = FontNameAndSize(15);
        _messageContentLabel.textColor = DefaultGrayTextClor;
    }
    return _messageContentLabel;
}
- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = FontNameAndSize(10);
        _badgeLabel.layer.cornerRadius = 7.5;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.textColor = [UIColor whiteColor];
    }
    return _badgeLabel;
}

- (UILabel *)sepview{
    if (!_sepview) {
        _sepview = [[UILabel alloc]init];
        _sepview.backgroundColor = DefaultBackgroundColor;
    }
    return _sepview;
}

- (void)layOut{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(-10.5);
        make.bottom.mas_equalTo(self.headImage.mas_top).mas_equalTo(10.5);
    }];
    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.messageNameLabel.mas_centerY);
        make.left.mas_equalTo(self.messageNameLabel.mas_right);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-20);
    }];
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.messageNameLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.messageContentLabel.mas_bottom);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.messageNameLabel];
        [self.contentView addSubview:self.messageContentLabel];
        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.sepview];

        [self layOut];
    }
    return self;
}

- (void)refreshWithModel:(NSString *)count{
    if ([count intValue] > 0) {
        self.badgeLabel.text = count;
        self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
         self.badgeLabel.backgroundColor = [UIColor whiteColor];
    }
    self.messageNameLabel.text = @"会话消息";
//    self.messageContentLabel.text = @"聊天会话消息";
}

- (void)refreshWithmodel:(MyMessageModel *)model counts:(NSString *)counts{
    self.headImage.image = [UIImage imageNamed:@"hz_message"];
    if (model.msg) {
        self.messageContentLabel.text = model.msg;
    }else{
        self.messageContentLabel.text = @"暂无消息通知";
    }
    if (model.createtime) {
        self.timeLabel.text = [Utils formateDate:model.createtime];
    }else{
        self.timeLabel.text = @"";
        
    }
    
    if ([counts intValue] >0) {
       
            self.badgeLabel.text = counts;
            self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
        self.badgeLabel.backgroundColor = [UIColor whiteColor];

    }
}

- (void)refreshWithmessage{
    self.headImage.image = [UIImage imageNamed:@"message_customer"];
    self.messageNameLabel.text  =@"客服消息提醒";
    if ([UdeskManager getLocalUnreadeMessagesCount] > 0) {
            self.badgeLabel.text = [NSString stringWithFormat:@"%ld",[UdeskManager getLocalUnreadeMessagesCount]];
            self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
        self.badgeLabel.backgroundColor = [UIColor whiteColor];
        
    }
    NSArray *message = [UdeskManager getLocalUnreadeMessages];
    NSLog(@"%ld   %@",[UdeskManager getLocalUnreadeMessagesCount],[UdeskManager getLocalUnreadeMessages]);
    if (message.count > 0) {
        UdeskMessage *messageobj = [message firstObject];
        self.messageContentLabel.text = [self filterHTML:messageobj.content];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:messageobj.timestamp];
        self.timeLabel.text = [[strDate componentsSeparatedByString:@" "] objectAtIndex:3];
    }else{
        self.messageContentLabel.text = @"无客服消息";
        self.timeLabel.text = @"";
    }
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
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
