//
//  ShowViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ShowViewController.h"
#import "CollectionViewCell.h"
#import "MyfootView.h"
#import "AddGroupViewController.h"
#import "MulViewController.h"
#import "SendInviteApi.h"
#import "SendInviteRequest.h"
#import "GroupConSearchModel.h"
#import "MBProgressHUD+BWMExtension.h"
@interface ShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>

@property (nonatomic,strong)NSMutableArray *list;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UIButton *senderButton;

@property (nonatomic,strong)SendInviteApi *api;

@property (nonatomic,strong)SendInviteApi *api1;

@property (nonatomic,strong)MBProgressHUD *hub;

@end

@implementation ShowViewController

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (SendInviteApi *)api
{
    if (!_api) {
        
        _api = [[SendInviteApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (SendInviteApi *)api1
{
    if (!_api1) {
        
        _api1 = [[SendInviteApi alloc]init];
        
        _api1.delegate = self;
        
    }
    
    return _api1;
    
}

- (UIButton *)senderButton
{
    
    if (!_senderButton) {
        
        _senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _senderButton.backgroundColor = AppStyleColor;
        
        [_senderButton setTitle:@"发送会诊邀请" forState:UIControlStateNormal];
        
        [_senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _senderButton.titleLabel.font = FontNameAndSize(18);
        
    }
    return _senderButton;
    
    
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) collectionViewLayout:flowLayout];
        [flowLayout setFooterReferenceSize:CGSizeMake(kScreenWidth,75)];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = DefaultBackgroundColor;
        
    }
    return _collectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = _chooseArr;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    [self.collectionView registerClass:[MyfootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyfootView"];

    [self.collectionView reloadData];
    
    [self.view addSubview:self.senderButton];
    
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    [self.senderButton addTarget:self action:@selector(sendGroupInvite) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}



- (void)sendGroupInvite{
    
    //发送会诊邀请
    
    self.hub = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在发起..."];

    sendHeader *head = [[sendHeader alloc]init];
    //
    head.target = @"huizhenControl";
    
    head.method = @"huizhenYaoqing";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    sendBody *body = [[sendBody alloc]init];
    
    body.id = self.groupID;    //会诊记录id
    
    SendInviteRequest *request = [[SendInviteRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api1 sendInvite:request.mj_keyValues.mutableCopy];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    if (api == _api1) {
        
        [self.hub bwm_hideWithTitle:@"发起成功"
                                  hideAfter:kBWMMBProgressHUDHideTimeInterval
                                    msgType:BWMMBProgressHUDMsgTypeSuccessful];
        
        double delayInSeconds = 2.0;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            
            [Utils jumpToTabbarControllerAtIndex:2];
            
        });
        
    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
    [self.hub bwm_hideWithTitle:@"发起失败"
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeError];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.list.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    
    GroupConSearchModel *model = [self.list objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    return cell;
    
}


//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 75);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionFooter){
        
        MyfootView *footerV = (MyfootView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyfootView" forIndexPath:indexPath];
        
        if (self.list.count <= 0) {
            
            footerV.delEve.hidden = YES;
            
        }else{
            
            footerV.delEve.hidden = NO;

        }
        
        footerV.add = ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        };
        
        footerV.mul = ^{
            
            MulViewController *mul = [[MulViewController alloc]init];
            
            mul.groupID = self.groupID;
            
            mul.list = self.list;
            
            mul.title = @"选择要删除的医生";
            
            mul.endArr = ^(NSMutableArray *endArr) {
                
                [self.list removeAllObjects];
                
                self.list = endArr;
                
                [self.collectionView reloadData];
                
            };

            [self.navigationController pushViewController:mul animated:YES];
            
        };
        
        reusableView = footerV;
    }
    return reusableView;
}

@end
