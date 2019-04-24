//
//  MyGroupConViewController.m
//  MedicineClient
//
//  Created by L on 2017/12/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.

#import "MyGroupConViewController.h"
#import "MyGroupListTableViewCell.h"
#import "MySendModel.h"
#import "MySendsRequest.h"
#import "MySendsInviteApi.h"
#import "EmptyManager.h"
#import "MyGroupDetailViewController.h"
#import "MyGroupConDetailViewController.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
@interface MyGroupConViewController ()<UITableViewDelegate, UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)MySendsInviteApi *api;

@end

@implementation MyGroupConViewController

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = DefaultBackgroundColor;
        [_tableview registerClass:[MyGroupListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyGroupListTableViewCell class])];
    }
    return _tableview;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    NSLog(@"订单列表%@",responsObject);
    [self.tableview.mj_header endRefreshing];
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
    if (self.listArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    
    [self setRightNavigationItemWithTitle:@"发起会诊" action:@selector(applyGroupCon)];

    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.mas_equalTo(0);
    }];

    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        MysendHeader *head = [[MysendHeader alloc]init];
        head.target = @"huizhenControl";
        head.method = @"huizhenList";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        MySendBody *body = [[MySendBody alloc]init];
        MySendsRequest *request = [[MySendsRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.api MysendInvite:request.mj_keyValues.mutableCopy];
      }];
    
       [self.tableview.mj_header beginRefreshing];
    
}

- (void)applyGroupCon{
    
    [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
        if ([auth isEqualToString:@"3"]) {
            MyGroupDetailViewController *detail = [[MyGroupDetailViewController alloc]init];
            detail.title = @"发起会诊";
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [Utils postMessage:@"认证失败，请重新认证" onView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyProfileViewController *profile = [[MyProfileViewController alloc]init];
                profile.title = @"我的资料";
                [self.navigationController pushViewController:profile animated:YES];
            });
        }
    }];
 
}

- (NSMutableArray *)listArr
{
    
    if (!_listArr) {
        
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
    
}

- (MySendsInviteApi *)api
{
    if (!_api) {
        
        _api = [[MySendsInviteApi alloc]init];
        
        _api.delegate = self;
        
    }
    return _api;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyGroupListTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MySendModel *model = [self.listArr objectAtIndex:indexPath.row];

    [cell refreshWithModel1:model];

    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [tableView fd_heightForCellWithIdentifier:@"MyGroupListTableViewCell" cacheByIndexPath:indexPath configuration: ^(MyGroupListTableViewCell *cell) {
            
            MySendModel *model = [self.listArr objectAtIndex:indexPath.row];

            [cell refreshWithModel1:model];
        }];
    
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
    MySendModel *model = [self.listArr objectAtIndex:indexPath.row];
//    MyGroupConDetailViewController *group = [[GlistDetailViewController alloc]initWithType:GroupConsultTypeAgree withID:model.id isAgree:YES];
//    group.mdtgroupid = model.mdtgroupid;
//    group.mdtgroupname = model.item;
//    group.title = @"我的会诊详情";
//    [self.navigationController pushViewController:group animated:YES];
    MyGroupConDetailViewController *detail = [[MyGroupConDetailViewController alloc]init];
    detail.id = model.id;
    detail.title = @"我的会诊详情";
    [self.navigationController pushViewController:detail animated:YES];
}

@end
