//
//  NormalViewController.m
//  MedicineClient
//
//  Created by L on 2017/12/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "NormalViewController.h"
#import "GroupViewController.h"
#import "CustomViewController.h"
#import "MyProfileViewController.h"
#import "DiseaseProfileViewController.h"
#import "TeamDetailViewController.h"
#import "GroupAllViewController.h"
@interface NormalViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isGroupCon == YES) {
        
        self.title = [User LocalUser].tname;
        [self setRightNavigationItemWithImage:[UIImage imageNamed:@"group"] highligthtedImage:[UIImage imageNamed:@"group"] action:@selector(scanGroup)];
    }
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
    // Do any additional setup after loading the view.
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"------%@",userId);
    
    if ([userId isEqualToString:[User LocalUser].id]) {
        
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].name portrait:[User LocalUser].facepath]);
        
    }else
    {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
    }
    
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
    if ([groupId isEqualToString:[User LocalUser].tgroupid]) {
        
        RCGroup *userInfo = [[RCGroup alloc]init];
        
        userInfo.groupId = [User LocalUser].tgroupid;
        
        userInfo.groupName = [User LocalUser].tname;
        
        userInfo.portraitUri = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
        
        return completion(userInfo);
        
    }else{
        
        RCGroup *userInfo = [[RCGroup alloc]init];
        
        userInfo.groupId = [User LocalUser].mdtgroupid;
        
        userInfo.groupName = [User LocalUser].mdtgroupname;
        
        userInfo.portraitUri = [User LocalUser].mdtgroupfacepath;
        return completion(userInfo);
        
    }
    
}

- (void)scanGroup{
    
    GroupAllViewController *all = [[GroupAllViewController alloc]init];
    
    all.normalGroup = YES;
    
    all.targrtid = self.targetId;
    
    all.title = @"能与会诊的医生";
    
    [self.navigationController pushViewController:all animated:YES];
    
}

- (void)didTapCellPortrait:(NSString *)userId {
    
    if ([userId isEqualToString:[User LocalUser].id]) {
        
        MyProfileViewController *profile = [MyProfileViewController new];
        
        profile.title = @"我的资料";
        
        [self.navigationController pushViewController:profile animated:YES];
        
    }else{
        
        //        if (self.conversationType == ConversationType_GROUP ||
        //            self.conversationType == ConversationType_DISCUSSION) {
        //            if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        //                //            [[RCDUserInfoManager shareInstance]
        //                //             getFriendInfo:userId
        //                //             completion:^(RCUserInfo *user) {
        //                //                 [[RCIM sharedRCIM] refreshUserInfoCache:user
        //                //                                              withUserId:user.userId];
        //                //                 [self gotoNextPage:user];
        //                //             }];
        //            } else {
        //                //            [[RCDUserInfoManager shareInstance]
        //                //             getUserInfo:userId
        //                //             completion:^(RCUserInfo *user) {
        //                //                 [[RCIM sharedRCIM] refreshUserInfoCache:user
        //                //                                              withUserId:user.userId];
        //                //                 [self gotoNextPage:user];
        //                //             }];
        //            }
        //        }
        //        if (self.conversationType == ConversationType_PRIVATE) {
        //            //        [[RCDUserInfoManager shareInstance] getUserInfo:userId
        //            //                                             completion:^(RCUserInfo *user) {
        //            //                                                 [[RCIM sharedRCIM]
        //            //                                                  refreshUserInfoCache:user
        //            //                                                  withUserId:user.userId];
        //            //                                                 [self gotoNextPage:user];
        //            //                                             }];
        //
        //
        //            DiseaseProfileViewController *dise = [[DiseaseProfileViewController alloc]init];
        //
        //            dise.title = @"患者资料";
        //
        //            [self.navigationController pushViewController:dise animated:YES];
        //
        //        }
        
        
        TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
        
        detail.ID = userId;
        
        detail.title = @"团队详情";
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
    
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
