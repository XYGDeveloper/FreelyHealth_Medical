//
//  MyHZListViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyHZListViewController.h"
#import "HZListTableViewCell.h"
#import "MyHzListRequest.h"
#import "MyHZlistApi.h"
#import "EmptyManager.h"
#import "AttenderViewController.h"
#import "MyHZlistModel.h"
#import "TeamDetailViewController.h"
@interface MyHZListViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,strong)NSString *huzihenid;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)MyHZlistApi *api;
@property (nonatomic,strong)NSMutableArray *list;
@end

@implementation MyHZListViewController

- (MyHZlistApi *)api{
    if (!_api) {
        _api = [[MyHZlistApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    NSLog(@"订单列表%@",responsObject);
    [self.tableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表是空的" operationText:nil operationBlock:nil];
    } else {
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:responsObject];
        [self.tableview reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
    [self.tableview.mj_header endRefreshing];
    weakify(self);
    [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
        strongify(self)
        [self.tableview.mj_header beginRefreshing];
    }];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource  =self;
        _tableview.separatorColor = HexColor(0xe7e7e9);
        _tableview.backgroundColor = DefaultBackgroundColor;
        [_tableview registerClass:[HZListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HZListTableViewCell class])];
    }
    return _tableview;
}
- (void)setLayOutsubs{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请列表";
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setRightNavigationItemWithTitle:@"添加" action:@selector(add)];
    [self.view addSubview:self.tableview];
    [self setLayOutsubs];
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [Utils addHudOnView:self.view];
        //请求签名
        MyHzlistHeader *header = [[MyHzlistHeader alloc]init];
        header.target = @"doctorHuizhenControl";
        header.method = @"myHuizhenYaoqing";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        MyHzlistBody *bodyer = [[MyHzlistBody alloc]init];
        bodyer.type = self.orderStatus;
        bodyer.id = self.huzihenid;
        MyHzListRequest *requester = [[MyHzListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester);
        [self.api getMylist:requester.mj_keyValues.mutableCopy];
        
    }];
    [self.tableview.mj_header beginRefreshing];
    
}

-(void)add{
    AttenderViewController *attend = [AttenderViewController new];
    attend.title = @"添加人员";
    [self.navigationController pushViewController:attend animated:YES];
}

- (id)initWithOrderStatus:(NSString *)orderStatus withHuizhenid:(NSString *)huizhenid{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.orderStatus = orderStatus;
        self.huzihenid = huizhenid;
    }
    return self;
}


#pragma mark- UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HZListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZListTableViewCell class])];
    MyHZlistModel *model = [self.list objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshWithmodel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHZlistModel *model = [self.list objectAtIndex:indexPath.row];
    if ([model.utype isEqualToString:@"2"] ||[model.utype isEqualToString:@"3"] ) {
        TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
        detail.ID = model.id;
        detail.title = model.name;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
