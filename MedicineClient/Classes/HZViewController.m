//
//  HZViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZViewController.h"
#import "HZWailtTableViewCell.h"
#import "HZHandleTableViewCell.h"
#import "BeginHuizhenViewController.h"
#import "LrdSuperMenu.h"
#import "MyAppionmentModel.h"
#import "MyappionmentListApi.h"
#import "MyAppionmentListRequest.h"
#import "JoinHZapi.h"
#import "JoinHZRequest.h"
#import "EmptyManager.h"
#import "HZDetailViewController.h"
#import "WailtHZViewController.h"
#import "WailtHandleViewController.h"
#import "NottendHzViewController.h"
#import "FinishHZViewController.h"
#import "CancelledHZViewController.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
@interface HZViewController ()<UITableViewDelegate,UITableViewDataSource,LrdSuperMenuDataSource, LrdSuperMenuDelegate,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)UITableView *HZtableview;
@property (nonatomic, strong) NSArray *classify;
@property (nonatomic, strong) LrdSuperMenu *menu;
@property (nonatomic,strong)MyappionmentListApi *listApi;
@property (nonatomic,strong)JoinHZapi *joinApi;
@property (nonatomic,strong)JoinHZapi *notjoinApi;
@property (nonatomic,strong)NSMutableArray *listarray;
@property (nonatomic,strong)NSString *type;

@end

@implementation HZViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self refreshTableviewWithid:@"1"];
    [self.HZtableview.mj_header beginRefreshing];
}

- (UITableView *)HZtableview{
    if (!_HZtableview) {
        _HZtableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_HZtableview registerClass:[HZWailtTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HZWailtTableViewCell class])];
        [_HZtableview registerClass:[HZHandleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HZHandleTableViewCell class])];
        _HZtableview.delegate = self;
        _HZtableview.dataSource = self;
        _HZtableview.showsVerticalScrollIndicator = NO;
    }
    return _HZtableview;
}
- (MyappionmentListApi *)listApi{
    if (!_listApi) {
        _listApi = [[MyappionmentListApi alloc]init];
        _listApi.delegate = self;
    }
    return _listApi;
}

- (JoinHZapi *)joinApi{
    if (!_joinApi) {
        _joinApi = [[JoinHZapi alloc]init];
        _joinApi.delegate = self;
    }
    return _joinApi;
}

- (JoinHZapi *)notjoinApi{
    if (!_notjoinApi) {
        _notjoinApi = [[JoinHZapi alloc] init];
        _notjoinApi.delegate = self;
    }
    return _notjoinApi;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    NSLog(@"订单列表%@",responsObject);
    [self.HZtableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.HZtableview];
    if (api == _listApi) {
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.HZtableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无数据" operationText:nil operationBlock:nil];
        } else {
            self.listarray = [NSMutableArray array];
            [self.listarray removeAllObjects];
            [self.listarray addObjectsFromArray:responsObject];
            [self.HZtableview reloadData];
        }
        
    }
   
    if (api == _joinApi) {
        [Utils removeAllHudFromView:self.view];
        [self refreshTableviewWithid:self.type];
    }
    if (api == _notjoinApi) {
        [Utils removeHudFromView:self.view];
        [self refreshTableviewWithid:self.type];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils postMessage:command.response.msg onView:self.view];
    [self.HZtableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.HZtableview];
    if (api == _listApi) {
        weakify(self);
        if ([User LocalUser].token) {
            [[EmptyManager sharedManager] showNetErrorOnView:self.HZtableview response:command.response operationBlock:^{
                strongify(self)
                [self.HZtableview.mj_header beginRefreshing];
            }];
        }else{
             [[EmptyManager sharedManager] showEmptyOnView:self.HZtableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无数据" operationText:nil operationBlock:nil];
        }
      
    }
    
    if (api == _joinApi) {
        [Utils removeAllHudFromView:self.view];
    }
    
    if (api == _notjoinApi) {
        [Utils removeAllHudFromView:self.view];
    }
    
}

- (void)refreshTableviewWithid:(NSString *)type{
    
        MyappionmentListHeader *header = [[MyappionmentListHeader alloc]init];
        
        header.target = @"doctorHuizhenControl";
        
        header.method = @"myHuizhenList";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        MyappionmentListBody *bodyer = [[MyappionmentListBody alloc]init];
        
        bodyer.type = type;
        
        MyAppionmentListRequest *requester = [[MyAppionmentListRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        [self.listApi getAppionmentList:requester.mj_keyValues.mutableCopy];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会诊";
    self.view.backgroundColor = DefaultBackgroundColor;
    self.HZtableview.backgroundColor = DefaultBackgroundColor;
     self.classify = @[@"未结束", @"已结束/取消/不参加", @"我发出的"];
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44.5];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    [_menu selectDeafultIndexPath];
    [self.view addSubview:self.HZtableview];
    [self.HZtableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(44.5);
        make.bottom.mas_equalTo(-44.5);
    }];
    [self setRightNavigationItemWithTitle:@"发起会诊" action:@selector(toHuizhen)];
    
    self.HZtableview.mj_header  = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self refreshTableviewWithid:@"1"];
    }];
    [self.HZtableview.mj_header beginRefreshing];
    
}

- (void)toHuizhen{
    if ([Utils showLoginPageIfNeeded]) {} else {
        
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                BeginHuizhenViewController *huizhen = [BeginHuizhenViewController new];
                huizhen.title = @"发起会诊";
                [self.navigationController pushViewController:huizhen animated:YES];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
    }
}
#pragma mark- TableviewDdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAppionmentModel *model = [self.listarray objectAtIndex:indexPath.row];
    if ([model.iscanyu isEqualToString:@"D"]) {
        HZHandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZHandleTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWITHModel:model];
        cell.attendblock = ^{
            
            if ([Utils showLoginPageIfNeeded]) {} else {
                
                [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
                    if ([auth isEqualToString:@"3"]) {
                        [Utils addHudOnView:self.view];
                        joinHZHeader *header = [[joinHZHeader alloc]init];
                        header.target = @"doctorHuizhenControl";
                        header.method = @"controlCanyu";
                        header.versioncode = Versioncode;
                        header.devicenum = Devicenum;
                        header.fromtype = Fromtype;
                        header.token = [User LocalUser].token;
                        joinHZBody *bodyer = [[joinHZBody alloc]init];
                        bodyer.iscanyu = @"1";
                        bodyer.id = model.id;
                        JoinHZRequest *requester = [[JoinHZRequest alloc]init];
                        requester.head = header;
                        requester.body = bodyer;
                        
                        [self.joinApi joinHZ:requester.mj_keyValues.mutableCopy];
                    }else{
                        NSString *content = @"认证任务失败,请尝试重新认证.";
                        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
                    }
                }];
                
            }
          
        };
        
        cell.notattendblock = ^{
            
            if ([Utils showLoginPageIfNeeded]) {} else {
                
                [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
                    if ([auth isEqualToString:@"3"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认不参加该会诊？" preferredStyle:UIAlertControllerStyleAlert];
                        
                        //添加的输入框
                        //WS(weakSelf);
                        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"理由";
                            NSLog(@"%@",textField);
                        }];
                        UIAlertAction *Action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            UITextField *userNameTextField = alert.textFields.firstObject;
                            NSLog(@"得到不参加会诊理由%@",userNameTextField.text);
                            [Utils addHudOnView:self.view];
                            joinHZHeader *header = [[joinHZHeader alloc]init];
                            header.target = @"doctorHuizhenControl";
                            header.method = @"controlCanyu";
                            header.versioncode = Versioncode;
                            header.devicenum = Devicenum;
                            header.fromtype = Fromtype;
                            header.token = [User LocalUser].token;
                            joinHZBody *bodyer = [[joinHZBody alloc]init];
                            bodyer.iscanyu = @"0";
                            bodyer.id = model.id;
                            bodyer.refuse = userNameTextField.text;
                            JoinHZRequest *requester = [[JoinHZRequest alloc]init];
                            requester.head = header;
                            requester.body = bodyer;
                            [self.notjoinApi joinHZ:requester.mj_keyValues.mutableCopy];
                        }];
                        
                        [alert addAction:Action];
                        [alert addAction:twoAc];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }else{
                        NSString *content = @"认证任务失败,请尝试重新认证.";
                        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
                    }
                }];
                
            }
            
        
        };
        return cell;
    }else{
        HZWailtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZWailtTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWITHModel:model];
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAppionmentModel *model = [self.listarray objectAtIndex:indexPath.row];
    if ([model.iscanyu isEqualToString:@"D"]) {
        return 180;
    }else{
        return 146;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Utils showLoginPageIfNeeded]) {} else {
        [[GetAuthStateManager shareInstance]getAuthStateWithallBackBlock:^(NSString *auth) {
            if ([auth isEqualToString:@"3"]) {
                MyAppionmentModel *model = [self.listarray objectAtIndex:indexPath.row];
                    WailtHZViewController *detail = [WailtHZViewController new];
                    detail.title = @"会诊详情";
                    detail.huizhenid = model.id;
                    [self.navigationController pushViewController:detail animated:YES];
            }else{
                NSString *content = @"认证任务失败,请尝试重新认证.";
                [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"暂不认证" rightBtnTitle:@"重新认证" tag:8000];
            }
        }];
    }
}

//dropMenu-Delegate
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 1;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return self.classify.count;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    return self.classify[indexPath.row];
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return [@(arc4random()%1000) stringValue];
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return nil;
}

- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        self.type = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        [self refreshTableviewWithid:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
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

@end
