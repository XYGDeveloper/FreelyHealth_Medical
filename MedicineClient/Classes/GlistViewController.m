//
//  GlistViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GlistViewController.h"
#import "MyInviteApi.h"
#import "MyInviteRequest.h"
#import "GListTableViewCell.h"
#import "GlistDetailViewController.h"
#import "MyInviteModel.h"
#import "EmptyManager.h"
#import "GetAuthStateManager.h"
#import "AlertView.h"
#import "LYZAdView.h"
#import "MyProfileViewController.h"
@interface GlistViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)UITableView *groupTableview;

@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)MyInviteApi *api;

@end

@implementation GlistViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [self firstRefresh];

}

- (MyInviteApi *)api
{
    if (!_api) {
        
        _api = [[MyInviteApi alloc]init];
        
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


- (void)firstRefresh
{
    
    [self.groupTableview.mj_header beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.groupTableview];
    
    [self.groupTableview registerClass:[GListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GListTableViewCell class])];
    
    self.groupTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        myInviteHeader *head = [[myInviteHeader alloc]init];
        
        head.target = @"huizhenControl";
        
        head.method = @"myHzYaoqing";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        myInviteBody *body = [[myInviteBody alloc]init];
        
        MyInviteRequest *request = [[MyInviteRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api myInvite:request.mj_keyValues.mutableCopy];
        
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
    
    MyInviteModel *model = [self.listArray objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                MyInviteModel *model = [self.listArray objectAtIndex:indexPath.row];
                GlistDetailViewController *group = [[GlistDetailViewController alloc]initWithType:GroupConsultTypeJoinOrNot withID:model.id];
                group.title = @"会诊详情";
                [self.navigationController pushViewController:group animated:YES];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
     
    }
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

@end
