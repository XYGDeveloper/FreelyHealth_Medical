//
//  ReferListViewController.m
//  MedicineClient
//
//  Created by L on 2017/10/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReferListViewController.h"
#import "TaskTableViewCell.h"
#import "DetailViewController.h"
#import "MyTaskModel.h"
#import "MyTaskRequest.h"
#import "MyReferApi.h"
#import "EmptyManager.h"
#import "LSProgressHUD.h"
#import "ReferDetailViewController.h"
@interface ReferListViewController ()<UITableViewDelegate, UITableViewDataSource, ApiRequestDelegate>

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)MyReferApi *taskapi;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation ReferListViewController

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.orderStatus = orderStatus;
        
    }
    return self;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = DefaultBackgroundColor;
        [_tableview registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaskTableViewCell class])];
    }
    return _tableview;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    NSLog(@"订单列表%@",responsObject);
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [self.hud hide:YES];

    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表还是空的" operationText:nil operationBlock:nil];
    } else {
        
        [self.listArr removeAllObjects];
        
        [self.listArr addObjectsFromArray:responsObject];
        
        [self.tableview reloadData];
        
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];
    [self.hud hide:YES];

    if (self.listArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.tableview.mj_footer endRefreshing];
    
    [self.listArr addObjectsFromArray:responsObject];
    [self.tableview reloadData];
    
}


- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskapi = [[MyReferApi alloc] initWithOrderStatus:self.orderStatus];
    
    NSLog(@"======%@",self.orderStatus);
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.taskapi.delegate = self;
    
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.mas_equalTo(0);
    }];
    
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.taskapi refresh];
    }];
    
    //    self.tableview.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
    //        __strong typeof(wself) sself = wself;
    //        [sself.taskapi loadNextPage];
    //    }];
    
    [self.tableview.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
    
    
}


- (NSMutableArray *)listArr
{
    
    if (!_listArr) {
        
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MyTaskModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    [cell refreshwithModel1:model];
    
    cell.block = ^{
        
        ReferDetailViewController *detail = [[ReferDetailViewController alloc]init];
        
        detail.hidesBottomBarWhenPushed = YES;
        
        detail.title = @"转诊详情";
        
        detail.taskno = model.taskno;
        
        detail.status = model.status;
      
     [self.navigationController pushViewController:detail animated:YES];
        
    };
    
    return cell;
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return 0.0000001;
        
    }else{
        
        if (section == 0)
        return 14;
        return tableView.sectionHeaderHeight;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTaskModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    ReferDetailViewController *detail = [[ReferDetailViewController alloc]init];
    
    detail.hidesBottomBarWhenPushed = YES;
    
    detail.title = @"转诊详情";
    
    detail.taskno = model.taskno;
    
    detail.status = model.status;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
