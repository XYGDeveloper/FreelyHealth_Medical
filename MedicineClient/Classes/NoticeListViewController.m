//
//  NoticeListViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "NoticeListViewController.h"
#import "AppionmentNoticeViewController.h"
#import "MessageListTableViewCell.h"
#import "getMessageListApi.h"
#import "MymessageListRequest.h"
#import "EmptyManager.h"
#import "MyMessageModel.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "MessageViewController.h"
#import "MyMessageModel.h"
#import "getUnreadMessageCounts.h"
@interface NoticeListViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
//@property (nonatomic,strong)UIView *footView;
//@property (nonatomic,strong)UIImageView *headImage;
//@property (nonatomic,strong)UILabel *messageNameLabel;
//@property (nonatomic,strong)UILabel *messageContentLabel;
//@property (nonatomic,strong)UILabel *messageTimelabel;
//@property (nonatomic,strong)UILabel *badgeLabel;

@property (nonatomic,strong)getMessageListApi *Api;
@property (nonatomic,strong)getUnreadMessageCounts *countApi;
@property (nonatomic,strong)NSString *counts;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)MyMessageModel *model;
@end

@implementation NoticeListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getLastMessage];
    [self refreshMessageCount];
}

- (void)refreshMessageCount{
    
    myMessageHeader *head = [[myMessageHeader alloc]init];
    
    head.target = @"doctorMsgControl";
    
    head.method = @"queryDoctorMsgCounts";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    myMessageBody *body = [[myMessageBody alloc]init];
    
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.countApi getUnreadMessageCounts:request.mj_keyValues.mutableCopy];
}

- (void)getLastMessage{
    
  
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
    
    [self.Api getMessageList:request.mj_keyValues.mutableCopy];
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"%@",array);
    
    if (api == _Api) {
        if (array.count <= 0) {

        } else {
            [self.messageArray removeAllObjects];
            for (MyMessageModel *model in responsObject) {
                if ([model.status isEqualToString:@"0"]) {
                    [self.messageArray addObject:model];
                }
            }
            if (self.messageArray.count > 0) {
                self.model = [self.messageArray safeObjectAtIndex:0];
            }else{
                self.model = [array safeObjectAtIndex:0];
            }
        }
    }
    
    if (api == _countApi) {
          NSNumber *number =  responsObject[@"doctorMsgCounts"];
          self.counts = [number stringValue];
    }
    
    [self.tableview reloadData];

}



- (getMessageListApi *)Api{
    if (!_Api) {
        _Api = [[getMessageListApi alloc]init];
        _Api.delegate = self;
    }
    return _Api;
}

- (getUnreadMessageCounts *)countApi{
    if (!_countApi) {
        _countApi = [[getUnreadMessageCounts alloc]init];
        _countApi.delegate  =self;
    }
    return _countApi;
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
        _tableview.separatorColor = DefaultBackgroundColor;;
    }
    return _tableview;
}

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
//    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(15);
//        make.width.height.mas_equalTo(30);
//    }];
//    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(15);
//        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(-10.5);
//        make.bottom.mas_equalTo(self.headImage.mas_top).mas_equalTo(10.5);
//    }];
//    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headImage.mas_top);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(25);
//        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
//    }];
//
//    [self.messageTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headImage.mas_top);
//        make.right.mas_equalTo(-20);
//        make.height.mas_equalTo(25);
//        make.left.mas_equalTo(self.messageNameLabel.mas_right).mas_equalTo(15);
//    }];
//
//    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
//        make.right.mas_equalTo(-20);
//        make.top.mas_equalTo(self.messageNameLabel.mas_bottom).mas_equalTo(0);
//        make.height.mas_equalTo(30);
//    }];
   
}

//- (UIView *)footView{
//    if (!_footView) {
//        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
//        _footView.backgroundColor =[UIColor whiteColor];
//    }
//    return _footView;
//}
//
//- (UIImageView *)headImage{
//    if (!_headImage) {
//        _headImage = [[UIImageView alloc]init];
//        _headImage.image = [UIImage imageNamed:@"message_customer"];
//    }
//    return _headImage;
//}
//- (UILabel *)messageNameLabel{
//    if (!_messageNameLabel) {
//        _messageNameLabel = [[UILabel alloc]init];
//        _messageNameLabel.textAlignment = NSTextAlignmentLeft;
//        _messageNameLabel.textColor = DefaultBlackLightTextClor;
//        _messageNameLabel.font = Font(16);
//    }
//    return _messageNameLabel;
//}

//- (UILabel *)messageTimelabel{
//    if (!_messageTimelabel) {
//        _messageTimelabel = [[UILabel alloc]init];
//        _messageTimelabel.textAlignment = NSTextAlignmentRight;
//        _messageTimelabel.textColor = DefaultGrayLightTextClor;
//        _messageTimelabel.font = Font(14);
//    }
//    return _messageTimelabel;
//}
//
//- (UILabel *)messageContentLabel{
//    if (!_messageContentLabel) {
//        _messageContentLabel = [[UILabel alloc]init];
//        _messageContentLabel.textAlignment = NSTextAlignmentLeft;
//        _messageContentLabel.font = FontNameAndSize(15);
//        _messageContentLabel.textColor = DefaultGrayTextClor;
//    }
//    return _messageContentLabel;
//}

//- (UILabel *)badgeLabel{
//    if (!_badgeLabel) {
//        _badgeLabel = [[UILabel alloc]init];
//        _badgeLabel.textAlignment = NSTextAlignmentCenter;
//        _badgeLabel.font = FontNameAndSize(10);
//        _badgeLabel.layer.cornerRadius = 7.5;
//        _badgeLabel.layer.masksToBounds = YES;
//        _badgeLabel.textColor = [UIColor whiteColor];
//    }
//    return _badgeLabel;
//}

//- (void)SetFOotview{
//    self.tableview.tableFooterView = self.footView;
//    self.headImage.userInteractionEnabled = YES;
//    [self.footView addSubview:self.headImage];
//    self.messageNameLabel.userInteractionEnabled = YES;
//    [self.footView addSubview:self.messageNameLabel];
//    self.messageContentLabel.userInteractionEnabled = YES;
//    [self.footView addSubview:self.messageContentLabel];
//    [self.footView addSubview:self.badgeLabel];
//    [self.footView addSubview:self.messageTimelabel];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, kScreenWidth, 80);
//    [button addTarget:self action:@selector(tocustomer) forControlEvents:UIControlEventTouchUpInside];
//    [self.footView addSubview:button];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.tableview.backgroundColor = DefaultBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageCount:) name:@"messageCount" object:nil];
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:@"conversation"];
    [self.tableview registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:@"con"];
    [self.tableview registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MessageListTableViewCell class])];
}

- (void)refreshMessageCount:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"messageCount"]) {
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
        [self.Api getMessageList:request.mj_keyValues.mutableCopy];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
    if (indexPath.row == 0) {
        MessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageListTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.messageNameLabel.text = @"会诊消息";
        if (self.messageArray.count > 0) {
            cell.badgeLabel.text = [NSString stringWithFormat:@"%ld",self.messageArray.count];
            cell.badgeLabel.backgroundColor = DefaultRedTextClor;
        }
        [cell refreshWithmodel:self.model counts:self.counts];
        return cell;
    }else if(indexPath.row == 1){
      
        MessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"con"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithmessage];
        return cell;
    }else{
        MessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"conversation"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[@(ConversationType_PRIVATE),
                                               @(ConversationType_GROUP)]];
        [cell refreshWithModel:[NSString stringWithFormat:@"%d",unreadMsgCount]];
        return cell;
       
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        AppionmentNoticeViewController *notice = [AppionmentNoticeViewController new];
        notice.title = @"会诊通知";
        [self.navigationController pushViewController:notice animated:YES];
    }else if(indexPath.row == 1){
        UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
        [UdeskManager setupCustomerOnline];
        //设置头像
        [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
        [manager pushUdeskInViewController:self completion:nil];
        //点击留言回调
        [manager leaveMessageButtonAction:^(UIViewController *viewController){
            UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
            [viewController presentViewController:offLineTicket animated:YES completion:nil];
        }];
    }else{
        
        MessageViewController *list = [MessageViewController new];
        list.title = @"消息列表";
        [self.navigationController pushViewController:list animated:YES];
     
    }
}

@end
