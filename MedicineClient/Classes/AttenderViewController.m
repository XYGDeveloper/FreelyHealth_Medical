//
//  AttenderViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AttenderViewController.h"
#import "TableChooseCell.h"
#import "GroupConSearchModel.h"
#import "SearchDoctorViewController.h"
#define HeaderHeight 50
#define CellHeight 106
#import "GetJoinedDoctorModel.h"
#import "GetJoinedDoctorApi.h"
#import "JoinedDoctorRequest.h"
#import "EmptyManager.h"
//
#import "SendInviteApi.h"
#import "SendInviteRequest.h"
//
#import "SendInviteRequest.h"
#import "ModifyHzAddMemberApi.h"
typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);
@interface AttenderViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *AttenderTableview;
@property (nonatomic,strong)UIButton *sureButton;
@property(nonatomic,strong)NSMutableArray * choosedArr;
@property(nonatomic,copy)ChooseBlock block;
@property (nonatomic,assign)BOOL ifAllSelected;
@property (nonatomic,assign)BOOL ifAllSelecteSwitch;
@property (nonatomic,strong)NSArray *tempArray;
@property (nonatomic, strong) GetJoinedDoctorApi *doctorListApi;
@property (nonatomic, strong) GetJoinedDoctorApi *doctorListApisec;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSArray *getArr;
@property (nonatomic, strong) SendInviteApi *addAPI;
//
@property (nonatomic,strong)ModifyHzAddMemberApi *modifyAddApi;

@end

@implementation AttenderViewController
- (SendInviteApi *)addAPI{
    if (!_addAPI) {
        _addAPI = [[SendInviteApi alloc]init];
        _addAPI.delegate = self;
    }
    return _addAPI;
}

- (ModifyHzAddMemberApi *)modifyAddApi{
    if (!_modifyAddApi) {
        _modifyAddApi = [[ModifyHzAddMemberApi alloc]init];
        _modifyAddApi.delegate = self;
    }
    return _modifyAddApi;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.selectSecond) {
//        _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
//
//        self.AttenderTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//            //获取医生列表
//            joinedDoctorHeader *header = [[joinedDoctorHeader alloc]init];
//
//            header.target = @"doctorHuizhenControl";
//
//            header.method = @"getMdtMembers";
//
//            header.versioncode = Versioncode;
//
//            header.devicenum = Devicenum;
//
//            header.fromtype = Fromtype;
//
//            header.token = [User LocalUser].token;
//
//            joinedDoctorBody *bodyer = [[joinedDoctorBody alloc]init];
//            if (!self.huizhenID) {
//                bodyer.id  = self.huizhenIDNokf;
//            }else{
//                bodyer.id = self.huizhenID;
//            }
//
//            JoinedDoctorRequest *requester = [[JoinedDoctorRequest alloc]init];
//
//            requester.head = header;
//
//            requester.body = bodyer;
//
//            NSLog(@"%@",requester);
//
//            [self.doctorListApisec getJoinedDoctorList:requester.mj_keyValues.mutableCopy];
//        }];
//
//        [self.AttenderTableview.mj_header beginRefreshing];
//    }else
//    {
        _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        self.AttenderTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            //获取医生列表
            joinedDoctorHeader *header = [[joinedDoctorHeader alloc]init];
            
            header.target = @"doctorHuizhenControl";
            
            header.method = @"getMdtMembers";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            joinedDoctorBody *bodyer = [[joinedDoctorBody alloc]init];
            bodyer.id = self.huizhenID;
            JoinedDoctorRequest *requester = [[JoinedDoctorRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.doctorListApi getJoinedDoctorList:requester.mj_keyValues.mutableCopy];
        }];
        
        [self.AttenderTableview.mj_header beginRefreshing];
        
//    }
}

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (GetJoinedDoctorApi *)doctorListApi{
    if (!_doctorListApi) {
        _doctorListApi = [[GetJoinedDoctorApi alloc]init];
        _doctorListApi.delegate = self;
    }
    return _doctorListApi;
}

- (GetJoinedDoctorApi *)doctorListApisec{
    if (!_doctorListApisec) {
        _doctorListApisec = [[GetJoinedDoctorApi alloc]init];
        _doctorListApisec.delegate = self;
    }
    return _doctorListApisec;
}


- (UITableView *)AttenderTableview{
    if (!_AttenderTableview) {
        _AttenderTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _AttenderTableview.delegate = self;
        _AttenderTableview.dataSource = self;
        _AttenderTableview.separatorColor = DefaultBackgroundColor;
        _AttenderTableview.backgroundColor = DefaultBackgroundColor;
        [_AttenderTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_AttenderTableview registerClass:[TableChooseCell class] forCellReuseIdentifier:NSStringFromClass([TableChooseCell class])];
    }
    return _AttenderTableview;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = AppStyleColor;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sureButton;
}
- (void)setLayOut{
    [self.AttenderTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.AttenderTableview.mj_header endRefreshing];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.AttenderTableview.mj_header endRefreshing];
    if (api == _doctorListApi) {
        [[EmptyManager sharedManager] removeEmptyFromView:self.AttenderTableview];
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.AttenderTableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无数据" operationText:nil operationBlock:nil];
        } else {
            self.tempArray = responsObject;
            if (self.tempArray.count <= 0) {
                [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
            }else{
                [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",self.tempArray.count] forState:UIControlStateNormal];
            }
            [self.AttenderTableview reloadData];

        }
    }
    
    if (api == _addAPI) {
      
        if (self.tempArray.count <= 0) {
            [Utils postMessage:@"请选择医生！" onView:self.view];
            return;
        }
        GroupConSearchModel *model = [self.tempArray firstObject];
        
        if (self.Fillblock) {
            self.Fillblock(model.dname,[NSString stringWithFormat:@"%lu",(unsigned long)self.tempArray.count]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (api == _modifyAddApi) {
        
        if (self.tempArray.count <= 0) {
            [Utils postMessage:@"请选择医生！" onView:self.view];
            return;
        }
        GroupConSearchModel *model = [self.tempArray firstObject];
        
        if (self.Fillblock) {
            self.Fillblock(model.dname,[NSString stringWithFormat:@"%lu",(unsigned long)self.tempArray.count]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,45)];
    selectView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth- 60, 45)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.userInteractionEnabled = YES;
    nameLabel.font = FontNameAndSize(16);
    nameLabel.textColor = DefaultBlackLightTextClor;
    nameLabel.text = @"选择新的会议人";
    [selectView addSubview:nameLabel];
    UIImageView *arrowImage = [[UIImageView alloc]init];
    arrowImage.userInteractionEnabled = YES;
    arrowImage.image = [UIImage imageNamed:@"detail_s"];
    [selectView addSubview:arrowImage];
    [self.view addSubview:selectView];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.right.mas_equalTo(-20);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toselct)];
    [selectView addGestureRecognizer:tap];
    [self.view addSubview:self.AttenderTableview];
    [self.view addSubview:self.sureButton];
    [self.sureButton addTarget:self action:@selector(sureAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self setLayOut];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    //temp
    
}

- (void)sureAdd:(UIButton *)btn{
    
    if (self.isModify == YES) {
        [Utils addHudOnView:self.view];
        sendHeader *head = [[sendHeader alloc]init];
        //
        head.target = @"doctorHuizhenControl";
        
        head.method = @"huizhenPeopleUpdate";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        sendBody *body = [[sendBody alloc]init];
        body.id = self.huizhenID;    //会诊记录id
        NSMutableArray *peoples = [NSMutableArray array];
        for (GroupConSearchModel *model in _choosedArr) {
            People *people  = [[People alloc]init];
            people.did = model.did;
            [peoples addObject:people];
        }
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
        
        [self.modifyAddApi modifyHzAddMember:request.mj_keyValues.mutableCopy];
        
    }else{
        [Utils addHudOnView:self.view];
        sendHeader *head = [[sendHeader alloc]init];
        //
        head.target = @"doctorHuizhenControl";
        
        head.method = @"huizhenPeopleAdd";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        sendBody *body = [[sendBody alloc]init];
        body.id = self.huizhenID;
        NSMutableArray *peoples = [NSMutableArray array];
        
        for (GroupConSearchModel *model in _choosedArr) {
            People *people  = [[People alloc]init];
            people.did = model.did;
            [peoples addObject:people];
        }
        
        for (GroupConSearchModel *model in self.tempArray) {
            People *people  = [[People alloc]init];
            people.did = model.did;
            [peoples addObject:people];
        }
        
        body.peoples = peoples;
        
        SendInviteRequest *request = [[SendInviteRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.addAPI sendInvite:request.mj_keyValues.mutableCopy];
    }
   
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ChooseAllClick:(UIButton *)button{
    _ifAllSelecteSwitch = YES;
    UIButton * chooseIcon = (UIButton *)[self.AttenderTableview.tableHeaderView viewWithTag:10];
    chooseIcon.selected = !_ifAllSelected;
    _ifAllSelected = !_ifAllSelected;
    if (_ifAllSelected) {
        [_choosedArr removeAllObjects];
        [_choosedArr addObjectsFromArray:self.tempArray];
    }
    else{
        [_choosedArr removeAllObjects];
    }
    [self.AttenderTableview reloadData];
    _block(@"All",_choosedArr);
    
}

#pragma mark--TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempArray.count;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        TableChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableChooseCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GroupConSearchModel *model = [self.tempArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.dname;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.dfacepath]placeholderImage:[UIImage imageNamed:@"1.jpg"]];
//        cell.jopLabel.text = [NSString stringWithFormat:@"%@  %@",model.dhospital,model.dpost];
    
        NSLog(@"%@%@%@%@",model.dusername,model.dfacepath,model.dhospital,model.dpost);
        _ifAllSelected = YES;
        if (_ifAllSelecteSwitch) {
            [cell UpdateCellWithState:_ifAllSelected];
            if (indexPath.row == self.tempArray.count-1) {
                _ifAllSelecteSwitch  = NO;
            }
        }
       if (_ifAllSelecteSwitch) {
        [cell UpdateCellWithState:_ifAllSelected];
        if (indexPath.row == self.tempArray.count-1) {
            _ifAllSelecteSwitch  = NO;
           }
        }

    if ([self.tempArray containsObject:model.dusername]) {
        cell.isSelected  = YES;
        cell.userInteractionEnabled = NO;
        [cell UpdateCellWithState:cell.isSelected];
    }
    
    if ([model.dusername isEqualToString:[User LocalUser].name]) {
        cell.isSelected  = YES;
        [cell.SelectIconBtn setImage:[UIImage imageNamed:@"nosel"] forState:UIControlStateNormal];
    }
//    [cell UpdateCellWithState:YES];
//    cell.userInteractionEnabled = NO;
//    if (self.selectSecond == YES) {
//        [cell UpdateCellWithState:YES];
//    }else{
//        [cell UpdateCellWithState:YES];
//    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        TableChooseCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GroupConSearchModel *model = [self.tempArray objectAtIndex:indexPath.row];
        [cell UpdateCellWithState:!cell.isSelected];
        if (cell.isSelected) {
            [_choosedArr safeAddObject:model];
        }
        else{
            [_choosedArr removeObject:model];
        }
        if (_choosedArr.count<self.tempArray.count) {
            _ifAllSelected = NO;
            UIButton * chooseIcon = (UIButton *)[self.AttenderTableview.tableHeaderView viewWithTag:10];
            chooseIcon.selected = _ifAllSelected;
        }
        NSLog(@"%@",_choosedArr);
    
        [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%ld)",(unsigned long)_choosedArr.count] forState:UIControlStateNormal];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return CellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 10;
    } else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (void)toselct{
    
    if (self.isModify == YES) {
        SearchDoctorViewController *search = [SearchDoctorViewController new];
        search.isModify = YES;
        search.passArray = self.tempArray;
        NSLog(@"之前的数组：%@",self.tempArray);
        search.huizhenid = self.huizhenID;
        search.count = [NSString stringWithFormat:@"%ld",_choosedArr.count];
        search.sure = ^() {
            self.selectSecond = YES;
        };
        search.title = @"会诊邀请";
        [self.navigationController pushViewController:search animated:YES];
        
    }else{
        SearchDoctorViewController *search = [SearchDoctorViewController new];
        search.passArray = self.tempArray;
        NSLog(@"之前的数组：%@",self.tempArray);
        search.huizhenid = self.huizhenID;
        search.count = [NSString stringWithFormat:@"%ld",_choosedArr.count];
        search.sure = ^() {
            self.selectSecond = YES;
        };
        search.title = @"会诊邀请";
        [self.navigationController pushViewController:search animated:YES];
    }
   
}

@end
