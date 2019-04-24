//
//  ForumViewController.m
//  MedicineClient
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ForumViewController.h"
#import "FrumTableViewCell.h"
#import "LunTanModel.h"
#import "LunTanApi.h"
#import "LunTanModel.h"
#import "LuntanRequest.h"
#import "RelatedMedicalRecordsTableViewCell.h"
#import "FriendCircleCell.h"
#import "FrumDetailViewController.h"
#import "EmptyManager.h"
#import "LSProgressHUD.h"

@interface ForumViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *frumTableView;

@property (nonatomic,strong)NSMutableArray *ListArr;

@property (nonatomic,strong)LunTanApi *api;


@end

@implementation ForumViewController

- (LunTanApi *)api
{

    if (!_api) {
        
        _api = [[LunTanApi alloc]init];
        
        _api.delegate  = self;
        
    }
    
    return _api;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"论坛";

    self.view.backgroundColor  =DefaultBackgroundColor;
    
    [self.view addSubview:self.frumTableView];
    
    [self.frumTableView registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
        
    self.frumTableView.backgroundColor = DefaultBackgroundColor;
    
    self.frumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.frumTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        luntanHeader *header = [[luntanHeader alloc]init];
        
        header.target = @"forumDControl";
        
        header.method = @"homeDPage";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;

        luntanBody *bodyer = [[luntanBody alloc]init];
        
        LuntanRequest *requester = [[LuntanRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getLuntan:requester.mj_keyValues.mutableCopy];
        
    }];
    
    
    [self.frumTableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
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


- (UITableView *)frumTableView
{

    if (!_frumTableView) {
        
        _frumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _frumTableView.delegate  =self;
        
        _frumTableView.dataSource = self;
        
    }

    return _frumTableView;
    
}

- (NSMutableArray *)ListArr{

    if (!_ListArr) {
        
        _ListArr = [NSMutableArray array];
    }

    return _ListArr;
    

}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LunTanModel *model = [self.ListArr objectAtIndex:indexPath.section];
    
//    [cell cellDataWithModel:model];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendCircleCell class]) cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
        if (indexPath.row < self.ListArr.count) {
//            [cell cellDataWithModel:self.ListArr[indexPath.section]];
        }
    }];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
        return CGFLOAT_MIN;
    return 5;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.ListArr.count;
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if ([Utils showLoginPageIfNeeded]) {
    
    
    } else {
        
        FrumDetailViewController *detail = [FrumDetailViewController new];
        
        LunTanModel *model = [self.ListArr objectAtIndex:indexPath.section];
        
        detail.ID = model.id;
        
        detail.title  =@"问答详情";
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }

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
