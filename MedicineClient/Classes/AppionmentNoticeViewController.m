//
//  AppionmentNoticeViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentNoticeViewController.h"
#import "AppionmentMessageListTableViewCell.h"
#import "getMessageListApi.h"
#import "MymessageListRequest.h"
#import "MyMessageModel.h"
#import "ReadMessageApi.h"
#import "EmptyManager.h"
#import "WailtHZViewController.h"
#import "WailtHandleViewController.h"
#import "NottendHzViewController.h"
#import "CancelledHZViewController.h"
#import "FinishHZViewController.h"
#import "getUnreadMessageCounts.h"
@interface AppionmentNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)getMessageListApi *api;
@property (nonatomic,strong)ReadMessageApi *readApi;

@end

@implementation AppionmentNoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    myMessageHeader *head = [[myMessageHeader alloc]init];
    
    head.target = @"doctorMsgControl";
    
    head.method = @"getDoctorMsgList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    myMessageBody *body = [[myMessageBody alloc]init];
    
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api getMessageList:request.mj_keyValues.mutableCopy];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [self.tableview.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"%@",array);
    if (api == _api) {
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"暂无消息" operationText:nil operationBlock:nil];
        } else {
            [self.messageArray removeAllObjects];
            [self.messageArray addObjectsFromArray:responsObject];
            [self.tableview reloadData];
        }
    }
    
    if (api == _readApi) {
        
    }
}

- (getMessageListApi *)api{
    if (!_api) {
        _api = [[getMessageListApi alloc]init];
        _api.delegate  = self;
    }
    return _api;
}

- (ReadMessageApi *)readApi{
    if (!_readApi) {
        _readApi = [[ReadMessageApi alloc]init];
        _readApi.delegate = self;
    }
    return _readApi;
}
- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate  =self;
        _tableview.dataSource  =self;
    }
    return _tableview;
}

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.tableview.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[AppionmentMessageListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class]) cacheByIndexPath:indexPath configuration:^(AppionmentMessageListTableViewCell *cell) {
        [cell refreshWithMessageModel:model];
    }];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppionmentMessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
    [cell refreshWithMessageModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
        [self readMessageWithMessageid:model.id];
        WailtHZViewController *detail = [WailtHZViewController new];
        detail.title = @"会诊详情";
        detail.huizhenid = model.mdtid;
        [self.navigationController pushViewController:detail animated:YES];
}

- (void)readMessageWithMessageid:(NSString *)messageid{
    
    myMessageHeader *head = [[myMessageHeader alloc]init];
    
    head.target = @"doctorMsgControl";
    
    head.method = @"readDoctorMsg";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    myMessageBody *body = [[myMessageBody alloc]init];
    
    body.id = messageid;
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.readApi readMessage:request.mj_keyValues.mutableCopy];
    
}

@end
