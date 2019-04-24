//
//  MyHZViewController.m
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyHZViewController.h"
#import "SegmentContainer.h"
#import "MyHZListViewController.h"
#import "AttenderViewController.h"
#import "AttenderViewController.h"
static NSString const * statusKey = @"status";
static NSString const * statusNameKey = @"name";
@interface MyHZViewController ()<SegmentContainerDelegate>
@property (nonatomic, strong) SegmentContainer *container;
@property (nonatomic, strong) NSArray *orderStatusArray;
@end

@implementation MyHZViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与详情";
    [self configOrderStatus];
    [self.view addSubview:self.container];
    [self selectOrderStatus];
    if ([self.isfaqi isEqualToString:@"1"]) {
        [self setRightNavigationItemWithTitle:@"添加" action:@selector(add)];
    }else{
        [self setRightNavigationItemWithTitle:@"" action:nil];
    }
    
}


-(void)add{
    //
    AttenderViewController *attend = [AttenderViewController new];
    attend.isModify = YES;
    attend.huizhenID = self.huizhnid;
    [self.navigationController pushViewController:attend animated:YES];
}

#pragma mark - Helper
- (void)configOrderStatus {
    self.orderStatusArray = @[@{statusKey:HuizhenReqStatusNoResponse, statusNameKey:@"未响应"},
                              @{statusKey:HuizhenReqStatusAttend, statusNameKey:@"确认参加"},
                              @{statusKey:HuizhenReqStatusNoAttend, statusNameKey:@"不参加"},];
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
        _container.titleFont = FontNameAndSize(15);
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
    MyHZListViewController *listVC = [[MyHZListViewController alloc] initWithOrderStatus:[dic objectForKey:statusKey] withHuizhenid:self.huizhnid];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
}

@end
