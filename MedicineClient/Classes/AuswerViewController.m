//
//  AuswerViewController.m
//  MedicineClient
//
//  Created by L on 2017/8/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuswerViewController.h"
#import "AuwerApi.h"
#import "AuswerQuestionRequest.h"
#import "FrumDetailModel.h"
#import "FrumTableViewCell.h"
#import "AuswerTableViewCell.h"
#import "SZTextView.h"
#import <TPKeyboardAvoidingTableView.h>
#import <UIScrollView+TPKeyboardAvoidingAdditions.h>
#import "FillQuestionTableViewCell.h"
@interface AuswerViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)TPKeyboardAvoidingTableView *frumTableView;

@property (nonatomic,strong)NSMutableArray *ListArr;

@property (nonatomic,strong)AuwerApi *api;

@property (nonatomic,strong)UIButton *AuswerButton;

@property (nonatomic,strong)FillQuestionTableViewCell *cell;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation AuswerViewController




- (AuwerApi *)api
{
    
    if (!_api) {
        
        _api = [[AuwerApi alloc]init];
        
        _api.delegate  = self;
        
    }
    
    return _api;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"回答问题";
    
    self.view.backgroundColor  = DefaultBackgroundColor;
    
    [self.view addSubview:self.frumTableView];
    
    [self.frumTableView registerClass:[AuswerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AuswerTableViewCell class])];
   
    [self.frumTableView registerClass:[FillQuestionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FillQuestionTableViewCell class])];

    self.AuswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.AuswerButton.backgroundColor = AppStyleColor;
    
    [self.AuswerButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.AuswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.AuswerButton];
    
    [self.AuswerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(49);
        
    }];
    
    [self.AuswerButton addTarget:self action:@selector(auswerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.frumTableView reloadData];

    // Do any additional setup after loading the view.
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.hud hide:YES];

    [Utils postMessage:command.response.msg onView:self.view];
    
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _api) {
        
        [self.hud hide:YES];

        [Utils postMessage:@"提交成功" onView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


- (TPKeyboardAvoidingTableView *)frumTableView
{
    
    if (!_frumTableView) {
        
        _frumTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _frumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _frumTableView.backgroundColor = DefaultBackgroundColor;
        _frumTableView.delegate  =self;
        
        _frumTableView.dataSource = self;
        
    }
    
    return _frumTableView;
    
}

- (NSMutableArray *)ListArr{
    
    if (!_ListArr) {
        
        _ListArr = [NSMutableArray array];
    }
    
    return _ListArr;
    
    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        AuswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuswerTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell cellDataWithModel:self.model];
        
        return cell;
        
        
    }else{
    
        FillQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FillQuestionTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cell = cell;
        
        
        return cell;
    
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AuswerTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(AuswerTableViewCell *cell) {
            
            [cell cellDataWithModel:self.model];
            
        }];
    }else{
    
        return 200;
    
    }
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
        return CGFLOAT_MIN;
    return 14;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.000001;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}


- (void)auswerAction{
    
    
    if (self.cell.textView.text.length <= 0) {
        
        [Utils postMessage:@"填写点东西，拜托" onView:self.view];
        
        return;
        
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    //请求签名
    AuswerHeader *header = [[AuswerHeader alloc]init];
    
    header.target = @"forumDControl";
    
    header.method = @"answerQuestion";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    AuswerBody *bodyer = [[AuswerBody alloc]init];
    
    bodyer.id = self.model.id;
    
    bodyer.answer = self.cell.textView.text;
    
    AuswerQuestionRequest *requester = [[AuswerQuestionRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self.api ALuntan:requester.mj_keyValues.mutableCopy];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
    
}


@end
