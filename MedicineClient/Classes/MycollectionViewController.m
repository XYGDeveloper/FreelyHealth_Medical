//
//  MycollectionViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MycollectionViewController.h"
#import "MycollectionCell.h"
#import "MyCollectionModel.h"
#import "MyCollectionRequest.h"
#import "MyCollectionApi.h"
#import "FrumDetailViewController.h"
#import "EmptyManager.h"
#import "CanCelCollectionApi.h"
#import "CancelCollectionRequest.h"
#import "LSProgressHUD.h"
@interface MycollectionViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *frumTableView;

@property (nonatomic,strong)NSMutableArray *ListArr;

@property(nonatomic, strong) NSMutableArray *deleteArr;//删除数据的数组
@property(nonatomic, strong) NSMutableArray *markArr;//标记数据的数组

@property (nonatomic,strong)MyCollectionApi *api;

@property (nonatomic,strong)CanCelCollectionApi *cancelapi;


@end

@implementation MycollectionViewController

- (MyCollectionApi *)api
{

    if (!_api) {
        
        _api = [[MyCollectionApi alloc]init];
        
        _api.delegate  = self;
        
    }
    
    return _api;
    
}

- (CanCelCollectionApi *)cancelapi
{
    
    if (!_cancelapi) {
        
        _cancelapi = [[CanCelCollectionApi alloc]init];
        
        _cancelapi.delegate  = self;
        
    }
    
    return _cancelapi;
    
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

    if (api == _cancelapi) {
        
        [LSProgressHUD showWithMessage:@"正在加载中"];

        MyCollectionHeader *header = [[MyCollectionHeader alloc]init];
        
        header.target = @"ownDControl";
        
        header.method = @"myCollects";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        MyCollectionBody *bodyer = [[MyCollectionBody alloc]init];
        
        MyCollectionRequest *requester = [[MyCollectionRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getCollection:requester.mj_keyValues.mutableCopy];
        
        
    }

    
    if (self.ListArr.count <= 0) {
       
         [[EmptyManager sharedManager] showEmptyOnView:self.frumTableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表还是空的" operationText:nil operationBlock:nil];
        
        return;
        
    }
    

    [self.frumTableView reloadData];
    
    
}


//- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
//    
//    NSLog(@"订单列表%@",responsObject);
//    [self.tableView.mj_footer resetNoMoreData];
//    [self.tableView.mj_header endRefreshing];
//    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
//    
//    NSArray *array = (NSArray *)responsObject;
//    if (array.count <= 0) {
//        [[EmptyManager sharedManager] showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表还是空的" operationText:nil operationBlock:nil];
//    } else {
//        
//        [self.orderArray removeAllObjects];
//        [self.orderArray addObjectsFromArray:responsObject];
//        
//        [self.tableView reloadData];
//    }
//    
//}
//
//- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [Utils postMessage:command.response.msg onView:self.view];
//    [self.tableView.mj_header endRefreshing];
//    
//    if (self.orderArray.count <= 0) {
//        weakify(self)
//        [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:^{
//            strongify(self)
//            [self.tableView.mj_header beginRefreshing];
//        }];
//    }
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  =DefaultBackgroundColor;
    
    self.title  = @"我的收藏";
    
    self.deleteArr = [NSMutableArray array];
    
    self.markArr = [NSMutableArray array];
    
    self.frumTableView.editing = NO;

    self.frumTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.frumTableView];
    
    [self setRightNavigationItemWithTitle:@"编辑" action:@selector(itmeToll:)];
    
    [self.frumTableView registerClass:[MycollectionCell class] forCellReuseIdentifier:NSStringFromClass([MycollectionCell class])];
    
    [LSProgressHUD showWithMessage:@"正在加载中"];

    self.frumTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        MyCollectionHeader *header = [[MyCollectionHeader alloc]init];
        
        header.target = @"ownDControl";
        
        header.method = @"myCollects";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        MyCollectionBody *bodyer = [[MyCollectionBody alloc]init];
        
        MyCollectionRequest *requester = [[MyCollectionRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getCollection:requester.mj_keyValues.mutableCopy];
        
    
    }];
    
    
    [self.frumTableView.mj_header beginRefreshing];
    
}


-(void)itmeToll:(UIButton *) b
{
   
    NSLog(@"dddddddd");
    
        if ([b.titleLabel.text isEqualToString:@"编辑"]){
            
            [self.frumTableView setEditing:YES animated:YES];
            [self showEitingView:YES];
            
            [b setTitle:@"删除" forState:UIControlStateNormal];
            
        }else {
            
            [b setTitle:@"编辑" forState:UIControlStateNormal];
            
            if (self.deleteArr.count <= 0) {
                
                
            }else{
            
                [self deleteClick:b];

            }
            
            
            [self.frumTableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
    
    
}


-(void) showEitingView:(BOOL) s
{
   
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


//删除按钮点击事件
- (void)deleteClick:(UIButton *) button {
    
    if (self.frumTableView.editing) {
        //删除
        [self.ListArr removeObjectsInArray:self.deleteArr];
        
        NSLog(@"%@",self.deleteArr);
        
        NSLog(@"sssscccccc");
        
        CancelCollectionHeader *header = [[CancelCollectionHeader alloc]init];
        
        header.target = @"forumDControl";
        
        header.method = @"cancelCollect";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        CancelCollectionBody *bodyer = [[CancelCollectionBody alloc]init];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSString *ID in self.deleteArr) {
            
            topicModel *model = [[topicModel alloc]init];
            
            model.topicid = ID;
            
            [arr addObject:model];
            
        }
        
        bodyer.topicids = arr;
        
        CancelCollectionRequest *requester = [[CancelCollectionRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.cancelapi cancelcollection:requester.mj_keyValues.mutableCopy];
        
    }
    else return;
}



- (UITableView *)frumTableView
{
    
    if (!_frumTableView) {
        
        _frumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _frumTableView.delegate  =self;
        _frumTableView.backgroundColor = DefaultBackgroundColor;
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
    return self.ListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MycollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MycollectionCell class])];
    
    MyCollectionModel *model = [self.ListArr objectAtIndex:indexPath.row];
    
    [cell cellDataWithcollModel:model];

    return cell;

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return [tableView fd_heightForCellWithIdentifier:@"MycollectionCell" cacheByIndexPath:indexPath configuration: ^(MycollectionCell *cell) {
    
            MyCollectionModel *model = [self.ListArr objectAtIndex:indexPath.row];
            
            [cell cellDataWithcollModel:model];
            
        }];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        
        MyCollectionModel *model = [self.ListArr objectAtIndex:indexPath.row];
        
        [self.deleteArr addObject:model.id];
        
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCollectionModel *model = [self.ListArr objectAtIndex:indexPath.row];

    FrumDetailViewController *detail = [FrumDetailViewController new];
    
    detail.title = @"论坛详情";
    
    detail.ID = model.id;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    MyCollectionModel *model = [self.ListArr objectAtIndex:indexPath.row];
    
    [self.deleteArr removeObject:model.id];
    
    
}





@end
