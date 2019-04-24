//
//  FrumDetailViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FrumDetailViewController.h"
#import "FrumDetailApi.h"
#import "FrumDetailRequest.h"
#import "FrumDetailModel.h"
#import "FrumDetailTableViewCell.h"
#import "ListTableViewCell.h"
#import "AuswerViewController.h"
#import "CollectionApi.h"
#import "CollectionRequest.h"
#import "CanCelCollectionApi.h"
#import "CancelCollectionRequest.h"
#import "FriendCircleCell1.h"
#import "LSProgressHUD.h"
@interface FrumDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *frumTableView;

@property (nonatomic,strong)NSMutableArray *ListArr;

@property (nonatomic,strong)FrumDetailApi *api;

@property (nonatomic,strong)FrumDetailModel *model;

@property (nonatomic,strong) CollectionApi *collectionApi;

@property (nonatomic,strong) CanCelCollectionApi *cancelcollectionApi;

@property (nonatomic,strong)UIButton *thumpButton;

@property (nonatomic,strong)UIButton *AuswerButton;


@end

@implementation FrumDetailViewController


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self.frumTableView.mj_header beginRefreshing];
    
}


- (FrumDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[FrumDetailApi alloc]init];
        
        _api.delegate  = self;
        
    }
    
    return _api;
    
}

- (CollectionApi *)collectionApi
{
    
    if (!_collectionApi) {
        
        _collectionApi = [[CollectionApi alloc]init];
        
        _collectionApi.delegate  = self;
        
    }
    
    return _collectionApi;
    
}

- (CanCelCollectionApi *)cancelcollectionApi
{
    
    if (!_cancelcollectionApi) {
        
        _cancelcollectionApi = [[CanCelCollectionApi alloc]init];
        
        _cancelcollectionApi.delegate  = self;
        
    }
    
    return _cancelcollectionApi;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"论坛详情";
    
//    self.view.backgroundColor  = DefaultBackgroundColor;
    
    [self.view addSubview:self.frumTableView];
    self.frumTableView.backgroundColor = DefaultBackgroundColor;
    
    self.frumTableView.separatorColor = DividerGrayColor;
    [LSProgressHUD showWithMessage:@"正在加载中"];

    self.frumTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        luntanDetailHeader *header = [[luntanDetailHeader alloc]init];
        
        header.target = @"forumDControl";
        
        header.method = @"detailDPage";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;

        luntanDetailBody *bodyer = [[luntanDetailBody alloc]init];
        
        bodyer.id = self.ID;
        
        FrumDetailRequest *requester = [[FrumDetailRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.api getLuntan:requester.mj_keyValues.mutableCopy];
        
    }];
    
    
    [self.frumTableView.mj_header beginRefreshing];
    
    self.thumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.thumpButton.backgroundColor = [UIColor whiteColor];

    self.thumpButton.titleLabel.font = Font(16);
    
    [self.view addSubview:self.thumpButton];
    
    self.AuswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.AuswerButton.backgroundColor = AppStyleColor;
    
    [self.AuswerButton setTitle:@"回答" forState:UIControlStateNormal];
    
    [self.AuswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.AuswerButton];
    
    [self.thumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(49);
        
        make.height.mas_equalTo(49);
        
    }];
    
    
    
    [self.AuswerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.thumpButton.mas_right);
        
        make.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(49);
        
    }];
    
    [self.AuswerButton addTarget:self action:@selector(auswerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thumpButton addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];

    [self.thumpButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

    if (self.thumpButton.selected == YES) {
        
        [self.thumpButton setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];
       
    }else{
        
          [self.thumpButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
 
        
    }

    [self.frumTableView registerClass:[FriendCircleCell1 class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell1 class])];
    [self.frumTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ListTableViewCell class])];
    
    
    // Do any additional setup after loading the view.
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
    [self.frumTableView.mj_header endRefreshing];
    
    [LSProgressHUD hide];

    if (api == _collectionApi) {
        
        [LSProgressHUD hide];

        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    

    [self.frumTableView.mj_header endRefreshing];
    
    [LSProgressHUD hide];

    
    if (api == _api) {
        
        self.model = responsObject;
        
        if ([self.model.iscollect isEqualToString:@"1"]) {
            
            self.thumpButton.selected = YES;
            
            [self.thumpButton setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];
           
            
        }else{
           
    
            self.thumpButton.selected = NO;
            
             [self.thumpButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];

        }
        
        self.ListArr = [AuswerModel mj_objectArrayWithKeyValuesArray:self.model.answers];
        
    }
    
    
    [self.frumTableView reloadData];
    
    
    if (api == _collectionApi) {
        
        [BGLoadingHUD hideHUDForView:self.view];

        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
    if (api == _cancelcollectionApi) {
        
        [BGLoadingHUD hideHUDForView:self.view];
        
        [Utils postMessage:command.response.msg onView:self.view];
        
    }
    
    
}


- (UITableView *)frumTableView
{
    
    
    if (!_frumTableView) {
        
        _frumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _frumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    if (section == 0) {
        
        return 1;
        
    }else{
    
      return self.ListArr.count;
    
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        FriendCircleCell1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell1 class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell cellDataWithModel:self.model];
        
        return cell;
        
    }else{
    
        
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            AuswerModel *model = [self.ListArr objectAtIndex:indexPath.row];
        
            [cell cellDataWithModel:model];
    
        return cell;

    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendCircleCell1 class]) cacheByIndexPath:indexPath configuration: ^(FriendCircleCell1 *cell) {
            
                [cell cellDataWithModel:self.model];
           
        }];
        
    }else{
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ListTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(ListTableViewCell *cell) {
            
            if (indexPath.row < self.ListArr.count) {
                
                AuswerModel *model = [self.ListArr objectAtIndex:indexPath.row];
                
                [cell cellDataWithModel:model];
                
                
            }
        }];
    
    }
    
 
    
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
    
    return 2;
    
}


- (void)auswerAction{

    AuswerViewController *auswer = [AuswerViewController new];
    
    auswer.title  =@"回答问题";
    
    auswer.model = self.model;
    
    [self.navigationController pushViewController:auswer animated:YES];
    
    
}


- (void)collectionAction{

    
    self.thumpButton.selected = !self.thumpButton.selected;
    
    if (self.thumpButton.selected == NO) {
        
        [self.thumpButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];

        CancelCollectionHeader *header = [[CancelCollectionHeader alloc]init];
        
        header.target = @"forumDControl";
        
        header.method = @"cancelCollect";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        CancelCollectionBody *bodyer = [[CancelCollectionBody alloc]init];
        
        bodyer.topicids = self.model.id;
        
        CancelCollectionRequest *requester = [[CancelCollectionRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.cancelcollectionApi cancelcollection:requester.mj_keyValues.mutableCopy];
        
        
    }else{
        
        [LSProgressHUD showWithMessage:nil];
        
        [self.thumpButton setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];

        //请求签名
        CollectionHeader *header = [[CollectionHeader alloc]init];
        
        header.target = @"forumDControl";
        
        header.method = @"collect";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        CollectionBody *bodyer = [[CollectionBody alloc]init];
        
        bodyer.id = self.model.id;
        
        CollectionRequest *requester = [[CollectionRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.collectionApi collection:requester.mj_keyValues.mutableCopy];
        
    }
    
}

@end
