//
//  MyinviteViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyinviteViewController.h"
#import "MySendModel.h"
#import "MySendsRequest.h"
#import "MySendsApi.h"
#import "EmptyManager.h"
#import "GListTableViewCell.h"
#import "GlistDetailViewController.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "GetAuthStateManager.h"
#import "MyProfileViewController.h"
@interface MyinviteViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)UITableView *groupTableview;

@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)MySendsApi *api;

@end

@implementation MyinviteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self firstReresh];
    
}

- (void)firstReresh
{
    
    [self.groupTableview.mj_header beginRefreshing];

}

- (MySendsApi *)api
{
    if (!_api) {
        
        _api = [[MySendsApi alloc]init];
        
        _api.delegate = self;
        
    }
    return _api;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (UITableView *)groupTableview
{
    
    if (!_groupTableview) {
        _groupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _groupTableview.delegate = self;
        _groupTableview.dataSource = self;
        _groupTableview.backgroundColor = DefaultBackgroundColor;
    }
    return _groupTableview;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    [self.groupTableview.mj_header endRefreshing];
    
    if (self.listArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.groupTableview response:command.response operationBlock:^{
            strongify(self)
            [self.groupTableview.mj_header beginRefreshing];
        }];
        
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    [self.groupTableview.mj_header endRefreshing];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.groupTableview];
    
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.groupTableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表是空的" operationText:nil operationBlock:nil];
    } else {
        
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:responsObject];
        
        [self.groupTableview reloadData];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.groupTableview];
    
    [self.groupTableview registerClass:[GListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GListTableViewCell class])];
    
    self.groupTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        MysendHeader *head = [[MysendHeader alloc]init];
        
        head.target = @"huizhenControl";
        
        head.method = @"myFaYaoqing";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        MySendBody *body = [[MySendBody alloc]init];
        
        MySendsRequest *request = [[MySendsRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api MyInvite:request.mj_keyValues.mutableCopy];
        
    }];
    
    [self.groupTableview.mj_header beginRefreshing];
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GListTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MySendModel *model = [self.listArray objectAtIndex:indexPath.row];
    
    [cell refreshWithModel1:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        MySendModel *model = [self.listArray objectAtIndex:indexPath.row];
        
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                if ([model.canyu isEqualToString:@"Y"]) {
                    GlistDetailViewController *group = [[GlistDetailViewController alloc]initWithType:GroupConsultTypeAgree withID:model.id isAgree:YES];
                    group.mdtgroupid = model.mdtgroupid;
                    group.mdtgroupname = model.item;
                    group.title = @"会诊详情";
                    [self.navigationController pushViewController:group animated:YES];
                }else{
                    GlistDetailViewController *group = [[GlistDetailViewController alloc]initWithType:GroupConsultTypeJoinOrNot withID:model.id];
                    group.title = @"会诊详情";
                    [self.navigationController pushViewController:group animated:YES];
                }
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return 0.0000001;
        
    }else{
        
        if (section == 0)
            return 0.0000001;
        return tableView.sectionHeaderHeight;
        
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    return header;
    
}

@end
