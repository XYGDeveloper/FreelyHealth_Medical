//
//  SelectAdviceerViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectAdviceerViewController.h"
#import "SelectAdviceTableViewCell.h"
@interface SelectAdviceerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *adviceTableview;
@end

@implementation SelectAdviceerViewController

- (UITableView *)adviceTableview{
    if (!_adviceTableview) {
        _adviceTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _adviceTableview.delegate = self;
        _adviceTableview.dataSource = self;
        [_adviceTableview registerClass:[SelectAdviceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SelectAdviceTableViewCell class])];
        _adviceTableview.allowsMultipleSelection = NO;
    }
    return _adviceTableview;
}

- (void)setLayOut{
    [self.adviceTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.adviceTableview];
    [self setLayOut];
    // Do any additional setup after loading the view.
}

#pragma mark----UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    } else {
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectAdviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectAdviceTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
