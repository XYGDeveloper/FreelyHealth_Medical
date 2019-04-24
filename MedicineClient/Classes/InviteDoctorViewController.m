//
//  InviteDoctorViewController.m
//  MedicineClient
//  Created by xyg on 2017/11/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.

#import "InviteDoctorViewController.h"
#import "QQWSearchBar.h"
#import "MulChooseTable.h"
#import "ShowViewController.h"
#import "SelectTeamApi.h"
#import "SeLectTeamListRequest.h"
#import "JopModel.h"
#import "GroupConSearchModel.h"
#import "GroupSearchRequest.h"
#import "getroupListApi.h"
#import "TableChooseCell.h"
#import <TPKeyboardAvoidingTableView.h>
#define HeaderHeight 50
#define CellHeight 106
#import "SendInviteApi.h"
#import "SendInviteRequest.h"
#import "GroupConSearchModel.h"
#import "GetGroupInfoApi.h"
#import "GetGroupInfoRequest.h"
#import "ReGetGroupConInfoModel.h"
#import "MBProgressHUD+BWMExtension.h"
typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);

@interface InviteDoctorViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiRequestDelegate>
{
    NSMutableArray * dataArr;
}

@property (nonatomic,strong)MBProgressHUD *hub;

@property(nonatomic,strong)NSMutableArray * choosedArr;
@property(nonatomic,copy)ChooseBlock block;
@property (nonatomic,assign)BOOL ifAllSelected;
@property (nonatomic,assign)BOOL ifAllSelecteSwitch;

@property (nonatomic,strong)UISearchBar *searchbar;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *table;  //团队tableview

@property (nonatomic,strong)UITableView *MyTable;  //成员tableview

@property (nonatomic,strong)NSArray *teamArray;

@property (nonatomic,strong)NSArray *memberArray;

@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)SelectTeamApi *api;   //预设团队

@property (nonatomic,strong)getroupListApi *doctorApi;   //预设团队

@property (nonatomic,strong)SendInviteApi *Addapi;

@property (nonatomic,strong)GetGroupInfoApi *Infoapi;

@end

@implementation InviteDoctorViewController



- (SelectTeamApi *)api
{
    
    if (!_api) {
        
        _api = [[SelectTeamApi alloc]init];
        
        _api.delegate = self;
    }
    return _api;
}

- (getroupListApi *)doctorApi
{
    if (!_doctorApi) {
        _doctorApi = [[getroupListApi alloc]init];
        _doctorApi.delegate  = self;
    }
    return _doctorApi;
}

- (SendInviteApi *)Addapi
{
    if (!_Addapi) {
        
        _Addapi = [[SendInviteApi alloc]init];
        
        _Addapi.delegate = self;
        
    }
    
    return _Addapi;
    
}

- (GetGroupInfoApi *)Infoapi
{
    if (!_Infoapi) {
        
        _Infoapi = [[GetGroupInfoApi alloc]init];
        
        _Infoapi.delegate = self;
        
    }
    
    return _Infoapi;
    
}

- (TPKeyboardAvoidingTableView *)table
{
    if (!_table) {
        _table = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-64) style:UITableViewStyleGrouped];
        _table.backgroundColor = [UIColor whiteColor];
        _table.delegate = self;
        _table.dataSource = self;
        
    }
    return _table;
    
}
- (UITableView *)MyTable
{
    if (!_MyTable) {
        _MyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight- 64 - 64- 50) style:UITableViewStylePlain];
        _MyTable.separatorStyle = UITableViewStylePlain;
        _MyTable.backgroundColor = [UIColor whiteColor];
        _MyTable.delegate = self;
        _MyTable.dataSource = self;
        
    }
    return _MyTable;
}


- (UIButton *)sureButton
{
    if (!_sureButton) {
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _sureButton.backgroundColor = AppStyleColor;
        
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18.0f];
    
    }
    return _sureButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.searchbar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    // 设置SearchBar的颜色主题为白色
    self.searchbar.backgroundColor = [UIColor whiteColor];
    self.searchbar.placeholder = @"按团队名称/医生姓名/科室名称搜索";
    self.searchbar.delegate = self;
    [self.view addSubview:self.searchbar];
    UITextField *searchField = [self.searchbar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:DefaultBackgroundColor];
        searchField.layer.cornerRadius = 1.0f;
        searchField.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
        searchField.layer.borderColor = DefaultBackgroundColor.CGColor;
        searchField.layer.borderWidth = 3;
        searchField.layer.masksToBounds = NO;
    }
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.table.hidden = NO;
    
    _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:self.MyTable];

    self.MyTable.hidden = YES;
    
    [self.view addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    self.sureButton.hidden = YES;
    
    [self.sureButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    teamLHeader *head = [[teamLHeader alloc]init];
    //
    head.target = @"noTokenDControl";
    
    head.method = @"getDTeamList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    teamLBody *body = [[teamLBody alloc]init];
    
    SeLectTeamListRequest *request = [[SeLectTeamListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api gethosteamList:request.mj_keyValues.mutableCopy];
    
    // Do any additional setup after loading the view.
}

-(UIView *)CreateHeaderView_HeaderTitle:(NSString *)title{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
    UILabel * HeaderTitleLab = [[UILabel alloc]init];
    HeaderTitleLab.text = title;
    [headerView addSubview:HeaderTitleLab];
    [HeaderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(0);
        make.height.mas_equalTo(headerView.mas_height);
    }];
    UIButton *chooseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseIcon.tag = 10;
    [chooseIcon setImage:[UIImage imageNamed:@"kuang_normal"] forState:UIControlStateNormal];
    [chooseIcon setImage:[UIImage imageNamed:@"kuang_sel"] forState:UIControlStateSelected];
    chooseIcon.userInteractionEnabled = NO;
    [headerView addSubview:chooseIcon];
    [chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HeaderTitleLab.mas_right).offset(10);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.top.equalTo(headerView.mas_top);
        make.height.mas_equalTo(headerView.mas_height);
        make.width.mas_equalTo(50);
    }];
    
    UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    [chooseBtn addTarget:self action:@selector(ChooseAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:chooseBtn];
    return headerView;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.hub bwm_hideWithTitle:command.response.msg
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeError];
    
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    if (api == _api) {
        
        self.teamArray = responsObject;
        [self.table reloadData];
        
    }
    
    if (api == _doctorApi) {
        
        self.memberArray = responsObject;
        
        NSLog(@"%@",self.memberArray);
        
        [self.MyTable reloadData];
        
    }
    
    if (api == _Addapi) {
        
        //获取团队团队成员跳转传过去
        
        [self.hub bwm_hideWithTitle:@"添加成功"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval
                            msgType:BWMMBProgressHUDMsgTypeSuccessful];
        
        getGroupHeader *head = [[getGroupHeader alloc]init];
        //
        head.target = @"huizhenControl";
        
        head.method = @"huizhenPeople";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        getGroupBody *body = [[getGroupBody alloc]init];
        
        body.id = self.groupID;  //会诊id
        
        GetGroupInfoRequest *request = [[GetGroupInfoRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.Infoapi getGroupInfo:request.mj_keyValues.mutableCopy];
        
    }
    
    if (api == _Infoapi) {
        
            ShowViewController *invite = [ShowViewController new];
        
            invite.title = @"会诊邀请";
        
            invite.groupID = self.groupID;
        
            invite.chooseArr = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responsObject[@"peoples"]];
        
            [self.navigationController pushViewController:invite animated:YES];
        
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.MyTable) {
        
        return CellHeight;
        
    }else{
        
        return 40;
    }
    
}


-(void)click{
  
    self.hub = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在添加..."];
    
    sendHeader *head = [[sendHeader alloc]init];
    //
    head.target = @"huizhenControl";
    
    head.method = @"huizhenPeopleAdd";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    sendBody *body = [[sendBody alloc]init];
    
    body.id = self.groupID;    //会诊记录id
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (GroupConSearchModel *model in _choosedArr) {
        
        People *people  = [[People alloc]init];
        people.did = model.did;
        [peoples addObject:people];
    }
    
    body.peoples = peoples;
    
    SendInviteRequest *request = [[SendInviteRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.Addapi sendInvite:request.mj_keyValues.mutableCopy];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
 
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
  
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.table) {
        return self.teamArray.count;
    }else{
        return self.memberArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.table) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0f];
        JopModel *model = [self.teamArray safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        NSString * identifier = [NSString stringWithFormat:@"cellId%ld",(long)indexPath.row];
        TableChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!cell) {
            cell = [[TableChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        GroupConSearchModel *model = [self.memberArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.dusername;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.dfacepath]placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        cell.jopLabel.text = [NSString stringWithFormat:@"%@  %@",model.dhospital,model.dpost];
        
        NSLog(@"%@%@%@%@",model.dusername,model.dfacepath,model.dhospital,model.dpost);
        
        if (_ifAllSelecteSwitch) {
            [cell UpdateCellWithState:_ifAllSelected];
            if (indexPath.row == self.memberArray.count-1) {
                _ifAllSelecteSwitch  = NO;
            }
        }
        [cell UpdateCellWithState:NO];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.table) {
        JopModel *model = [self.teamArray safeObjectAtIndex:indexPath.row];
        self.searchbar.text = model.name;
        //按照团队进行搜索
        //搜索接口
        presearchHeader *head = [[presearchHeader alloc]init];
        head.target = @"huizhenControl";
        head.method = @"search";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        presearchBody *body = [[presearchBody alloc]init];
        GroupSearchRequest *request = [[GroupSearchRequest alloc]init];
        request.head = head;
        request.body = body;
        body.keyword = self.searchbar.text;
        NSLog(@"%@",request);
        [self.doctorApi getDoctorSearchList:request.mj_keyValues.mutableCopy];
        self.table.hidden = YES;
        self.MyTable.hidden = NO;
        self.sureButton.hidden = NO;
        [self.view endEditing:YES];

    }else{
       
        TableChooseCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GroupConSearchModel *model = [self.memberArray objectAtIndex:indexPath.row];
        
        [cell UpdateCellWithState:!cell.isSelected];
        
        if (cell.isSelected) {
            [_choosedArr safeAddObject:model];
        }
        else{
            [_choosedArr removeObject:model];
        }
        
        if (_choosedArr.count<self.memberArray.count) {
            _ifAllSelected = NO;
            UIButton * chooseIcon = (UIButton *)[_MyTable.tableHeaderView viewWithTag:10];
            chooseIcon.selected = _ifAllSelected;
        }
        NSLog(@"%@ %@",model.did,_choosedArr);
    }
}

#pragma mark-- uisearchbardelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.table.hidden = YES;
    self.MyTable.hidden = NO;
    self.sureButton.hidden = NO;
    return YES;
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    self.table.hidden = YES;
    self.MyTable.hidden = NO;
    self.sureButton.hidden = NO;

    return YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //按照团队进行搜索
    //搜索接口
    presearchHeader *head = [[presearchHeader alloc]init];
    head.target = @"huizhenControl";
    head.method = @"search";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    presearchBody *body = [[presearchBody alloc]init];
    GroupSearchRequest *request = [[GroupSearchRequest alloc]init];
    request.head = head;
    request.body = body;
    body.keyword = self.searchbar.text;
    NSLog(@"%@",request);
    [self.doctorApi getDoctorSearchList:request.mj_keyValues.mutableCopy];
    [self.view endEditing:YES];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    if (self.searchbar.text.length <= 0) {
        
        self.table.hidden = NO;
        
        self.MyTable.hidden = YES;
        
        self.sureButton.hidden = YES;
        
    }
}

-(void)ChooseAllClick:(UIButton *)button{
    _ifAllSelecteSwitch = YES;
    UIButton * chooseIcon = (UIButton *)[_MyTable.tableHeaderView viewWithTag:10];
    chooseIcon.selected = !_ifAllSelected;
    _ifAllSelected = !_ifAllSelected;
    if (_ifAllSelected) {
        [_choosedArr removeAllObjects];
        [_choosedArr addObjectsFromArray:self.memberArray];
    }
    else{
        [_choosedArr removeAllObjects];
    }
    [_MyTable reloadData];
    _block(@"All",_choosedArr);
    
}

@end
