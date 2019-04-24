//
//  MyPointsViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyPointsViewController.h"
#import "PointsTableViewCell.h"
#import "UIImage+GradientColor.h"
@interface MyPointsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _lastPosition;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *pointArray;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIImageView *bgImage;

@end

@implementation MyPointsViewController


- (void)viewWillAppear:(BOOL)animated
{

    [self hiddenNavigationControllerBar:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    [self hiddenNavigationControllerBar:NO];

}


- (NSMutableArray *)pointArray
{

    if (!_pointArray) {
        
        _pointArray = [NSMutableArray array];
    }

    return _pointArray;

}


- (void)refreshWithPointsCount:(NSString *)count{

    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 176)];
    
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 176)];

    self.bgImage.userInteractionEnabled = YES;
    
//    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
//    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
//    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:self.bgImage.size];
    
    self.bgImage.image = [UIImage imageNamed:@"mypoints"];
    
    [self.headView addSubview:self.bgImage];
    
    //Left
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    

    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [self.bgImage addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(self.headView.mas_left).mas_equalTo(16);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        
    }];
    
    [backButton addTarget:self action:@selector(backRootView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *label = [LTUITools lt_creatLabel];
    
    label.text = @"我的积分";

    label.textColor = [UIColor whiteColor];
    
    label.font  =Font(18);
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.bgImage addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(self.bgImage.mas_centerX);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(25);
        
    }];
    
    UILabel *labelCount = [LTUITools lt_creatLabel];
    
    
    labelCount.textColor = [UIColor whiteColor];
    
    labelCount.font  =Font(50);
    
    labelCount.textAlignment = NSTextAlignmentCenter;
    
    labelCount.text = count;
    
    [self.bgImage addSubview:labelCount];
    
    [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.bgImage.mas_centerY);
        make.centerX.mas_equalTo(self.bgImage.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(80);
        
    }];
  
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    PointsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PointsTableViewCell class])];
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor  =DefaultBackgroundColor;

    [self refreshWithPointsCount:@"500"];

    
    self.tableview.backgroundColor = DefaultBackgroundColor;

    [self.tableview registerNib:[UINib nibWithNibName:@"PointsTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PointsTableViewCell class])];
    
    self.tableview.tableHeaderView = self.headView;
    
//    self.tableview.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        //接口请求
//        //..........
//        
//        
//        
//        
//    }];
//    
//    
//    [self.tableview.mj_header beginRefreshing];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    NSLog(@"上下偏移量 OffsetY:%f ->",offset_Y);
    
    //1.处理图片放大
    CGFloat imageH = self.headView.size.height;
    CGFloat imageW = kScreenWidth;
    
    //下拉
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.bgImage.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        self.bgImage.frame = self.headView.bounds;
    }
    
    //2.处理导航颜色渐变  3.底部工具栏动画
    
    if (offset_Y > Max_OffsetY)
    {
        CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:alpha]];
        
        if (offset_Y - _lastPosition > 5)
        {
            //向上滚动
            _lastPosition = offset_Y;
            
        }
        else if (_lastPosition - offset_Y > 5)
        {
            // 向下滚动
            _lastPosition = offset_Y;
        }
        //        self.title = alpha > 0.8? self.nikeNameLabel.text:@"";
        
        //        [self setNavigationTitleViewWithView:alpha > 0.8? self.nikeNameLabel.text:@"" timerWithTimer:nil];
        
    }
    else
    {
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:0]];
        
    }
    
    //滚动至顶部
    
    if (offset_Y < 0) {
        
    }
    
}


- (void)backRootView{

    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
