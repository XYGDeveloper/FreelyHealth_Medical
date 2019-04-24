//
//  ReferDetailViewController.m
//  MedicineClient
//
//  Created by L on 2017/10/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReferDetailViewController.h"
#import "ReferDetailRequest.h"
#import "ReferDetailModel.h"
#import "ReferDetailApi.h"
#import "TargetTableViewCell.h"
#import "TargetTTableViewCell.h"
#import "Ty2TableViewCell.h"
#import "ReferDesTableViewCell.h"
#import "ImageTableViewCell.h"
#import "HUPhotoBrowser.h"
#import "DisInfoTableViewCell.h"
#import "RefererImageTableViewCell.h"
#import "ACMediaFrame.h"

@interface ReferDetailViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)ReferDetailApi *api;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *CreatTime;
@property (nonatomic,strong)ReferDetailModel *model;
@property (nonatomic,strong)NSMutableArray *imageArr;
@end

@implementation ReferDetailViewController

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (UITableView *)tableview
{
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate  =self;
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.dataSource = self;
        }
    return _tableview;
}



- (ReferDetailApi *)api
{
    if (!_api) {
        _api = [[ReferDetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    self.model = responsObject;
    
//    1已转诊 2已被接受 3已完成 4 已被拒绝
    
    if ([self.status isEqualToString:@"1"]) {
        
        self.label.text = @"已转诊";
        
    }else if ([self.status isEqualToString:@"2"])
    {
    
        self.label.text = @"已被接受";

    }else if ([self.status isEqualToString:@"3"])
    {
        self.label.text = @"已完成";

    }else{
        self.label.text = @"已被拒绝";
    }
    
    self.CreatTime.text = self.model.createtime;
    
    NSArray *arr = [self.model.imagepath componentsSeparatedByString:@","].mutableCopy;
    
    for (NSString *element in arr) {
        
        if (element.length > 0) {
            [self.imageArr addObject:element];
        }
    }
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    mediaView.preShowMedias = self.imageArr;
    mediaView.showDelete = NO;
    mediaView.naviBarBgColor = AppStyleColor;
    mediaView.showAddButton = NO;
    mediaView.rowImageCount = 3;
    mediaView.lineSpacing = 10;
    mediaView.interitemSpacing = 10;
    mediaView.maxImageSelected = 12;
    mediaView.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8);
    [mediaView reload];
    self.tableview.tableFooterView = mediaView;
    [self.tableview reloadData];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)layOutSubView{

    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerClass:[ReferDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ReferDesTableViewCell class])];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 86)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc]init];
    
    [self.headView addSubview:self.label];
    
    self.label.textColor = DefaultBlackLightTextClor;
    
    self.label.font = FontNameAndSize(17);
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    self.CreatTime = [[UILabel alloc]init];
    
    [self.headView addSubview:self.CreatTime];
    
    self.CreatTime.text = @"转诊任务";
    
    self.CreatTime.textColor = DefaultGrayLightTextClor;
    
    self.CreatTime.font = FontNameAndSize(16);
    
    self.CreatTime.textAlignment = NSTextAlignmentCenter;
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.height.mas_equalTo(20);
    }];
    
    [self.CreatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.label.mas_bottom);
        
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
    
    
    self.tableview.tableHeaderView = self.headView;
    
    referDetailHeader *header = [[referDetailHeader alloc]init];
    
    header.target = @"taskControl";
    
    header.method = @"taskOutDetail";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    referDetailBody *bodyer = [[referDetailBody alloc]init];
    
    bodyer.taskno = self.taskno;
    
    bodyer.status = self.status;

    ReferDetailRequest *requester = [[ReferDetailRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self.api referDetail:requester.mj_keyValues.mutableCopy];

    [self.view addSubview:self.tableview];
    
    [self layOutSubView];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"TargetTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TargetTableViewCell class])];

    [self.tableview registerNib:[UINib nibWithNibName:@"TargetTTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TargetTTableViewCell class])];

    [self.tableview registerNib:[UINib nibWithNibName:@"Ty2TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([Ty2TableViewCell class])];

    [self.tableview registerClass:[RefererImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RefererImageTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"DisInfoTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DisInfoTableViewCell class])];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 3) {
        return 1;
    }else{
        return 1;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        if ([self.model.status isEqualToString:@"1"]) {
            return 50;
        }else{
            return 100;
        }
        
    }else if(indexPath.section == 1){
    
        if (self.model.refusetime && [self.model.status isEqualToString:@"3"]) {
            return 130;
        }else{
            return 50;
        }

    }else if(indexPath.section == 2){
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ReferDesTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(ReferDesTableViewCell *cell) {
            [cell refreshWithreferModel:self.model];
        }];
        
    }else{
        return 52;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        if ([self.model.status isEqualToString:@"1"]) {
            
            TargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TargetTableViewCell class])];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell refreshWithModel:self.model];
            
            return cell;
            
        }else{
        
            TargetTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TargetTTableViewCell class])];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell refreshWithModel:self.model];
            
            return cell;
            
        }
        
    }else if(indexPath.section == 1){
    
        if (self.model.refusetime && [self.model.status isEqualToString:@"3"]) {
            
            Ty2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Ty2TableViewCell class])];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell refreshWithModel:self.model];
            
            return cell;
            
            
        }else{
            
            DisInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DisInfoTableViewCell class])];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell refreshWithModel1:self.model];
            return cell;
        }
      
    }else if(indexPath.section == 2){
    
        ReferDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReferDesTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshWithreferModel:self.model];
        
        return cell;
        
    }else{
        RefererImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RefererImageTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell refreshWithModel:[self.imageArr objectAtIndex:indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (indexPath.section == 3) {
//
//        ImageTableViewCell *cell = (ImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//
//        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.imageArr placeholderImage:[UIImage imageNamed:@"thumbs.dreamstime.com.jpg"] atIndex:indexPath.row dismiss:nil];
//    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (@available(iOS 11.0, *)) {
        if (section == 3) {

            return nil;
        }else{
            
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            
        }
    }else{
        
        if (section == 3) {
            return nil;
        }else{
            
            return nil;
        }
        
    }
    
   
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 5;
        }
        
        if (section == 3){
            return 0.00000001;
        }
        return 0.00000001;
    
    }else{
       
        if (section == 0) {
            return 5;
        }
        
        if (section == 3){
            return 0.00000001;
        }
        
        return (!section) ? 0.0001f : 1;
    }
 
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
    }else{
        
        return nil;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (@available(iOS 11.0, *)) {
        
        if(section == 0){
            return 0.5f;
        }else{
            return 0.5;
        }
        
    }else{
        
        if(section == 0){
            return 0.5f;
        }else{
            return 0.5;
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
