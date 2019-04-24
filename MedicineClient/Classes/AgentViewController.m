//
//  AgentViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AgentViewController.h"
#import "WailtFinishViewController.h"
#import "FinishTaskViewController.h"
#import <Masonry.h>
#import "LoginOutApi.h"
#import "LoginOutRequest.h"
@interface AgentViewController ()<ApiRequestDelegate>

@property (nonatomic,strong)UISegmentedControl *segment;

@property (nonatomic,strong)WailtFinishViewController *operationVC;

@property (nonatomic,strong)FinishTaskViewController *summaryVC;

@property (nonatomic,strong)UIViewController *currentVC;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)LoginOutApi *api;

@property (nonatomic,strong)MBProgressHUD *hud;



@end

@implementation AgentViewController


- (LoginOutApi *)api
{

    if (!_api) {
        
        _api = [[LoginOutApi alloc]init];
        
        _api.delegate  =self;
        
    }
    
    return _api;

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [self.hud hide:YES];


}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    if (api == _api) {
        
        [User clearLocalUser];
        
        [self.hud hide:YES];

        [Utils postMessage:@"登出成功" onView:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务记录";
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@""] highligthtedImage:[UIImage imageNamed:@""] action:nil];

    [self setRightNavigationItemWithTitle:@"注销登录" action:@selector(loginOut)];
    
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;

    self.headView = [[UIView alloc]init];
    
    [self.view addSubview:self.headView];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(65);
    }];
    
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"待完成任务",@"已完成任务"]];
    
    self.segment.selectedSegmentIndex = 0;
    
    self.segment.tintColor = AppStyleColor;
    
    [self.headView addSubview:self.segment];
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 60);
        make.height.mas_equalTo(35);
        make.centerY.mas_equalTo(self.headView.mas_centerY);
        
    }];
    
    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    self.operationVC = [[WailtFinishViewController alloc] init];
    self.operationVC.view.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight - 65);
    [self addChildViewController:_operationVC];
    
    self.summaryVC = [[FinishTaskViewController alloc] init];
    self.summaryVC.view.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight - 65);
    [self addChildViewController:_summaryVC];
    //设置默认控制器为fristVc
    self.currentVC = self.operationVC;
    [self.view addSubview:self.operationVC.view];
    
    // Do any additional setup after loading the view.
}


- (void)loginOut{


    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LoginOutHeader *header = [[LoginOutHeader alloc]init];
    
    header.target = @"loginDControl";
    
    header.method = @"logoutD";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    LoginOutBody *bodyer = [[LoginOutBody alloc]init];
    
    LoginOutRequest *requester = [[LoginOutRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self.api LoginOut:requester.mj_keyValues.mutableCopy];

    
}


-(void)segmentChange:(UISegmentedControl *)sgc{
    //NSLog(@"%ld", sgc.selectedSegmentIndex);
    switch (sgc.selectedSegmentIndex) {
        case 0:
            [self replaceFromOldViewController:self.summaryVC toNewViewController:self.operationVC];
            break;
        case 1:
            [self replaceFromOldViewController:self.operationVC toNewViewController:self.summaryVC];
            break;
        default:
            break;
    }
    
}


#pragma mark -SMCustomSegmentDelegate


- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
