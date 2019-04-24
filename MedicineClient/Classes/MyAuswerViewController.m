//
//  MyAuswerViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyAuswerViewController.h"
#import "MycollectionCell.h"
#import "MyAuswerModel.h"
#import "MyAuswerApi.h"
#import "MyAuswerRequest.h"
#import "MyAuswerTableViewCell.h"
#import "EmptyManager.h"
#import "LSProgressHUD.h"
#import "FrumDetailViewController.h"
@interface MyAuswerViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *frumTableView;

@property (nonatomic,strong)NSMutableArray *ListArr;


@property (nonatomic,strong)MyAuswerApi *api;



@end

@implementation MyAuswerViewController


- (MyAuswerApi *)api
{

    if (!_api) {
        
        _api = [[MyAuswerApi alloc]init];
        
        _api.delegate  =self;
        
        
    }
    
    return _api;
    

}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [self.frumTableView.mj_header endRefreshing];
    
    [LSProgressHUD hide];
    
    
    if (self.ListArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.frumTableView response:command.response operationBlock:^{
            strongify(self)
            [self.frumTableView.mj_header beginRefreshing];
        }];
    }
    

}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{


    [self.frumTableView.mj_header endRefreshing];
    
    [LSProgressHUD hide];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.frumTableView];
    
    self.ListArr = responsObject;
    
    if (self.ListArr.count <= 0) {
        
        [[EmptyManager sharedManager] showEmptyOnView:self.frumTableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表还是空的" operationText:nil operationBlock:nil];
        
        return;
        
    }
    
    [self.frumTableView reloadData];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  =DefaultBackgroundColor;
    self.frumTableView.backgroundColor = DefaultBackgroundColor;

    self.title  = @"我的回答";
    
    [self.view addSubview:self.frumTableView];
    
    [self.frumTableView registerClass:[MycollectionCell class] forCellReuseIdentifier:NSStringFromClass([MycollectionCell class])];
    
 
    [LSProgressHUD showWithMessage:@"正在加载"];

    self.frumTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //请求签名
//        MyAuswerHeader *header = [[MyAuswerHeader alloc]init];
//        
//        header.target = @"ownDControl";
//        
//        header.method = @"myBacks";
//        
//        header.versioncode = Versioncode;
//        
//        header.devicenum = Devicenum;
//        
//        header.fromtype = Fromtype;
//        
//        header.token = [User LocalUser].token;
//        
//        MyAuswerBody *bodyer = [[MyAuswerBody alloc]init];
//        
//        MyAuswerRequest *requester = [[MyAuswerRequest alloc]init];
//        
//        requester.head = header;
//        
//        requester.body = bodyer;
//        
//        NSLog(@"%@",requester);
//        
//        [self.api getMyAuswer:requester.mj_keyValues.mutableCopy];
        
        
    }];
    
    
    [self.frumTableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

- (UITableView *)frumTableView
{
    
    if (!_frumTableView) {
        
        _frumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _frumTableView.delegate  =self;
        
        _frumTableView.dataSource = self;
        
        _frumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _frumTableView;
    
}

- (NSMutableArray *)ListArr{
    
    if (!_ListArr) {
        
        _ListArr = [NSMutableArray array];
    }
    
    return _ListArr;
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.ListArr.count;


}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     MycollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MycollectionCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyAuswerModel *model = [self.ListArr objectAtIndex:indexPath.row];
    
    [cell cellDataWithausModel:model];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MycollectionCell class]) cacheByIndexPath:indexPath configuration: ^(MycollectionCell *cell) {
    
            MyAuswerModel *model = [self.ListArr objectAtIndex:indexPath.row];

            NSLog(@"%@",model.title);
            
            [cell cellDataWithausModel:model];
            
//            [cell cellDataWithauswertModel:model];
    
        }];
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return 0.0000000001f;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyAuswerModel *model = [self.ListArr objectAtIndex:indexPath.row];

    
    FrumDetailViewController *detail = [FrumDetailViewController new];
    
    detail.ID = model.id;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


@end
