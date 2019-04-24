//
//  TeamIndexViewController.m
//  MedicineClient
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamIndexViewController.h"
#import "MemberTableViewCell.h"
#import "QueryConditionApi.h"
#import "QueryConditionRequest.h"
#import "QueryConditionModel.h"
#import "ConditionTeamModel.h"
#import "ConditionApi.h"
#import "ConditionFindTeamRequest.h"
#import "TeamDetailViewController.h"
#import "MyTeamViewController.h"
#import "EmptyManager.h"
#import "UpdateControlManager.h"
#import "UIView+AnimationProperty.h"
#import "UdeskReachability.h"
#import "Udesk_WHC_HttpManager.h"
@interface TeamIndexViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView * teamTableView;

@property (nonatomic,strong)NSMutableArray * listArray;

@property (nonatomic,assign)NSInteger * section;
//获取团队信息
@property (nonatomic,strong)QueryConditionApi * allTeamConditionApi;
//全部城市
@property (nonatomic,strong)NSMutableArray *allCityies;

@property (nonatomic,strong)NSMutableArray *cities;

@property (nonatomic,strong)QueryConditionModel *model;

@property (nonatomic,strong)allCityModel *citymodel;

@property (nonatomic,strong)NSMutableArray *city0;
@property (nonatomic,strong)NSMutableArray *city1;
@property (nonatomic,strong)NSMutableArray *city2;
@property (nonatomic,strong)NSMutableArray *city3;
@property (nonatomic,strong)NSMutableArray *city4;
@property (nonatomic,strong)NSMutableArray *city5;
@property (nonatomic,strong)NSMutableArray *city6;
@property (nonatomic,strong)NSMutableArray *city7;
@property (nonatomic,strong)NSMutableArray *city8;

@property (nonatomic,strong)NSMutableArray *departments;

//获取团队信息

@property (nonatomic,strong)ConditionApi * getTeamApi;

@property (nonatomic,strong)NSMutableArray * teamListArray;

@property (nonatomic,strong)NSMutableArray * memberListArray;

@property (nonatomic,strong)UIButton * tableViewHeaderView;

@property (nonatomic,strong)UIButton * tableViewFooterView;

@property (nonatomic,strong)UdeskReachability * reach;

@end

@implementation TeamIndexViewController

- (void)refreshTeamPage
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (QueryConditionApi *)allTeamConditionApi
{
    
    if (!_allTeamConditionApi) {
        
        _allTeamConditionApi = [[QueryConditionApi alloc]init];
        
        _allTeamConditionApi.delegate  = self;
        
    }
    
    return _allTeamConditionApi;
    
}

//getTeamliat

- (ConditionApi *)getTeamApi
{
    if (!_getTeamApi) {
        
        _getTeamApi = [[ConditionApi alloc]init];
        
        _getTeamApi.delegate  =self;
    }
    
    return _getTeamApi;
    
}

- (NSMutableArray *)memberListArray
{
    if (!_memberListArray) {
        _memberListArray = [NSMutableArray array];
    }
    return _memberListArray;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.teamTableView.mj_header endRefreshing];
    });
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (api == _getTeamApi) {

    }
    
    if (api == _allTeamConditionApi) {
        [self.teamTableView.mj_header endRefreshing];
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:nil];
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.teamTableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (api == _allTeamConditionApi) {
        
        self.model = responsObject;
        self.allCityies = [NSMutableArray array];
        [self.allCityies removeAllObjects];
        self.allCityies = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
        
        self.cities = [NSMutableArray array];
        [self.cities removeAllObjects];
        self.city0 = [NSMutableArray array];
        [self.city0 removeAllObjects];
        self.city1 = [NSMutableArray array];
        [self.city1 removeAllObjects];
        self.city2 = [NSMutableArray array];
        [self.city2 removeAllObjects];
        self.city3 = [NSMutableArray array];
        [self.city3 removeAllObjects];
        self.city4 = [NSMutableArray array];
        [self.city4 removeAllObjects];
        self.city5 = [NSMutableArray array];
        [self.city5 removeAllObjects];
        self.city6 = [NSMutableArray array];
        [self.city6 removeAllObjects];
        self.city7 = [NSMutableArray array];
        [self.city7 removeAllObjects];
        self.city8 = [NSMutableArray array];
        [self.city8 removeAllObjects];
        for (allCityModel *model in self.allCityies) {
            [self.cities safeAddObject:model.name];
            
//            NSLog(@"%@",self.cities);
            
            if ([model.id isEqualToString:@"0"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    [self.city0 addObject:model.name];
                }
            }
            
            if ([model.id isEqualToString:@"1"]) {
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                for (AllmemberModel *model in memeber) {
                    [self.city1 addObject:model.name];
                }
            }
            if ([model.id isEqualToString:@"2"]) {
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                for (AllmemberModel *model in memeber) {
                    [self.city2 addObject:model.name];
                }
                
            }
            
            if ([model.id isEqualToString:@"3"]) {
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                for (AllmemberModel *model in memeber) {
                    [self.city3 addObject:model.name];
                }
                
            }
            
            if ([model.id isEqualToString:@"4"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    
                    [self.city4 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"5"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    
                    [self.city5 addObject:model.name];
                    
                }
                
                
            }
            
            if ([model.id isEqualToString:@"6"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    
                    [self.city6 addObject:model.name];
                    
                }
                
                
            }
            
            if ([model.id isEqualToString:@"7"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    
                    [self.city7 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"8"]) {
                
                NSArray *memeber = [AllmemberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (AllmemberModel *model in memeber) {
                    
                    [self.city8 addObject:model.name];
                    
                }
                
            }
            
        }
        
        
        NSArray *departList = [AlldepartModel mj_objectArrayWithKeyValuesArray:self.model.departments];
        
//        NSLog(@"%@",departList);
        self.departments = [NSMutableArray array];
        [self.departments removeAllObjects];
        for (AlldepartModel *depart in departList) {
            
            [self.departments addObject:depart.name];
            
//            NSLog(@"%@",self.departments);
            
        }
        self.choose = @[@"筛选", @"知名度", @"热度", @"医院等级"];
        _menu = [[ZspMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:50];
        _menu.delegate = self;
        _menu.dataSource = self;
        
        [self.view addSubview:_menu];
        
        [_menu selectDeafultIndexPath];
    }
    
    if (api == _getTeamApi) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [[EmptyManager sharedManager] removeEmptyFromView:self.teamTableView];
        self.teamListArray = [NSMutableArray array];
        [self.teamListArray removeAllObjects];
        self.teamListArray = responsObject;
        if (self.teamListArray.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.teamTableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"没有检索到相关团队" operationText:nil operationBlock:^{
            }];
        }
        [self.teamTableView reloadData];
    }
    
}

- (UITableView *)teamTableView
{
    if (!_teamTableView) {
        _teamTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _teamTableView.delegate  =self;
        _teamTableView.dataSource  =self;
    }
    return _teamTableView;
}

- (void)layOutSubview{
    [self.teamTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)setMenuUI{
    
    
    
    
}

- (void)setTableview{
    
    [self.view addSubview:self.teamTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.teamTableView registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MemberTableViewCell class])];
    
    self.teamTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.teamTableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    label.text = @"直医专家团队";
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    
    [self setNavigationtitleView:label];
    
    //    [self setMenuUI];
    
    [self setTableview];
    
    [self layOutSubview];
    
    self.reach = [UdeskReachability reachabilityWithHostName:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kUdeskReachabilityChangedNotification
                                               object:nil];
    [self.reach startNotifier];
}

- (void)reachabilityChanged:(NSNotificationCenter *)note
{
    if (self.reach.currentReachabilityStatus == UDNotReachable) {
        [[EmptyManager sharedManager] showEmptyOnView:self.view withImage:[UIImage imageNamed:@"global_netError"] explain:@"抱歉：~~~~网络迷路了" operationText:nil operationBlock:nil];
    }else{
        
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        conditionHeader *head = [[conditionHeader alloc]init];
        head.target = @"noTokenDControl";
        head.method = @"mainFindCondition";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
//        head.token = [User LocalUser].token;
        conditionBody *body = [[conditionBody alloc]init];
        QueryConditionRequest *request = [[QueryConditionRequest alloc]init];
        request.head = head;
        request.body = body;
        [self.allTeamConditionApi teamQuaryList:request.mj_keyValues.mutableCopy];
    }
}


#pragma mark- tableview代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat margin = 40;
    //headview
    UIButton *headerView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    //headerContentView
    
    UIButton *headerContentView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:headerContentView];
    
    UIImageView *topImage = [[UIImageView alloc]init];
    
    topImage.userInteractionEnabled  = YES;
    
    topImage.image = [UIImage imageNamed:@"team_topview"];
    
    [headerContentView addSubview:topImage];
    
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(10);
        
    }];
    
    UIImageView *middleView = [[UIImageView alloc]init];
    
    middleView.userInteractionEnabled = YES;
    
    middleView.image = [UIImage imageNamed:@"cell_img"];
    
    [headerContentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(topImage.mas_bottom);
        
        make.left.right.bottom.mas_equalTo(0);
        
    }];
    
    //团队头像
    
    UIImageView *headImage = [[UIImageView alloc]init];
    
    headImage.userInteractionEnabled  = YES;
    
    headImage.layer.cornerRadius = 30;
    
    headImage.layer.masksToBounds = YES;
    
    [headerContentView addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        
        make.top.mas_equalTo(20);
        
        make.width.height.mas_equalTo(60);
        
    }];
    
    //团队名称
    UILabel *headerName = [[UILabel alloc]init];
    
    headerName.textColor = DefaultBlackLightTextClor;
    
    headerName.font = FontNameAndSize(18);
    
    headerName.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:headerName];
    
    [headerName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headImage.mas_top).mas_equalTo(0);
        
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-40);
        
        make.height.mas_equalTo(20);
    }];
    
    //团队医院名称
    
    UILabel *hotelName = [[UILabel alloc]init];
    
    hotelName.userInteractionEnabled  = YES;
    
    hotelName.textColor = DefaultGrayTextClor;
    
    hotelName.font = FontNameAndSize(14);
    
    hotelName.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:hotelName];
    
    [hotelName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerName.mas_bottom).mas_equalTo(4);

        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(20);
        
    }];
    
    //团队领头人姓名
    UILabel *headerNike = [[UILabel alloc]init];
    
    headerNike.userInteractionEnabled  = YES;
    
    headerNike.textColor = DefaultGrayTextClor;
    
    headerNike.font = FontNameAndSize(14);
    
    headerNike.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:headerNike];
    
    [headerNike mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(hotelName.mas_bottom).mas_equalTo(4);
        
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-40);
        
        make.height.mas_equalTo(20);
    }];
  
    
    UIView *sepview = [[UIView alloc]init];
    
    sepview.userInteractionEnabled  = YES;
    
    sepview.backgroundColor = DividerGrayColor;
    
    [headerContentView addSubview:sepview];
    
    [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerNike.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);

    }];
 
    ConditionTeamModel *model = [self.teamListArray objectAtIndex:section];
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.lfacepath]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           headImage.image = image;
                           headImage.alpha = 0;
                           headImage.scale = 1.1f;
                           [UIView animateWithDuration:0.5f animations:^{
                               headImage.alpha = 1.f;
                               headImage.scale = 1.f;
                           }];
                       }];
    headerName.text = model.name;
    
    headerNike.text = model.lhname;
    
    hotelName.text = [NSString stringWithFormat:@"学科领头人: %@  %@",model.lname,model.ljob];
    
    UIButton *buttonLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [headerView addSubview:buttonLayer];
    
    buttonLayer.backgroundColor = [UIColor clearColor];
    
    [buttonLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
    }];
    
    [buttonLayer addTarget:self action:@selector(jumpTeam:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonLayer.tag = section;
    
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIButton *footerView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    footerView.frame =CGRectMake(0, 0, kScreenWidth, 70);
    footerView.backgroundColor = [UIColor whiteColor];
    //headerContentView
    UIButton *footContentView = [UIButton buttonWithType:UIButtonTypeSystem];
    footContentView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [footContentView setTitle:@"团队成员" forState:UIControlStateNormal];
    footContentView.titleLabel.font = FontNameAndSize(16);
    [footContentView setTitleColor:DefaultBlueTextClor forState:UIControlStateNormal];
    footContentView.backgroundColor = [UIColor whiteColor];
    footContentView.layer.cornerRadius = 8;
    [footContentView setBackgroundImage:[UIImage imageNamed:@"bottom_bg"] forState:UIControlStateNormal];
    [footerView addSubview:footContentView];
    
    UIButton *buttonLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [footerView addSubview:buttonLayer];
    
    buttonLayer.backgroundColor = [UIColor clearColor];
    
    [buttonLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
        
    }];
    
    [buttonLayer addTarget:self action:@selector(jumpTeam:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonLayer.tag = section;
    
    return footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 70;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.teamListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberTableViewCell class])];
    
    ConditionTeamModel *model = [self.teamListArray objectAtIndex:indexPath.section];
    
    NSArray *member = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    if (member.count >2) {
        
        NSArray *subArray = [member subarrayWithRange:NSMakeRange(0, 3)];
        
        MemberModel *memberModel = [subArray objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:memberModel];
        
    }else{
        
        MemberModel *memberModel = [member objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:memberModel];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ConditionTeamModel *model = [self.teamListArray objectAtIndex:indexPath.section];
    
    NSArray *member = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    MemberModel *memberModel = [member objectAtIndex:indexPath.row];
    if ([Utils showLoginPageIfNeeded]) {} else {
        
        TeamDetailViewController *detail =[[TeamDetailViewController alloc]init];
        
        detail.ID = memberModel.id;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}



#pragma mark- 下拉菜单代理

- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    return 3;
}

- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.cities.count;
    }else if(column == 1) {
        return self.departments.count;
    }else {
        return self.choose.count;
    }
}

- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.cities[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.departments[indexPath.row];
    }else {
        return self.choose[indexPath.row];
    }
}

- (NSString *)menu:(ZspMenu *)menu imageNameForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu imageForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu detailTextForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column < 2) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu detailTextForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    return @"";
}

- (NSInteger)menu:(ZspMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        
        if (row == 0) {
            return self.city0.count;
            
        }else if (row == 1) {
            return self.city1.count;
            
        }else if (row == 2) {
            return self.city2.count;
            
        }else if (row == 3) {
            return self.city3.count;
            
        }else if (row == 4) {
            return self.city4.count;
            
        }else if (row == 5) {
            return self.city5.count;
            
        }else if (row == 6) {
            return self.city6.count;
            
        }else if (row == 7) {
            return self.city7.count;
            
        }else if (row == 8) {
            
            return self.city8.count;
        }
    }
    return 0;
}

- (NSString *)menu:(ZspMenu *)menu titleForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        if (row == 0) {
            return self.city0[indexPath.item];
            
        }else if (row == 1) {
            return self.city1[indexPath.item];
        }else if (row == 2) {
            return self.city2[indexPath.item];
        }else if (row == 3) {
            return self.city3[indexPath.item];
        }else if (row == 4) {
            return self.city4[indexPath.item];
        }else if (row == 5) {
            return self.city5[indexPath.item];
        }else if (row == 6) {
            return self.city6[indexPath.item];
        }else if (row == 7) {
            return self.city7[indexPath.item];
        }else if (row == 8) {
            return self.city8[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(ZspMenu *)menu didSelectRowAtIndexPath:(ZspIndexPath *)indexPath {
    
//    self.teamTableView.mj_header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{

    if (indexPath.item >= 0 && indexPath.column == 0) {
        
//        NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在加载中...";
            //操作不默认，按照条件来查询
            FindHeader *head = [[FindHeader alloc]init];
            
            head.target = @"noTokenDControl";
            
            head.method = @"mainTeams";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
            head.token = [User LocalUser].token;
            
            FindBody *body = [[FindBody alloc]init];
            //
            
            NSArray *cityList = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
            
            for (allCityModel *city in cityList) {
                
                if ([city.id isEqualToString:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
                    
                    NSArray *memeber = [MemberModel mj_objectArrayWithKeyValuesArray:city.members];
                    
                    //                    NSLog(@"kkkk%@",memeber);
                    
                    for (AllmemberModel *model in memeber) {
                        
                        //                        NSLog(@"hos.id:%@   %@",model.name,model.id);
                        
                    }
                    
                    MemberModel *model = [memeber objectAtIndex:indexPath.item];
                    
                    body.hospitalid = model.id;
                    
                    //                    NSLog(@"asd%@",model.id);
                    
                }
                
            }
            
            //        body.hospitalid = [NSString stringWithFormat:@"%ld",indexPath.column];
            
            //        body.departmentid = [NSString stringWithFormat:@"%ld",indexPath.row];
            
            ConditionFindTeamRequest *request = [[ConditionFindTeamRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            [self.getTeamApi AllteamQuaryList:request.mj_keyValues.mutableCopy];
   
    }else if(indexPath.column == 1) {
        
        //操作默认，默认显示所有（全部医院，全部科室）
//        NSLog(@"------点击了 %ld - %ld",indexPath.column,indexPath.row);
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在加载中...";
            FindHeader *head = [[FindHeader alloc]init];
            
            head.target = @"noTokenDControl";
            
            head.method = @"mainTeams";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
//            head.token = [User LocalUser].token;
        
            FindBody *body = [[FindBody alloc]init];
            
            NSArray *departList = [AlldepartModel mj_objectArrayWithKeyValuesArray:self.model.departments];
            //
            AlldepartModel *model = [departList objectAtIndex:indexPath.row];
            
            body.departmentid = model.id;
            
            ConditionFindTeamRequest *request = [[ConditionFindTeamRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            [self.getTeamApi AllteamQuaryList:request.mj_keyValues.mutableCopy];
      
    }else{
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在加载中...";
            
            FindHeader *head = [[FindHeader alloc]init];
            
            head.target = @"noTokenDControl";
            
            head.method = @"mainTeams";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
//            head.token = [User LocalUser].token;
        
            FindBody *body = [[FindBody alloc]init];
            
            ConditionFindTeamRequest *request = [[ConditionFindTeamRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            //            NSLog(@"%@",request);
            
            [self.getTeamApi AllteamQuaryList:request.mj_keyValues.mutableCopy];
        
    }
        
//    }];

//       [self.teamTableView.mj_header beginRefreshing];

}


- (void)jumpTeam:(UIButton *)button{
    
    ConditionTeamModel *model = [self.teamListArray objectAtIndex:button.tag];
    
//    NSLog(@"%@",model.name);
    
    if ([Utils showLoginPageIfNeeded]) {} else {
        
        MyTeamViewController *team = [[MyTeamViewController alloc]init];
        
        team.isPersonCenter = NO;
        
        team.teamID = model.id;
        
        //    NSLog(@"团队id：%@",model.id);
        
        [self.navigationController pushViewController:team animated:YES];
        
    }
    
}



@end
