//
//  TeamDesTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamDesTableViewCell.h"
#import "MyTeamModel.h"
@interface TeamDesTableViewCell()

@property (nonatomic,strong)UILabel *titlelabel;

@property (nonatomic,strong)UILabel *sepline;


@end



@implementation TeamDesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        self.titlelabel = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.titlelabel];
        
        self.titlelabel.font = FontNameAndSize(16);
        
        self.titlelabel.numberOfLines = 0;
        
        self.titlelabel.textColor = DefaultGrayTextClor;
        
        self.sepline = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.sepline];
        
        self.sepline.backgroundColor = [UIColor clearColor];
        
        [self layOut];
        
    }
    
    return self;

}


- (void)layOut{

    UIView *viewLine = [[UIView alloc]init];
    
    viewLine.backgroundColor = DividerDarkGrayColor;
    
    [self.contentView addSubview:viewLine];
    
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
      [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(viewLine.mas_bottom).mas_equalTo(10);
          make.left.mas_equalTo(10);
          make.right.mas_equalTo(-10);
      }];
    
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titlelabel.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(0);
    }];
    
}


- (void)refreshSubviewWithModel:(MyTeamModel *)model{
    self.titlelabel.text = model.introduction;
   
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
