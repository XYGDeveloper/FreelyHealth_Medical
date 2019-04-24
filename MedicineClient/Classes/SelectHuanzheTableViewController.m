//
//  SelectHuanzheTableViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectHuanzheTableViewController.h"
#import "SelectHanzheTableViewCell.h"
#import "HuanZheModel.h"
#import "GetHuanZheListApi.h"
#import "GetHuanZheListRequest.h"
#import "AddHospitalViewController.h"
#import "EmptyManager.h"
@interface SelectHuanzheTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,ApiRequestDelegate>
@property (nonatomic,strong)GetHuanZheListApi *api;
@property (nonatomic,strong)NSMutableArray *jopArray;

@end

@implementation SelectHuanzheTableViewController

- (void)commonInit
{
    HuanZheListHeader *head = [[HuanZheListHeader alloc]init];
    head.target = @"doctorHuizhenControl";
    head.method = @"customerPaidCaseList";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    HuanZheListBody *body = [[HuanZheListBody alloc]init];
    GetHuanZheListRequest *request = [[GetHuanZheListRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api huanzheList:request.mj_keyValues.mutableCopy];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}

- (GetHuanZheListApi *)api
{
    if (!_api) {
        _api = [[GetHuanZheListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (NSMutableArray *)jopArray
{
    if (!_jopArray) {
        _jopArray = [NSMutableArray array];
    }
    return _jopArray;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
    
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无数据" operationText:nil operationBlock:nil];
    } else {
        [self.jopArray removeAllObjects];
        [self.jopArray addObjectsFromArray:responsObject];
        [self.tableView reloadData];
    }
    
}

//
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] showNetErrorOnView:self.tableView response:command.response operationBlock:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择患者";
    [self configureTableView:self.tableView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureTableView:(UITableView *)tableView {
    
    tableView.separatorInset = UIEdgeInsetsZero;
    
    [tableView registerClass:[SelectHanzheTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SelectHanzheTableViewCell class])];
    UIView *tableFooterViewToGetRidOfBlankRows = [[UIView alloc] initWithFrame:CGRectZero];
    tableFooterViewToGetRidOfBlankRows.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = tableFooterViewToGetRidOfBlankRows;
}

//===============================================
#pragma mark -
#pragma mark UITableView
//===============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.jopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        SelectHanzheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectHanzheTableViewCell class]) forIndexPath:indexPath];
        HuanZheModel *model = [self.jopArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:model];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HuanZheModel *model = [self.jopArray objectAtIndex:indexPath.row];
    if (self.hospital) {
        self.hospital(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
