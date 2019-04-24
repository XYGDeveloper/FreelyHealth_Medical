//
//  HZHandleTableViewCell.m
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZHandleTableViewCell.h"
#import "MyAppionmentModel.h"
@interface HZHandleTableViewCell()

@property (nonatomic,strong)UIImageView *stateImg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *stateLabel;
@property (nonatomic,strong)UILabel *atimeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *aImage;
@property (nonatomic,strong)UILabel *aLabel;
@property (nonatomic,strong)UIButton *attend;
@property (nonatomic,strong)UIButton *noAttend;
@end

@implementation HZHandleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.stateImg = [UIImageView new];
        [self.contentView addSubview:self.stateImg];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = Font(17);
        self.nameLabel.textColor = DefaultBlackLightTextClor;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.stateLabel = [[UILabel alloc]init];
        self.stateLabel.font = Font(14);
        self.stateLabel.textColor = AppStyleColor;
        self.stateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.stateLabel];
        
        self.atimeLabel = [[UILabel alloc]init];
        self.atimeLabel.font = FontNameAndSize(14);
        self.atimeLabel.textColor = DefaultGrayTextClor;
        self.atimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.atimeLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = FontNameAndSize(14);
        self.timeLabel.textColor = DefaultGrayTextClor;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.aImage = [[UIImageView alloc]init];
        self.aImage.image = [UIImage imageNamed:@"count_att"];
        [self.contentView addSubview:self.aImage];
        
        self.aLabel = [[UILabel alloc]init];
        self.aLabel.font = FontNameAndSize(14);
        self.aLabel.textColor = DefaultGrayTextClor;
        self.aLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.aLabel];
        
        self.noAttend = [UIButton buttonWithType:UIButtonTypeCustom];
        self.noAttend.backgroundColor = [UIColor whiteColor];
        [self.noAttend setTitle:@"不参加" forState:UIControlStateNormal];
        [self.noAttend setTitleColor:AppStyleColor forState:UIControlStateNormal];
        self.noAttend.titleLabel.font = FontNameAndSize(14);
        [self.contentView addSubview:self.noAttend];
        [self.noAttend addTarget:self action:@selector(noAttendHandle) forControlEvents:UIControlEventTouchUpInside];
        self.attend = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attend.backgroundColor = AppStyleColor;
        [self.attend setTitle:@"参加" forState:UIControlStateNormal];
        [self.attend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.attend.titleLabel.font = FontNameAndSize(14);
        [self.contentView addSubview:self.attend];
        [self.attend addTarget:self action:@selector(attendHandle) forControlEvents:UIControlEventTouchUpInside];

        [self layOut];
        
    }
    return self;
}
- (void)attendHandle{
    if (self.attendblock) {
        self.attendblock();
    }
}

- (void)noAttendHandle{
    if (self.notattendblock) {
        self.notattendblock();
    }
}

- (void)layOut{
    [self.stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(22);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(30);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateImg.mas_right).mas_equalTo(20);
        make.top.mas_equalTo(self.stateImg.mas_top);
        make.width.mas_equalTo(kScreenWidth - 20- 20 -20 - 80);
        make.height.mas_equalTo(15);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_equalTo(0);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.atimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.atimeLabel.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    
    [self.aImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(15);
    }];
    [self.aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.aImage.mas_right).mas_equalTo(8);
        make.centerY.mas_equalTo(self.aImage.mas_centerY);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    
    [self.noAttend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aLabel.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(0);
    }];
    [self.attend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aLabel.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)refreshWITHModel:(MyAppionmentModel *)model{
    self.nameLabel.text = model.topic;
    self.atimeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
    [self.stateImg sd_setImageWithURL:[NSURL URLWithString:@""]];
    self.atimeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
    NSString *creatPerson;
    if ([model.issystem isEqualToString:@"1"]) {
        creatPerson = @"直医客服";
    }else{
        creatPerson = model.dname;
    }
    NSString *startstr = [NSString stringWithFormat:@"%@/%@人确认参加",model.canyucount,model.membercount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:startstr];
    NSLog(@"==========%lu",(unsigned long)startstr.length);
    [str addAttribute:NSForegroundColorAttributeName value:AppStyleColor range:NSMakeRange(0,1)];
    self.aLabel.attributedText = str;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ | %@",creatPerson,[Utils timeFormatterWithTimeString:model.starttime]];
    if ([model.status isEqualToString:@"待会诊"]) {
        self.stateLabel.text = @"待会诊";
        self.stateImg.image = [UIImage imageNamed:@"hz_handle"];
        self.stateLabel.textColor = AppStyleColor;
    }else if ([model.status isEqualToString:@"待处理"]){
        self.stateImg.image = [UIImage imageNamed:@"hz_wailt"];
        self.stateLabel.textColor = DefaultRedTextClor;
        self.stateLabel.text = @"待处理";
    }else if ([model.status isEqualToString:@"取消"]){
        self.stateImg.image = [UIImage imageNamed:@"hz_bcj"];
        self.stateLabel.textColor = DefaultGrayTextClor;
        self.stateLabel.text = @"取消";
    }else if ([model.status isEqualToString:@"完成"]){
        self.stateImg.image = [UIImage imageNamed:@"hz_finish"];
        self.stateLabel.textColor = DefaultGrayTextClor;
        self.stateLabel.text = @"完成";
    }else{
        self.stateImg.image = [UIImage imageNamed:@"hz_cancel"];
        self.stateLabel.textColor = DefaultRedTextClor;
        self.stateLabel.text = @"不参加";
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