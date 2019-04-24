//
//  ReferralViewController.m
//  MedicineClient
//
//  Created by L on 2017/10/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ReferralViewController.h"
#import "SegmentContainer.h"
#import "ReferListViewController.h"
static NSString const * statusKey = @"status";
static NSString const * statusNameKey = @"name";

@interface ReferralViewController ()

<SegmentContainerDelegate>

@property (nonatomic, strong) SegmentContainer *container;

@property (nonatomic, strong) NSArray *orderStatusArray;

@end

@implementation ReferralViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"我的转诊";
    
    [self configOrderStatus];
    
    [self.view addSubview:self.container];
    [self selectOrderStatus];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Helper
- (void)configOrderStatus {
    self.orderStatusArray = @[@{statusKey:referReqStatusreferedRece, statusNameKey:@"已转诊"},
                              @{statusKey:referReqStatusWaitRece, statusNameKey:@"已被接受"},
                              @{statusKey:referReqStatusFinished, statusNameKey:@"已完成"},
                              @{statusKey:referReqStatusReceived, statusNameKey:@"已被拒绝"},
                              ];
}

- (void)selectOrderStatus {
    if (!self.orderStatus || self.orderStatus.length <= 0) {
        self.orderStatus = OrderReqStatusWaitRece;
    }
    
    for (NSDictionary *dic in self.orderStatusArray) {
        NSString *status = [dic objectForKey:statusKey];
        if ([status isEqualToString:self.orderStatus]) {
            NSUInteger index = [self.orderStatusArray indexOfObject:dic];
            [self.container setSelectedIndex:index withAnimated:YES];
        }
    }
}


#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight+10)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.titleFont = FontNameAndSize(17);
        _container.titleNormalColor = DefaultGrayLightTextClor;
        _container.titleSelectedColor = AppStyleColor;
        _container.indicatorColor = AppStyleColor;
        _container.containerBackgroundColor = [UIColor whiteColor];
    }
    return _container;
}


#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.orderStatusArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    return [dic objectForKey:statusNameKey];
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    ReferListViewController *listVC = [[ReferListViewController alloc] initWithOrderStatus:[dic objectForKey:statusKey]];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
    
    
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
