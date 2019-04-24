//
//  SeMulViewController.m
//  MedicineClient
//
//  Created by L on 2017/12/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SeMulViewController.h"
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
#define HeaderHeight 50
#define CellHeight 106

#import "DeleGroupApi.h"
#import "DeleGroupRequest.h"
#import "GetGroupInfoRequest.h"
#import "GetGroupInfoApi.h"
#import "MBProgressHUD+BWMExtension.h"
typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);

@interface SeMulViewController ()
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiRequestDelegate>
{
    NSMutableArray * dataArr;
}

@property(nonatomic,strong)NSMutableArray * choosedArr;
@property(nonatomic,copy)ChooseBlock block;
@property (nonatomic,assign)BOOL ifAllSelected;
@property (nonatomic,assign)BOOL ifAllSelecteSwitch;

@property (nonatomic,strong)UISearchBar *searchbar;

@property (nonatomic,strong)UITableView *table;  //团队tableview

@property (nonatomic,strong)NSArray *teamArray;

@property (nonatomic,strong)NSArray *memberArray;

@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)SelectTeamApi *api;   //预设团队

@property (nonatomic,strong)getroupListApi *doctorApi;   //预设团队

@property (nonatomic,strong)DeleGroupApi *deleApi;   //预设团队

@property (nonatomic,strong)GetGroupInfoApi *infoApi;   //预设团队

@property (nonatomic,strong)MBProgressHUD *hub;   //预设团队
@end

@implementation SeMulViewController

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

- (DeleGroupApi *)deleApi
{
    if (!_deleApi) {
        _deleApi = [[DeleGroupApi alloc]init];
        _deleApi.delegate  = self;
    }
    return _deleApi;
}

- (GetGroupInfoApi *)infoApi
{
    if (!_infoApi) {
        _infoApi = [[GetGroupInfoApi alloc]init];
        _infoApi.delegate  = self;
    }
    return _infoApi;
}

- (UITableView *)table
{
    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-50) style:UITableViewStyleGrouped];
        _table.backgroundColor = [UIColor whiteColor];
        _table.delegate = self;
        _table.dataSource = self;
        
    }
    return _table;
    
}

- (UIButton *)sureButton
{
    if (!_sureButton) {
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _sureButton.backgroundColor = AppStyleColor;
        
        [_sureButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18.0f];
        
    }
    
    return _sureButton;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.table registerClass:[TableChooseCell class] forCellReuseIdentifier:NSStringFromClass([TableChooseCell class])];
    [self.view addSubview:self.table];
    
    [self.table reloadData];
    
    _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    [self.sureButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    //    teamLHeader *head = [[teamLHeader alloc]init];
    //    //
    //    head.target = @"noTokenDControl";
    //
    //    head.method = @"getDTeamList";
    //
    //    head.versioncode = Versioncode;
    //
    //    head.devicenum = Devicenum;
    //
    //    head.fromtype = Fromtype;
    //
    //    teamLBody *body = [[teamLBody alloc]init];
    //
    //    SeLectTeamListRequest *request = [[SeLectTeamListRequest alloc]init];
    //
    //    request.head = head;
    //
    //    request.body = body;
    //
    //    NSLog(@"%@",request);
    //
    //    [self.api gethosteamList:request.mj_keyValues.mutableCopy];
    
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
    
    if (api == _deleApi) {
        
        [self.hub bwm_hideWithTitle:@"删除成功"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval
                            msgType:BWMMBProgressHUDMsgTypeSuccessful];
        
        getGroupHeader *head = [[getGroupHeader alloc]init];
        //
        head.target = @"huizhenControl";
        
        head.method = @"searchGroupCut";
        
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
        
        [self.infoApi getGroupInfo:request.mj_keyValues.mutableCopy];
    }
    
    if (api == _infoApi) {
        
        NSMutableArray *resultarr = [NSMutableArray array];
        
        resultarr = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responsObject[@"peoples"]];
        
        if (self.endArr) {
            
            self.endArr();
        };
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CellHeight;
    
}


-(void)click{
    
    self.hub = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在删除..."];
    
    deleGroupHead *head = [[deleGroupHead alloc]init];
    //
    head.target = @"huizhenControl";
    
    head.method = @"huizhenPeopleGroupCut";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    deleGroupBody *body = [[deleGroupBody alloc]init];
    
    body.id  =self.groupID;
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (GroupConSearchModel *model in _choosedArr) {
        
        delePeople *people  = [[delePeople alloc]init];
        
        people.did = model.did;
        
        [peoples addObject:people];
        
    }
    
    body.peoples = peoples;
    
    DeleGroupRequest *request = [[DeleGroupRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.deleApi deleGroup:request.mj_keyValues.mutableCopy];
    
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
    
    return self.list.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = [NSString stringWithFormat:@"cellId%ld",(long)indexPath.row];
    TableChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[TableChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GroupConSearchModel *model = [self.list objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.dusername;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.dfacepath]];
    cell.jopLabel.text = [NSString stringWithFormat:@"%@  %@",model.dhospital,model.dpost];
    
    NSLog(@"%@%@%@%@",model.dusername,model.dfacepath,model.dhospital,model.dpost);
    
    if (_ifAllSelecteSwitch) {
        [cell UpdateCellWithState:_ifAllSelected];
        if (indexPath.row == self.list.count-1) {
            _ifAllSelecteSwitch  = NO;
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableChooseCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupConSearchModel *model = [self.list objectAtIndex:indexPath.row];
    
    [cell UpdateCellWithState:!cell.isSelected];
    
    if (cell.isSelected) {
        [_choosedArr safeAddObject:model];
    }
    else{
        [_choosedArr removeObject:model];
    }
    
    if (_choosedArr.count<self.memberArray.count) {
        _ifAllSelected = NO;
        UIButton * chooseIcon = (UIButton *)[self.table.tableHeaderView viewWithTag:10];
        chooseIcon.selected = _ifAllSelected;
    }
    
    NSLog(@"%@ %@",model.did,_choosedArr);
    
}


-(void)ChooseAllClick:(UIButton *)button{
    _ifAllSelecteSwitch = YES;
    UIButton * chooseIcon = (UIButton *)[self.table.tableHeaderView viewWithTag:10];
    chooseIcon.selected = !_ifAllSelected;
    _ifAllSelected = !_ifAllSelected;
    if (_ifAllSelected) {
        [_choosedArr removeAllObjects];
        [_choosedArr addObjectsFromArray:self.list];
    }
    else{
        [_choosedArr removeAllObjects];
    }
    [self.table reloadData];
    _block(@"All",_choosedArr);
    
}


@end
