//
//  SelectJViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectJViewController.h"
#import "SelectHospitalTableViewCell.h"
#import "JopModel.h"
#import "JopApi.h"
#import "JopListRequest.h"
#import "QQWSearchBar.h"
@interface SelectJViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,ApiRequestDelegate>
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic,strong)JopApi *api;

@property (nonatomic,strong)JopApi *api1;

@property (nonatomic,strong)NSMutableArray *jopArray;

@end

@implementation SelectJViewController


- (JopApi *)api
{
    
    if (!_api) {
        
        
        _api = [[JopApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (JopApi *)api1
{
    
    if (!_api1) {
        
        
        _api1 = [[JopApi alloc]init];
        
        _api1.delegate = self;
        
    }
    
    return _api1;
    
}


- (void)commonInit
{
    jopHeader *head = [[jopHeader alloc]init];
    
    head.target = @"noTokenDControl";
    
    head.method = @"getDPostList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    jopBody *body = [[jopBody alloc]init];
    
    JopListRequest *request = [[JopListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api getJopList:request.mj_keyValues.mutableCopy];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    
    _searchResults = responsObject;
    
    if (api == _api) {
        
        _names = responsObject;
        
        [self.tableView reloadData];
        
    }
    
    if (api == _api1) {
        
        _searchResults = responsObject;
        
        [self.searchController.searchResultsTableView reloadData];
        
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择职位";
    [self configureTableView:self.tableView];
    
    [self addSearchBarAndSearchDisplayController];
    
}

- (void)addSearchBarAndSearchDisplayController {
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索符合条件的职位";
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(kScreenWidth, 64)];
    searchBar.backgroundImage = bgImg;
    self.tableView.tableHeaderView = searchBar;
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.searchController = searchDisplayController;
}

//===============================================
#pragma mark -
#pragma mark Helper
//===============================================

- (void)configureTableView:(UITableView *)tableView {
    
    tableView.separatorInset = UIEdgeInsetsZero;
    
    [tableView registerNib:[UINib nibWithNibName:@"SelectHospitalTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([SelectHospitalTableViewCell class])];
    UIView *tableFooterViewToGetRidOfBlankRows = [[UIView alloc] initWithFrame:CGRectZero];
    tableFooterViewToGetRidOfBlankRows.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = tableFooterViewToGetRidOfBlankRows;
}

//===============================================
#pragma mark -
#pragma mark UITableView
//===============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return [self.names count];
    }
    else {
        return [self.searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (tableView == self.tableView) {
        
        SelectHospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectHospitalTableViewCell class]) forIndexPath:indexPath];
        
        JopModel *model = [_names objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        return cell;
        
        
    }else {
        
        SelectHospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectHospitalTableViewCell class]) forIndexPath:indexPath];
        
        JopModel *model = [_searchResults objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView) {
        
        JopModel *model = [_names objectAtIndex:indexPath.row];
        
        if (self.jop) {
            
            self.jop(model);
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        
        JopModel *model = [_searchResults objectAtIndex:indexPath.row];
        
        if (self.jop) {
            
            self.jop(model);
        }
        
        [self.view endEditing:YES];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

//===============================================
#pragma mark -
#pragma mark UISearchDisplayDelegate
//===============================================

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will begin search");
    
    controller.searchBar.barTintColor = AppStyleColor;
    
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did begin search");
    controller.searchBar.barTintColor = AppStyleColor;
    
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will end search");
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did end search");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did load table");
    [self configureTableView:tableView];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will unload table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will hide table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did hide table");
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"🔦 | should reload table for search string?");
    jopHeader *head = [[jopHeader alloc]init];
    
    head.target = @"noTokenDControl";
    
    head.method = @"getDPostList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    jopBody *body = [[jopBody alloc]init];
    
    body.name = searchString;
    
    JopListRequest *request = [[JopListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api1 getJopList:request.mj_keyValues.mutableCopy];
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"🔦 | should reload table for search scope?");
    return YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    jopHeader *head = [[jopHeader alloc]init];
    
    head.target = @"noTokenDControl";
    
    head.method = @"getDPostList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    jopBody *body = [[jopBody alloc]init];
    
    body.name = searchBar.text;
    
    JopListRequest *request = [[JopListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api1 getJopList:request.mj_keyValues.mutableCopy];
    
}                     // called when keyboard search button pressed


@end
