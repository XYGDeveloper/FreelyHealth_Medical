//
//  scanAgreebookViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "scanAgreebookViewController.h"
#import "FriendCircleCell.h"
#import "AgreeBookTableViewCell.h"
#import "queryIsHaveApi.h"
#import "QueryIsExitAgreeBookRequest.h"
#import "AgreeBookModel.h"
@interface scanAgreebookViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)queryIsHaveApi *ishave;
@property (nonatomic,strong)AgreeBookModel *model;

@end

@implementation scanAgreebookViewController

- (queryIsHaveApi *)ishave{
    if (!_ishave) {
        _ishave = [[queryIsHaveApi alloc]init];
        _ishave.delegate = self;
    }
    return _ishave;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    self.model = responsObject;
    [self.tableview reloadData];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource  =self;
//        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorColor = [UIColor whiteColor];
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    QGBHeader *header = [[QGBHeader alloc]init];
    header.target = @"doctorHuizhenControl";
    header.method = @"queryHuizhenResult";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    QGBBody *bodyer = [[QGBBody alloc]init];
    bodyer.id = self.huizhenid;
    QueryIsExitAgreeBookRequest *requester = [[QueryIsExitAgreeBookRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.ishave quqryAgreebook:requester.mj_keyValues.mutableCopy];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
    [self.tableview registerClass:[AgreeBookTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AgreeBookTableViewCell class])];
    
    [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AgreeBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AgreeBookTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        return cell;
    }else{
        FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class])];
        [cell cellDataWithAppionmentagreeModel:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AgreeBookTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(AgreeBookTableViewCell *cell) {
            [cell refreshWithModel:self.model];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendCircleCell class]) cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
            [cell cellDataWithAppionmentagreeModel:self.model];
        }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.0001;
    } else {
        return 0.0001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
