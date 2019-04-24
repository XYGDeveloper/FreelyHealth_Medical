//
//  AgentDetailViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentDetailViewController.h"
#import "FirstWaves.h"
#import "SecondWaves.h"
#import "AgentDetailModel.h"
#import "AgentDetailApi.h"
#import "AgentDetailRequest.h"
#import "AgentDetailTableViewCell.h"
#import "AgentStepApi.h"
#import "AgentRequest.h"
@interface AgentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)FirstWaves *firstWare;

@property (nonatomic,strong)SecondWaves *secondWare;

@property (nonatomic,strong)UITableView *weightTableview;

@property (nonatomic,strong)NSMutableArray *weightArray;

@property (nonatomic,strong)UIButton *updateDate;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UILabel *OrderType;

@property (nonatomic,strong)UILabel *priceString;

@property (nonatomic,strong)UILabel *userInfo;

@property (nonatomic,strong)UILabel *orderState;

@property (nonatomic,strong)AgentDetailApi *api;

@property (nonatomic,strong)AgentStepApi *Stepapi;


@property (nonatomic,strong)AgentDetailModel *model;

@property (nonatomic,strong)NSArray *listArr;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation AgentDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AgentDetailHeader *head = [[AgentDetailHeader alloc]init];
    
    head.target = @"operatorControl";
    
    head.method = @"operatorDetail";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    AgentDetailBody *body = [[AgentDetailBody alloc]init];
    
    body.id = self.orderid;
    
    AgentDetailRequest *request = [[AgentDetailRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api getagentDetail:request.mj_keyValues.mutableCopy];
    
}

- (AgentDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[AgentDetailApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}


- (AgentStepApi *)Stepapi
{
    
    if (!_Stepapi) {
        
        _Stepapi = [[AgentStepApi alloc]init];
        
        _Stepapi.delegate = self;
        
    }
    
    return _Stepapi;
    
}




- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.hud hide:YES];

    [Utils postMessage:command.response.msg onView:self.view];
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.hud hide:YES];

    
    if (api == _api) {
        
        self.model = responsObject;
        
        self.OrderType.text = self.model.goodname;
        
        self.priceString.text = [NSString stringWithFormat:@"服务对象：%@(%@)",self.model.patientname,self.model.patientphone];
        //
        self.userInfo.text = [NSString stringWithFormat:@"服务地点:%@",self.model.hname];
        //
        self.orderState.text = [NSString stringWithFormat:@"服务说明：%@",self.model.remark];
        
        self.listArr = [itemModel mj_objectArrayWithKeyValuesArray:self.model.items];

        
    }
    
//

    NSLog(@"--------%@",self.model);
    
    
    NSLog(@"-------%@",self.listArr);
    
    if (api == _Stepapi) {
        
        AgentDetailHeader *head = [[AgentDetailHeader alloc]init];
        
        head.target = @"operatorControl";
        
        head.method = @"operatorDetail";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        AgentDetailBody *body = [[AgentDetailBody alloc]init];
        
        body.id = self.orderid;
        
        AgentDetailRequest *request = [[AgentDetailRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api getagentDetail:request.mj_keyValues.mutableCopy];

    }
    
    [self.tableview reloadData];
    
}


- (void)setHeadView{
    
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    //第一个波浪
    self.firstWare = [[FirstWaves alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    
    self.firstWare.alpha= 0.6;
    
    //第二个波浪
    self.secondWare = [[SecondWaves alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 240)];
    
    self.secondWare.alpha=0.9;
    
    [self.headView addSubview:self.firstWare];
    
    [self.headView addSubview:self.secondWare];
    
    //
    self.OrderType = [[UILabel alloc]init];
    
    self.OrderType.font = Font(18);
    
    self.OrderType.textColor = [UIColor whiteColor];
    
    self.OrderType.textAlignment = NSTextAlignmentLeft;
    
    
    [self.secondWare addSubview:self.OrderType];
    
    self.priceString = [[UILabel alloc]init];
    
    self.priceString.font = Font(14);
    
    self.priceString.textColor = [UIColor whiteColor];
    
    self.priceString.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.priceString];
    
    self.userInfo = [[UILabel alloc]init];
    
    self.userInfo.font = Font(14);

    self.userInfo.textColor = [UIColor whiteColor];
    
    self.userInfo.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.userInfo];
    
    self.orderState = [[UILabel alloc]init];
    
    self.orderState.font = Font(14);
    
    self.orderState.textColor = [UIColor whiteColor];
    
    self.orderState.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.orderState];
    
    UILabel *historyLabel= [[UILabel alloc]init];
    
    historyLabel.font = Font(16);
    historyLabel.textAlignment = NSTextAlignmentCenter;
    historyLabel.text  =@"服务流程";
    historyLabel.textColor = DefaultGrayLightTextClor;
    
    [self.headView addSubview:historyLabel];
    
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-5);
    }];
    
    
}


- (void)layOutSubView{
    
    
    [self.OrderType mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        
        make.left.mas_equalTo(16);
        
        make.width.mas_equalTo(kScreenWidth/2);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.priceString mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.OrderType.mas_bottom);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.priceString.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(self.OrderType.mas_left);
        
        make.width.mas_equalTo(kScreenWidth- 26);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.orderState mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.userInfo.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(16);
        
        make.width.mas_equalTo(kScreenWidth);
        
        make.height.mas_equalTo(25);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"服务记录";
    
//    [self.view addSubview:self.updateDate];
//    
    [self setHeadView];
//
    self.tableview.tableHeaderView  = self.headView;

    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self layOutSubView];

    [self.tableview registerNib:[UINib nibWithNibName:@"AgentDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AgentDetailTableViewCell class])];
    
    // Do any additional setup after loading the view from its nib.
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
        
    }else{
        
        return 0;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 50;
    }else{
    
        return 100;

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AgentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AgentDetailTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    itemModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    cell.action = ^{
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        agentStepHeader *head = [[agentStepHeader alloc]init];
        
        head.target = @"operatorControl";
        
        head.method = @"operatorDetailChange";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        agentStepBody *body = [[agentStepBody alloc]init];
        
        body.id = self.model.id;
        
        body.no = model.no;
        
        AgentRequest *request = [[AgentRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.Stepapi getStep:request.mj_keyValues.mutableCopy];
        
    };
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    


}



@end
