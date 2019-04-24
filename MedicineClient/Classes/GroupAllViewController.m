//
//  GroupAllViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/10.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GroupAllViewController.h"
#import "AllCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "FootCollectionReusableView.h"
#import "InvitorDetailApi.h"
#import "InvitorDetailRequest.h"
#import "InvitorDetailModel.h"
#import "EmptyManager.h"
#import "TeamDetailViewController.h"
#import "MyTeamViewController.h"
#import "InviteDoctorViewController.h"
#import "SeMulViewController.h"
#import "GroupConSearchModel.h"
#import "GetGroupInfoApi.h"
#import "GetGroupInfoRequest.h"
#import "ReGetGroupConInfoModel.h"
@interface GroupAllViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UICollectionView *collection;

@property (nonatomic,strong)NSMutableArray *list;

@property (nonatomic,strong)NSMutableArray *mem;

@property (nonatomic,strong)InvitorDetailApi *api;

@property (nonatomic,strong)InvitorDetailModel *model;

@property (nonatomic,strong)UIButton *addButton;

@property (nonatomic,strong)UIButton *delButton;

@property (nonatomic,strong)NSString *huizhenid;

@property (nonatomic,strong)GetGroupInfoApi *Infoapi;

@end

@implementation GroupAllViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [self.collection.mj_header beginRefreshing];
    
}
- (InvitorDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[InvitorDetailApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (NSMutableArray *)list
{
    if (!_list) {
        
        _list = [NSMutableArray array];
    }
    
    return _list;
    
}

- (NSMutableArray *)mem
{
    if (!_mem) {
        
        _mem = [NSMutableArray array];
    }
    
    return _mem;
    
}

- (GetGroupInfoApi *)Infoapi
{
    if (!_Infoapi) {
        
        _Infoapi = [[GetGroupInfoApi alloc]init];
        
        _Infoapi.delegate = self;
        
    }
    
    return _Infoapi;
    
}

- (UICollectionView *)collection
{
    
    if (!_collection) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//设置滚动方向,默认垂直方向.
        flowLayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 45);//头视图的大小
        flowLayout.footerReferenceSize=CGSizeMake(self.view.frame.size.width, 20);//尾视图大小
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        
        _collection.delegate = self;
        
        _collection.dataSource = self;
        
        _collection.backgroundColor = [UIColor whiteColor];
        
        ;
        
    }
    
    return _collection;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collection registerClass:[AllCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AllCollectionViewCell class])];
    [self.collection registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HeaderCollectionReusableView class])];
    
     [self.collection registerClass:[FootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([FootCollectionReusableView class])];
    
    [self.view addSubview:self.collection];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        
        if (self.normalGroup == YES) {
            
            //请求签名
            InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
            
            header.target = @"huizhenControl";
            
            header.method = @"groupDetail";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
            
            bodyer.groupid = self.targrtid;
            
            InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.api getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
            
        }else{
            
            InvitorDetailHeader *header = [[InvitorDetailHeader alloc]init];
            
            header.target = @"huizhenControl";
            
            header.method = @"huizhenPeopleDetail";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            InvitorDetailBody *bodyer = [[InvitorDetailBody alloc]init];
            
            bodyer.mdtgroupid = self.targrtid;
            
            InvitorDetailRequest *requester = [[InvitorDetailRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.api getInvitorInfoDetail:requester.mj_keyValues.mutableCopy];
            
        }
       
        
    }];
    
    [self.collection.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}


- (void)iscreaterUI{
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.addButton.backgroundColor = [UIColor whiteColor];
    
    [self.addButton setTitle:@"新增邀请人" forState:UIControlStateNormal];
    
    [self.addButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    self.addButton.titleLabel.font  =FontNameAndSize(18);
    
    [self.view addSubview:self.addButton];
    
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.delButton.backgroundColor = AppStyleColor;
    
    [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [self.delButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.delButton.titleLabel.font  =FontNameAndSize(18);

    [self.view addSubview:self.delButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(50);
        
    }];
    
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.addButton.mas_right);
        make.width.mas_equalTo(self.addButton.mas_width);
        make.height.mas_equalTo(self.addButton.mas_height);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.addButton addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    
    [self.delButton addTarget:self action:@selector(deleGroup) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)addGroup{
    
    InviteDoctorViewController *invite = [InviteDoctorViewController new];
    
    invite.groupID = self.huizhenid;
    
    invite.title = @"选择医生";
    
    [self.navigationController pushViewController:invite animated:YES];
    
}

- (void)deleGroup{
    
    getGroupHeader *head = [[getGroupHeader alloc]init];
    //
    head.target = @"huizhenControl";
    
    head.method = @"searchGroupCut";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    getGroupBody *body = [[getGroupBody alloc]init];
    
    body.id = self.huizhenid;  //会诊id
    
    GetGroupInfoRequest *request = [[GetGroupInfoRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.Infoapi getGroupInfo:request.mj_keyValues.mutableCopy];
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.collection.mj_header endRefreshing];
    
    if (self.list.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.collection response:command.response operationBlock:^{
            strongify(self)
            [self.collection.mj_header beginRefreshing];
        }];
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.collection.mj_header endRefreshing];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.collection];
    
    InvitorDetailModel *model = [InvitorDetailModel mj_objectWithKeyValues:responsObject];
    
    NSLog(@"%@",model.mj_keyValues);
    
    NSArray *tempArray = [teamModel mj_objectArrayWithKeyValuesArray:responsObject[@"teams"]];
    
    NSLog(@"%@",self.mem);

    if (tempArray.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.collection withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"列表是空的" operationText:nil operationBlock:nil];
    } else {
        
        [self.list removeAllObjects];
        
        self.list = [teamModel mj_objectArrayWithKeyValuesArray:tempArray];
        
        [self.collection reloadData];
        
        self.huizhenid  = model.id;
        
        NSLog(@"======++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@",self.huizhenid);
        
        if ([model.iscreater isEqualToString:@"Y"]) {
            
            [self iscreaterUI];
            
        }
        
    }
    
    if (api == _Infoapi) {
        
            SeMulViewController *mul = [[SeMulViewController alloc]init];
            
            mul.groupID = self.huizhenid;
        
            mul.list = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responsObject[@"doctors"]];
        
            mul.title = @"选择要删除的医生";
        
        mul.endArr = ^{
           
            [self.collection.mj_header beginRefreshing];
            
        };
        
            [self.navigationController pushViewController:mul animated:YES];
        
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    teamModel *model = [self.list objectAtIndex:section];
    
    return model.peoples.count;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HeaderCollectionReusableView class]) forIndexPath:indexPath];
        /**
         *
         * 注意:虽然这里没有看到明显的initWithFrame方法,但是在获取重用视图的时候,系统会自动调用initWithFrame方法的.所以在initWithFrame里面进行初始化操作,是没有问题的!
         */
        
//        [headerView getSHCollectionReusableViewHearderTitle:hearderTitleArray[indexPath.section]];
        headerView.backgroundColor = [UIColor whiteColor];
        
        teamModel *model = [self.list objectAtIndex:indexPath.section];
        
        headerView.headLabel.text = model.tname;
        
        headerView.eve = ^{
          
            MyTeamViewController *team = [MyTeamViewController new];
            
            team.isPersonCenter = YES;
            
            [self.navigationController pushViewController:team animated:YES];
            
        };
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        FootCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([FootCollectionReusableView class]) forIndexPath:indexPath];
        /**
         *  如果头尾视图没什么很多内容,直接创建对应控件进行添加即可,无需自定义.
         */
        footerview.backgroundColor= DefaultBackgroundColor;
        reusableview = footerview;
    }
    
    return reusableview;
}


//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 75);
    
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    AllCollectionViewCell *cell = (AllCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AllCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
  
    teamModel *model = [self.list objectAtIndex:indexPath.section];
    
    self.mem = [membersModel mj_objectArrayWithKeyValuesArray:model.peoples];
    
    membersModel *model0 = [self.mem objectAtIndex:indexPath.row];
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model0.dfacepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    cell.nameLabel.text = model0.dusername;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    teamModel *model = [self.list objectAtIndex:indexPath.section];
    
    self.mem = [membersModel mj_objectArrayWithKeyValuesArray:model.peoples];
    
    membersModel *model0 = [self.mem objectAtIndex:indexPath.row];
    
    TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
    
    detail.ID = model0.did;
    
    [self.navigationController pushViewController:detail animated:YES];
    
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
