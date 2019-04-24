//
//  OrderListViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderListViewController.h"
#import "TaskTableViewCell.h"
#import "DetailViewController.h"
#import "MyTaskModel.h"
#import "MyTaskRequest.h"
#import "TaskListApi.h"
#import "EmptyManager.h"
#import "LSProgressHUD.h"
#import "QQWRefreshHeader.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "GetAuthStateManager.h"
#import "MyProfileViewController.h"
@interface OrderListViewController ()<UITableViewDelegate, UITableViewDataSource, ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)TaskListApi *taskapi;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation OrderListViewController



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.orderStatus = orderStatus;
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:KNotification_rejecttask object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:KNotification_finishtask object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:KNotification_receTask object:nil];
        NSLog(@"%@",self.orderStatus);
        
    }
    return self;
}

- (void)notificationRecieved:(NSNotification *)note {
    
    if ([note.name isEqualToString:KNotification_receTask] || [note.name isEqualToString:KNotification_finishtask] || [note.name isEqualToString:KNotification_rejecttask]) {
        
        [self.tableview.mj_header beginRefreshing];
        
    }
    
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
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表是空的" operationText:nil operationBlock:nil];
    } else {
        [self.listArr removeAllObjects];
        [self.listArr addObjectsFromArray:responsObject];
        [self.tableview reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];
    [self.hud hide:YES];
    weakify(self);
    if ([User LocalUser].token) {
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    }else{
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无数据" operationText:nil operationBlock:nil];
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
    
    self.taskapi = [[TaskListApi alloc] initWithOrderStatus:self.orderStatus];
    
    NSLog(@"======%@",self.orderStatus);
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.taskapi.delegate = self;
    
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@1);
        make.bottom.mas_equalTo(-60);
    }];

    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MyTaskModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    [cell refreshwithModel:model];
   
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
    if ([Utils showLoginPageIfNeeded]) {} else {
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                DetailViewController *detail = [[DetailViewController alloc]init];
                detail.taskno = model.taskno;
                detail.hidesBottomBarWhenPushed = YES;
                detail.title = @"任务详情";
                detail.id = model.id;
                detail.tasktype = self.orderStatus;
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
    }
}


-(void)showScanMessageTitle:(NSString *)title content:(NSString *)content leftBtnTitle:(NSString *)left rightBtnTitle:(NSString *)right tag:(NSInteger)tag{
    NSArray  *buttonTitles;
    if (left && right) {
        buttonTitles   =  @[AlertViewNormalStyle(left),AlertViewRedStyle(right)];
    }else{
        buttonTitles = @[AlertViewRedStyle(left)];
    }
    AlertViewMessageObject *messageObject = MakeAlertViewMessageObject(title,content, buttonTitles);
    [AlertView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:tag];
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 8000) {
        if ([event isEqualToString:@"重新认证"]){
            MyProfileViewController *profile = [[MyProfileViewController alloc]init];
            profile.title = @"我的资料";
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
    [messageView hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
