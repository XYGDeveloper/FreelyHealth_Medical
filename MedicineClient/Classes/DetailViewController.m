//
//  DetailViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DetailViewController.h"
#import "TaskDetailApi.h"
#import "TaskDetailModel.h"
#import "MytaskDetailRequest.h"
#import "DetailDesTableViewCell.h"
#import "ImageTableViewCell.h"
#import "DetailInfoTableViewCell.h"
#import "RFRApi.h"
#import "RFRRequest.h"
#import "SpreadDropMenu.h"
#import "ApplyTaskViewController.h"
#import "GroupConViewController.h"
#import "IsHaveApi.h"
#import "IsHaveGroupRequest.h"
#import "IsHaveGroupModel.h"
#import "HuizhenConversationViewController.h"
#import "FindGroupApi.h"
#import "FindGroupInfoRequest.h"
#import "GroupInfoModel.h"
#import "YQWaveButton.h"
#import "ACMediaFrame.h"
#import "LYZAdView.h"
#import "AlertView.h"
#import "MyProfileViewController.h"
#import "GetAuthStateManager.h"
#import "BeginHuizhenViewController.h"
@interface DetailViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate,BaseMessageViewDelegate>
{
    BOOL _localImage;
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *originalImages;

@property (nonatomic,strong)YQWaveButton *reflectTask;

@property (nonatomic,strong)YQWaveButton *receivedTask;

@property (nonatomic,strong)YQWaveButton *finishTask;

@property (nonatomic,strong)YQWaveButton *sendGroup;

@property (nonatomic,strong)TaskDetailApi *detailapi;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)TaskDetailModel *model;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UILabel *CreatTime;

@property (nonatomic,strong)NSMutableArray *imageArr;

@property (nonatomic,strong)RFRApi *rfrApi;

@property (nonatomic,strong)RFRApi *ffrApi;

@property (nonatomic,strong)RFRApi *jfrApi;

@property (nonatomic,strong)IsHaveApi *isApi;

@property (nonatomic,strong)FindGroupApi *findApi;

@end


@implementation customFootDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.intro = [[UILabel alloc]init];
        self.intro.textColor = DefaultGrayTextClor;
        self.intro.text = @"图片资料";
        self.intro.textAlignment = NSTextAlignmentLeft;
        self.intro.font = FontNameAndSize(16);
        [self.contentView addSubview:self.intro];
        self.sep = [[UILabel alloc]init];
        self.sep.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.sep];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self layOut];
    }
    return self;
}

- (void)layOut{
    
    [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(25.5);
    }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end


@implementation DetailViewController


- (NSMutableArray *)imageArr
{

    if (!_imageArr) {
        
        _imageArr = [NSMutableArray array];
    }

    return _imageArr;
    
}


- (RFRApi *)rfrApi
{

    if (!_rfrApi) {
        
        _rfrApi = [[RFRApi alloc]init];
        
        _rfrApi.delegate  =self;
        
    }
    
    return _rfrApi;

}

- (RFRApi *)ffrApi
{
    
    if (!_ffrApi) {
        
        _ffrApi = [[RFRApi alloc]init];
        
        _ffrApi.delegate  =self;
        
    }
    
    return _ffrApi;
    
}

- (RFRApi *)jfrApi
{
    
    if (!_jfrApi) {
        
        _jfrApi = [[RFRApi alloc]init];
        
        _jfrApi.delegate  =self;
        
    }
    
    return _jfrApi;
    
}

- (IsHaveApi *)isApi
{
    if (!_isApi) {
        
        _isApi = [[IsHaveApi alloc]init];
        
        _isApi.delegate  =self;
        
    }
    
    return _isApi;
    
}

- (FindGroupApi *)findApi
{
    if (!_findApi) {
        
        _findApi = [[FindGroupApi alloc]init];
        
        _findApi.delegate = self;
        
    }
    
    return _findApi;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.detailTableView.mj_header endRefreshing];

    [Utils postMessage:command.response.msg onView:self.view];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.detailTableView.mj_header endRefreshing];
    
    if (api == _detailapi) {
        
        TaskDetailModel *model = [TaskDetailModel mj_objectWithKeyValues:responsObject];
        
        self.model = model;
        
        self.CreatTime.text = [NSString stringWithFormat:@"发布时间:%@",self.model.createtime];
        
        self.imageArr = [model.imagepath componentsSeparatedByString:@","].mutableCopy;
        
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        mediaView.preShowMedias = self.imageArr;
        mediaView.showDelete = NO;
        mediaView.naviBarBgColor = AppStyleColor;
        mediaView.showAddButton = NO;
        mediaView.rowImageCount = 3;
        mediaView.lineSpacing = 10;
        mediaView.interitemSpacing = 10;
        mediaView.maxImageSelected = 9;
        mediaView.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8);
        [mediaView observeViewHeight:^(CGFloat mediaHeight) {
            self.detailTableView.tableFooterView = mediaView;
        }];
        [mediaView reload];
        
        [self.detailTableView reloadData];
        
    }
    
    if (api == _rfrApi) {
        
        [Utils postMessage:@"接受任务成功" onView:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_receTask object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }
 
    if (api == _ffrApi) {
        
        [Utils postMessage:@"确认任务完成成功" onView:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_finishtask object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];

        });

    }
    
    if (api == _jfrApi) {
        
        [Utils postMessage:@"拒绝接受任务成功" onView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_rejecttask object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }
    
    if (api == _isApi) {
        
        IsHaveGroupModel *model = responsObject;
        
        if ([model.mdtgroupid isEqualToString:@""]) {
            
            GroupConViewController *group = [[GroupConViewController alloc]initWithType:GroupConsultTypeInvite withPName:self.model.patientname des:self.model.des imageArray:self.imageArr taskNo:self.taskno];
            group.title = @"发起会诊";
            [self.navigationController pushViewController:group animated:YES];
            
        }else{
            
            FindGroupInfoHeader *head = [[FindGroupInfoHeader alloc]init];
            //
            head.target = @"huizhenControl";
            
            head.method = @"findGroup";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
            head.token = [User LocalUser].token;
            
            FindGroupInfoBody *body = [[FindGroupInfoBody alloc]init];
            
            body.id = model.mdtgroupid;
            
            FindGroupInfoRequest *request = [[FindGroupInfoRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            NSLog(@"%@",request);
            
            [self.findApi getGroupInfo:request.mj_keyValues.mutableCopy];
            
        }
       
    }
    
    
    if (api == _findApi) {
        
        GroupInfoModel *model = responsObject;
        
        HuizhenConversationViewController*conversation = [[HuizhenConversationViewController alloc]init];
        conversation.isGroupCon = YES;
        conversation.mdtgroupname = model.groupname;
        conversation.conversationType = ConversationType_GROUP;
        conversation.targetId = model.groupid;
        conversation.displayUserNameInCell = YES;
        conversation.enableNewComingMessageIcon = YES; //开启消息提醒
        conversation.enableUnreadMessageIcon = YES;
        [User LocalUser].mdtgroupid = model.groupid;
        [User LocalUser].mdtgroupname = model.groupname;
        [User LocalUser].mdtgroupfacepath = model.groupfacepath;
        [User saveToDisk];
        [self.navigationController pushViewController:conversation animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        DetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailInfoTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell refreshWithModel:self.model];
     
        return cell;
        
    }else if(indexPath.section == 1){
    
        DetailDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailDesTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell refreshWithModel:self.model];
       
        return cell;
    
    }else{
        customFootDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([customFootDetailCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets UIEgde = UIEdgeInsetsMake(0,0, 0, kScreenWidth);
    [cell setSeparatorInset:UIEgde];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 1;
    }else{
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        return 46;
    }else if (indexPath.section == 1){
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([DetailDesTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(DetailDesTableViewCell *cell) {
                [cell refreshWithModel:self.model];
        }];
    
    }else{
        return 40;
    }


}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 2){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else if(section == 1){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
    }else{
        if (section == 2){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else if(section == 1){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 2){
            return 10;
        }else if(section == 1){
            return 10;
        }else{
            return 0.00001;
        }
    }else{
        if (section == 2){
            return 10;
        }else if(section == 1){
            return 10;
        }else{
            return 0.00001;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.000001;
    }else{
        return 0.000001;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (indexPath.section == 2) {
//        
//        ImageTableViewCell *cell = (ImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        
//        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.imageArr placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"] atIndex:indexPath.row dismiss:nil];
//    }
//   
//}


- (TaskDetailApi *)detailapi
{

    if (!_detailapi) {
        
        _detailapi = [[TaskDetailApi alloc]init];
        
        _detailapi.delegate = self;
        
    }

    return _detailapi;

}


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if ([self.tasktype isEqualToString:OrderReqStatusWaitRece]) {
        
        [self setUI];
        
    }else if([self.tasktype isEqualToString:OrderReqStatusReceived]){
        
        [self setUI1];
        
    }else{
        
        
    }
    

}

- (YQWaveButton *)reflectTask
{
    if (!_reflectTask) {
        
        _reflectTask = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_reflectTask setTitle:@"拒绝任务" forState:UIControlStateNormal];
        
        _reflectTask.backgroundColor = [UIColor whiteColor];
        
        [_reflectTask setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _reflectTask.titleLabel.font = FontNameAndSize(16);
    }
    
    return _reflectTask;
}

- (YQWaveButton *)receivedTask
{
    
    if (!_receivedTask) {
        
        _receivedTask = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_receivedTask setTitle:@"接受任务" forState:UIControlStateNormal];
        
        _receivedTask.backgroundColor = AppStyleColor;
        
        [_receivedTask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receivedTask.titleLabel.font = FontNameAndSize(16);

    }
    
    return _receivedTask;
}

- (YQWaveButton *)finishTask
{
    
    if (!_finishTask) {
        
        _finishTask = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_finishTask setTitle:@"完成任务" forState:UIControlStateNormal];
        
        _finishTask.backgroundColor = AppStyleColor;
        
        [_finishTask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishTask.titleLabel.font = FontNameAndSize(16);
    }
    
    return _finishTask;
}


- (YQWaveButton *)sendGroup
{
    
    if (!_sendGroup) {
        
        _sendGroup = [YQWaveButton buttonWithType:UIButtonTypeCustom];
        
        [_sendGroup setTitle:@"发起会诊" forState:UIControlStateNormal];
        
        _sendGroup.backgroundColor = [UIColor whiteColor];
        
        [_sendGroup setTitleColor: AppStyleColor forState:UIControlStateNormal];
        _sendGroup.titleLabel.font = FontNameAndSize(16);
    }
    
    return _sendGroup;
}


- (void)setUI{

    [self.view addSubview:self.reflectTask];
    
    [self setRightNavigationItemWithTitle:@"申请转诊" action:@selector(applyTrement)];

    [self.reflectTask addTarget:self action:@selector(reflecTaskAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.receivedTask];
    
     [self.receivedTask addTarget:self action:@selector(receiveTaskAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reflectTask mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(kScreenWidth/2);
        
        make.height.mas_equalTo(48);
    }];
    
    [self.receivedTask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reflectTask.mas_right);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(48);
    }];
    
}


//拒绝任务

- (void)reflecTaskAction{
  
            RFRHeader *header = [[RFRHeader alloc]init];
            
            header.target = @"taskControl";
            
            header.method = @"taskOperation";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            RFRBody *bodyer = [[RFRBody alloc]init];
            
            bodyer.id = self.model.id;
            
            bodyer.type = @"2";
            
            RFRRequest *requester = [[RFRRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.jfrApi getRFR:requester.mj_keyValues.mutableCopy];
    
}

//接受任务

- (void)receiveTaskAction{

            RFRHeader *header = [[RFRHeader alloc]init];
            
            header.target = @"taskControl";
            
            header.method = @"taskOperation";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            RFRBody *bodyer = [[RFRBody alloc]init];
            
            bodyer.id = self.model.id;
            
            bodyer.type = @"1";
            
            RFRRequest *requester = [[RFRRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.rfrApi getRFR:requester.mj_keyValues.mutableCopy];
    
}


//完成任务
- (void)finishTaskAction{

            RFRHeader *header = [[RFRHeader alloc]init];
            header.target = @"taskControl";
            header.method = @"taskOperation";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            RFRBody *bodyer = [[RFRBody alloc]init];
            bodyer.id = self.model.id;
            bodyer.type = @"3";
            RFRRequest *requester = [[RFRRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            NSLog(@"%@",requester);
            [self.ffrApi getRFR:requester.mj_keyValues.mutableCopy];
    
}

//发起会诊

- (void)SendGroupAction{
    
//            isHaveHeader *header = [[isHaveHeader alloc]init];
//            header.target = @"huizhenControl";
//            header.method = @"huizhenFind";
//            header.versioncode = Versioncode;
//            header.devicenum = Devicenum;
//            header.fromtype = Fromtype;
//            header.token = [User LocalUser].token;
//            isHaveBody *bodyer = [[isHaveBody alloc]init];
//            bodyer.taskno = self.taskno;
//            IsHaveGroupRequest *requester = [[IsHaveGroupRequest alloc]init];
//            requester.head = header;
//            requester.body = bodyer;
//            NSLog(@"%@",requester);
//            [self.isApi IsInvite:requester.mj_keyValues.mutableCopy];
    
    BeginHuizhenViewController *huizhen = [BeginHuizhenViewController new];
    huizhen.title = @"发起会诊";
    [self.navigationController pushViewController:huizhen animated:YES];
}

- (void)setUI1{
    
    [self.view addSubview:self.sendGroup];
    
    [self.sendGroup addTarget:self action:@selector(SendGroupAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sendGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(48);
        
        make.width.mas_equalTo(kScreenWidth/2);
        
    }];
    
    [self.view addSubview:self.finishTask];
    
    [self.finishTask addTarget:self action:@selector(finishTaskAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightNavigationItemWithTitle:@"申请转诊" action:@selector(applyTrement)];

    [self.finishTask mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.sendGroup.mas_right).mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.right.mas_equalTo(0);
        
        make.height.mas_equalTo(self.sendGroup.mas_height);
        
        make.width.mas_equalTo(self.sendGroup.mas_width);
      
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    // Do any additional setup after loading the view, typically from a nib.
    [self.detailTableView registerClass:[customFootDetailCell class] forCellReuseIdentifier:NSStringFromClass([customFootDetailCell class])];
    [self.detailTableView registerClass:[DetailDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DetailDesTableViewCell class])];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"DetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DetailInfoTableViewCell class])];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 86)];
    UILabel *label = [[UILabel alloc]init];
    [self.headView addSubview:label];
    label.text = @"转诊任务";
    label.textColor = DefaultBlackLightTextClor;
    
    label.font = Font(16);
    
    label.textAlignment = NSTextAlignmentCenter;
    
    self.CreatTime = [[UILabel alloc]init];
    
    [self.headView addSubview:self.CreatTime];
    
    self.CreatTime.text = @"转诊任务";
    
    self.CreatTime.textColor = DefaultGrayLightTextClor;
    
    self.CreatTime.font = FontNameAndSize(14);
    
    self.CreatTime.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.height.mas_equalTo(20);
    }];
    
    [self.CreatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(label.mas_bottom);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.centerX.mas_equalTo(self.headView.mas_centerX);

        make.height.mas_equalTo(30);
        
    }];
    
    UIView *line = [[UIView alloc]init];
    
    line.backgroundColor = DefaultBackgroundColor;
    
    [self.headView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(14);
    }];
    
    self.detailTableView.tableHeaderView = self.headView;
    
//    self.detailTableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
    
        MyTaskDetailHeader *header = [[MyTaskDetailHeader alloc]init];
        
        header.target = @"taskControl";
        
        header.method = @"taskDetail";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        MyTaskDetailBody *bodyer = [[MyTaskDetailBody alloc]init];
        
        bodyer.id = self.id;
        
        MytaskDetailRequest *requester = [[MytaskDetailRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.detailapi getMytaskDetail:requester.mj_keyValues.mutableCopy];
        
}

- (void)applyTrement{
    
    if ([Utils showLoginPageIfNeeded]) {} else {
                ApplyTaskViewController *apply = [ApplyTaskViewController new];
                apply.nameString = self.model.patientname;
                apply.sexal = self.model.patientsex;
                apply.ageString = self.model.patientage;
                apply.phoneString = self.model.patientphone;
                apply.des = self.model.des;
                apply.taskid = self.model.id;
                apply.imageArr = [self.model.imagepath componentsSeparatedByString:@","];
                apply.title = @"申请转诊";
                [self.navigationController pushViewController:apply animated:YES];
    }
    
}

@end
