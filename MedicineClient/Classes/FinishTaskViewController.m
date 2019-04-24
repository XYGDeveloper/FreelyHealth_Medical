//
//  FinishTaskViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FinishTaskViewController.h"
#import "AgentModel.h"
#import "AgentIndexReruest.h"
#import "AgentApi.h"
#import "AgentTableViewCell.h"
#import "AgentDetailViewController.h"
#import "LSProgressHUD.h"
@interface FinishTaskViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)AgentApi *api;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation FinishTaskViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.tableview.backgroundColor = DefaultBackgroundColor;
    
    
    [self.tableview.mj_header beginRefreshing];
    
    
    
}


- (AgentApi *)api
{
    
    if (!_api) {
        
        _api = [[AgentApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
    [self.tableview.mj_header endRefreshing];
    
    [self.hud hide:YES];

    
    [Utils postMessage:command.response.msg onView:self.view];
    
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.tableview.mj_header endRefreshing];
    
    [self.hud hide:YES];

    
    self.listArr = responsObject;
    
    [self.tableview reloadData];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"AgentTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AgentTableViewCell class])];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.tableview.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        AgentHeader *header = [[AgentHeader alloc]init];
        
        header.target = @"operatorControl";
        
        header.method = @"operatorList";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        AgentBody *bodyer = [[AgentBody alloc]init];
        
        bodyer.isfinish = @"Y";
        
        AgentIndexReruest *requester = [[AgentIndexReruest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getagent:requester.mj_keyValues.mutableCopy];
        
    }];
    
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
    
    
    
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
    
    AgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AgentTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AgentModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    
    cell.block = ^{
        
        
        AgentDetailViewController *detail = [[AgentDetailViewController alloc]init];
        detail.orderid = model.orderid;
        
        detail.title = @"服务记录";
        
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
    return cell;
    
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.000000001;
    return 8;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AgentModel *model = [self.listArr objectAtIndex:indexPath.row];

    AgentDetailViewController *detail = [[AgentDetailViewController alloc]init];
    
    detail.orderid = model.orderid;
    
    detail.title = @"服务记录";
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


@end
