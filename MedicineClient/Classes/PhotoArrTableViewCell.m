//
//  PhotoArrTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhotoArrTableViewCell.h"
#import "MyProfilwModel.h"
@interface PhotoArrTableViewCell()

@property (nonatomic,strong) PhotoCerImageView * friendCircleImageView;   //图片

@end

@implementation PhotoArrTableViewCell

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
    self.friendCircleImageView = [PhotoCerImageView new];
    [self.contentView addSubview:self.friendCircleImageView];
}

#pragma mark - 设置约束
- (void)setConstant
{
    
#pragma mark - friendCircleImageView每部已经自动计算高度
    [self.friendCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-16);
        make.left.mas_equalTo(16);
    }];
    
    NSArray *arr = @[@"医师资格证",@"工作牌"];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        
        [self.contentView addSubview:label];
        
        label.textColor = DefaultGrayLightTextClor;
        
        label.font = FontNameAndSize(16);
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = arr[i];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.friendCircleImageView.mas_bottom).mas_equalTo(10);
            
            make.left.mas_equalTo((16+(kScreenWidth-16*3)/2)*i);
            
            make.width.mas_equalTo((kScreenWidth-16*3)/2);
            
            make.height.mas_equalTo(25);
            
            make.bottom.mas_equalTo(-15);
        }];
        
    }

}

- (void)refreshWithModel:(MyProfilwModel *)model
{
    
    NSLog(@"%@",model.certification);
    
    NSMutableArray * imags = [NSMutableArray array];
    
    [imags safeAddObject:model.certification];
    
    [imags safeAddObject:model.workcard];
    
    [self.friendCircleImageView cellDataWithImageArray:imags];
    
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
