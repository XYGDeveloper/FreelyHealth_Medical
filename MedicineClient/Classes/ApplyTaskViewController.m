//
//  ApplyTaskViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ApplyTaskViewController.h"
#import "VipSexSelectCell.h"
#import <TPKeyboardAvoidingTableView.h>
#import "VipEditCell.h"
#import "SelectHospitalCell.h"
#import "SelectSexCell.h"
#import "SelectTeamListViewController.h"
#import "EditTableViewCell.h"
#import "DesTableViewCell.h"
#import "SelectMacherViewController.h"
#import "JopModel.h"
#import "PhotoUpLoadTableViewCell.h"
#import "HXPhotoModel.h"
#import "ApplyNoMachAndNoHos.h"
#import "ApplyNoDirctionRequest.h"
#import "DirectionToMachApi.h"
#import "DirectionMachRequest.h"
#import "DirectionToHospitalApi.h"
#import "DirectionToHospitalRequest.h"
#import "MBProgressHUD+BWMExtension.h"
#import "YQWaveButton.h"
#import "ACMediaFrame.h"
@interface ApplyTaskViewController ()<UITableViewDelegate, UITableViewDataSource,ApiRequestDelegate,UITextViewDelegate>
{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;
}
@property (nonatomic,strong)ACSelectMediaView *BGmamediaView;
//类型选择
@property (nonatomic,strong)VipSexSelectCell *typeCell;

//转诊定向、不定向
@property (nonatomic,strong)NSString *typeNum;

@property (nonatomic,strong)NSString *typeDir;

@property (nonatomic,strong)NSString *SexString;

@property (nonatomic,strong)SZTextView *textView;

@property (nonatomic,strong)UILabel *label;

//定向Tableview
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) EditTableViewCell *hospital;

@property (nonatomic, strong) EditTableViewCell *mach;

@property (nonatomic, strong) SelectHospitalCell *ran;

@property (nonatomic, strong) EditTableViewCell *name;

@property (nonatomic, strong) SelectSexCell *sex;

@property (nonatomic, strong) EditTableViewCell *age;

@property (nonatomic, strong) EditTableViewCell *phone;

@property (nonatomic, strong) PhotoUpLoadTableViewCell *photo;

@property (nonatomic,strong)NSArray *sectionOne;

@property (nonatomic,strong)NSArray *sectionTne;

@property (nonatomic,strong)NSArray *sectionThe;

@property (nonatomic,strong)NSString *hid;

@property (nonatomic,strong)NSString *did;

//

@property (nonatomic,strong)NSMutableArray *imageObjectArray;

@property (nonatomic,strong)YQWaveButton *commitButton;

@property (nonatomic,strong)NSMutableArray *urlImageArray;

@property (nonatomic,strong)NSString *ImagePath;

@property (nonatomic,strong)ApplyNoMachAndNoHos *autoApi;

@property (nonatomic,strong)DirectionToMachApi *machApi;

@property (nonatomic,strong)DirectionToHospitalApi *hosApi;

@property (nonatomic,strong)MBProgressHUD *hub;

@end

@implementation ApplyTaskViewController


- (ApplyNoMachAndNoHos *)autoApi
{
    if (!_autoApi) {
        
        _autoApi = [[ApplyNoMachAndNoHos alloc]init];
        
        _autoApi.delegate  =self;
        
    }
    
    return _autoApi;
}


- (DirectionToHospitalApi *)hosApi
{
    
    if (!_hosApi) {
        
        _hosApi = [[DirectionToHospitalApi alloc]init];
        
        _hosApi.delegate  =self;
        
    }
    
    return _hosApi;
}

- (DirectionToMachApi *)machApi
{
    
    if (!_machApi) {
        
        _machApi = [[DirectionToMachApi alloc]init];
        
        _machApi.delegate  =self;
        
    }
    
    return _machApi;
}


- (NSMutableArray *)imageObjectArray
{

    if (!_imageObjectArray) {
        
        
        _imageObjectArray = [NSMutableArray array];
    }
    
    return _imageObjectArray;

}

- (NSMutableArray *)urlImageArray
{
    
    if (!_urlImageArray) {
        
        
        _urlImageArray = [NSMutableArray array];
    }
    
    return _urlImageArray;
    
}

- (OSSApi *)Ossapi
{
    
    if (!_Ossapi) {
        
        _Ossapi = [[OSSApi alloc]init];
        
        _Ossapi.delegate  =self;
        
    }
    
    return _Ossapi;
    
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = Font(16);
        _textView.textColor = DefaultGrayTextClor;
        _textView.placeholder = @"请描述患者病情";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        
    }
    return _textView;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.hub bwm_hideWithTitle:command.response.msg
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeError];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _Ossapi) {
        [Utils removeHudFromView:self.view];
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
            [OSSImageUploader asyncUploadImages:self.imageObjectArray access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils removeAllHudFromView:self.view];
                });
                NSLog(@"%@",names);
                if (self.isFill == YES) {
                    for (NSString *name in names) {
                        NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                        [self.urlImageArray addObject:url];
                    }
                    NSLog(@"%@",self.urlImageArray);
                }else{
                    [self.urlImageArray addObjectsFromArray:names];
                }
            
            }];
    }
    
    
    if (api == _autoApi) {
        [Utils removeAllHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_receTask object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
    
    if (api == _machApi) {
        [Utils removeAllHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_receTask object:nil];

        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
    if (api == _hosApi) {
        [Utils removeAllHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_receTask object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


//非定向转诊

- (void)applyNoDir{

    if (self.urlImageArray.count <= 0) {
        [Utils postMessage:@"请提供图片病例资料" onView:self.view];
        return;
    }
    
    [Utils addHudOnView:self.view];
    
    ApplyNoDirctionHeader *head = [[ApplyNoDirctionHeader alloc]init];
    
    head.target = @"taskControl";
    
    head.method = @"makeTaskNoCondition";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    ApplyNoDirctionBody *body = [[ApplyNoDirctionBody alloc]init];
    
    body.patientname = self.name.text;
    
    body.patientsex = self.SexString;
    
    body.patientage = self.age.text;
    
    body.patientphone = self.phone.text;
   
    body.imagepath = [self.urlImageArray componentsJoinedByString:@","];
    
    body.des = self.textView.text;
    
    ApplyNoDirctionRequest *request = [[ApplyNoDirctionRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.autoApi ApplyNohosAndNoHotel:request.mj_keyValues.mutableCopy];
    
}

//定向转诊到医院

- (void)applyToMach{

    if (self.hid.length <= 0) {
        [Utils postMessage:@"定向转诊请选择医生或团队" onView:self.view];
        return;
    }
    
    if (self.urlImageArray.count <= 0) {
        [Utils postMessage:@"请提供图片病例资料" onView:self.view];
        return;
    }
    
    [Utils addHudOnView:self.view];
    DirectionToMachHeader *head = [[DirectionToMachHeader alloc]init];
    head.target = @"taskControl";
    head.method = @"makeTaskToDoctor";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    DirectionToMachBody *body = [[DirectionToMachBody alloc]init];
    
    body.patientname = self.name.text;
    
    body.patientsex = self.SexString;
    
    body.patientage = self.age.text;
    
    body.patientphone = self.phone.text;
    
    body.did = self.hid;
    
    body.imagepath = [self.urlImageArray componentsJoinedByString:@","];
   
    body.des = self.textView.text;
    
    DirectionMachRequest *request = [[DirectionMachRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.machApi ApplyDirectionToMach:request.mj_keyValues.mutableCopy];
    
    
}


//定向转诊到团队

- (void)applyToHospital{
    
    if (self.did.length <= 0) {
        [Utils postMessage:@"定向转诊请选择医生或团队" onView:self.view];
        return;
        
    }
    
    if (self.urlImageArray.count <= 0) {
        [Utils postMessage:@"请提供图片病例资料" onView:self.view];
        return;
    }
    
    [Utils addHudOnView:self.view];
    DirectionToHospitalHeader *head = [[DirectionToHospitalHeader alloc]init];
    
    head.target = @"taskControl";
    
    head.method = @"makeTaskToTeam";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    DirectionToHospitalBody *body = [[DirectionToHospitalBody alloc]init];
    
    body.patientname = self.name.text;
    
    body.patientsex = self.SexString;
    
    body.patientage = self.age.text;
    
    body.patientphone = self.phone.text;
    
    body.tid = self.did;
    
    body.imagepath = [self.urlImageArray componentsJoinedByString:@","];
  
    body.des = self.textView.text;
    
    DirectionToHospitalRequest *request = [[DirectionToHospitalRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.hosApi ApplyDirectionTohospital:request.mj_keyValues.mutableCopy];
    
}



- (VipSexSelectCell *)typeCell {
    if (!_typeCell) {
        _typeCell = [[VipSexSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _typeCell;
}

//定向

- (SelectHospitalCell *)ran {
    if (!_ran) {
        _ran = [[SelectHospitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_ran setSex:@"1"];
        _ran.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _ran;
}

- (EditTableViewCell *)hospital {
    if (!_hospital) {
        _hospital = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_hospital setTypeName:@"定向医生" placeholder:@""];
        [_hospital setEditAble:NO];
        _hospital.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _hospital.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _hospital;
}

- (EditTableViewCell *)mach {
    if (!_mach) {
        _mach = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_mach setTypeName:@"定向团队" placeholder:@""];
        [_mach setEditAble:NO];
        _mach.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _mach.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _mach;
}

- (EditTableViewCell *)name {
    if (!_name) {
        _name = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"患者姓名" placeholder:@"请输入姓名"];
        _name.textField.keyboardType = UIKeyboardTypeDefault;
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _name;
}

- (SelectSexCell *)sex {
    if (!_sex) {
        _sex = [[SelectSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_sex setEditAble:NO];
        [_sex setSex:@"1"];
        [_sex setIcon:[UIImage imageNamed:@""] editedIcon:[UIImage imageNamed:@""] placeholder:@"患者性别"];
        _sex.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _sex;
}

- (EditTableViewCell *)age {
    if (!_age) {
        _age = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_age setTypeName:@"患者年龄" placeholder:@"请输入年龄"];
        _age.textField.keyboardType = UIKeyboardTypePhonePad;
        _age.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _age;
}

- (EditTableViewCell *)phone {
    if (!_phone) {
        _phone = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_phone setTypeName:@"患者手机" placeholder:@"请输入手机号"];
        _phone.textField.keyboardType = UIKeyboardTypePhonePad;
        _phone.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _phone;
}
#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.typeCell.sex isEqualToString:@"0"]) {
        
        return 3;
        
    }else{
    
        return 4;

    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.typeCell.sex isEqualToString:@"0"]) {
      
        if (section == 0) {
            
            return self.sectionTne.count;
            
        }else if (section == 1){
            
            return 1;
        }else{
        
            return 1;
        
        }
        
        
    }else{
    
        if (section == 0) {
            if ([self.typeDir isEqualToString:@"1"]) {
                
                return self.sectionThe.count;
                
            }else{
                
                return self.sectionOne.count;
            }
            
        }else if (section == 1){
            return self.sectionTne.count;
        }else if (section == 2){
            
            return 1;
            
        }else{
        
            return 1;
        
        }
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.typeCell.sex isEqualToString:@"0"]) {
        
        if (indexPath.section == 1) {
            
            return 175;
        }else if (indexPath.section == 2){
            return 0;
        }
        return 52.0;
        
    }else{
    
        if (indexPath.section == 2) {
            
            return 175;
        }else if (indexPath.section == 3){
            return 0;
        }
        return 52.0;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.typeCell.sex isEqualToString:@"0"]) {
        if (section == 0){
            return 70;
        }else if (section == 2){
            return 45;
        }
        return 15;
    }else{
        if (section == 0){
            return 50;
        }else if (section == 3){
            return 45;
        }
        return 15;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if ([self.typeCell.sex isEqualToString:@"0"]) {
        if (section == 0) {
            
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,5, kScreenWidth, 50)];
            
            headView.backgroundColor = DefaultBackgroundColor;
            
            UIView *bottomBG = [LTUITools lt_creatView];
            
            bottomBG.backgroundColor = [UIColor whiteColor];
            
            [headView addSubview:bottomBG];
            
            [bottomBG mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(50);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            UILabel *label = [LTUITools lt_creatLabel];
            
            label.textAlignment = NSTextAlignmentLeft;
            
            label.font = [UIFont systemFontOfSize:16 weight:0.5];
            
            label.textColor = DefaultBlackLightTextClor;
            
            label.text = @"转诊患者基本资料";
            
            [bottomBG addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(bottomBG.mas_left).mas_equalTo(16);
                make.height.mas_equalTo(20);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(-5);
            }];
            
            return headView;
            
        }else if (section == 2){
            UIView *picview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            picview.backgroundColor = DefaultBackgroundColor;
            UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 30)];
            topview.backgroundColor = [UIColor whiteColor];
            [picview addSubview:topview];
            UILabel *picviewlabel = [LTUITools lt_creatLabel];
            picviewlabel.textAlignment = NSTextAlignmentLeft;
            picviewlabel.font = [UIFont systemFontOfSize:15.0f];
            picviewlabel.textColor = DefaultGrayLightTextClor;
            picviewlabel.text = @"病历资料";
            [topview addSubview:picviewlabel];
            [picviewlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(0);
            }];
            return picview;
            
        }
        
        return nil;

    }else{
    
        if (section == 0) {
            
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 50)];
            
            headView.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [LTUITools lt_creatLabel];
            
            label.textAlignment = NSTextAlignmentLeft;
            
            label.font = [UIFont systemFontOfSize:16 weight:0.3];
            
            label.textColor = DefaultBlackLightTextClor;
            
            label.text = @"转诊患者基本资料";
            
            [headView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(20);
                
                make.height.mas_equalTo(25);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(-5);
            }];
            
            return headView;
            
        }else if (section == 3){
            UIView *picview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            picview.backgroundColor = DefaultBackgroundColor;
            UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 30)];
            topview.backgroundColor = [UIColor whiteColor];
            [picview addSubview:topview];
            UILabel *picviewlabel = [LTUITools lt_creatLabel];
            picviewlabel.textAlignment = NSTextAlignmentLeft;
            picviewlabel.font = [UIFont systemFontOfSize:15.0f];
            picviewlabel.textColor = DefaultGrayLightTextClor;
            picviewlabel.text = @"病历资料";
            [topview addSubview:picviewlabel];
            [picviewlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(0);
            }];
            return picview;
            
        }
        
        return nil;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize

{
    
    UIGraphicsBeginImageContext(newSize);
   
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
   
    return newImage;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.typeCell.sex isEqualToString:@"0"]) {
        
        if (indexPath.section == 0) {
            
            return [self.sectionTne safeObjectAtIndex:indexPath.row];
            
        }else if(indexPath.section == 1){
            
            DesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DesTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
       }else{
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
           return cell;
           
       }
    }else{
    
        if (indexPath.section == 0) {
            
            if ([self.ran.sex isEqualToString:@"1"]) {
                
                return [self.sectionThe safeObjectAtIndex:indexPath.row];

                
            }else{
            

                return [self.sectionOne safeObjectAtIndex:indexPath.row];

            }
            
        }else if (indexPath.section == 1){
            
            return [self.sectionTne safeObjectAtIndex:indexPath.row];
            
        }else if (indexPath.section == 2){
            
            DesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DesTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.label = [LTUITools lt_creatLabel];
            
            self.label.textColor = DefaultGrayLightTextClor;
            
            self.label.text = @"详情描述";
            
            self.label.font = Font(16);
            
            [cell addSubview:self.label];
            
            [cell addSubview:self.textView];

            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.top.mas_equalTo(5);
                make.right.mas_equalTo(-16);
                make.height.mas_equalTo(25);
            }];
            
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(self.label.mas_bottom);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            return cell;
        }
      else{
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        return cell;
      }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.typeCell.sex isEqualToString:@"0"]) {
      
        if (indexPath.section == 0 && indexPath.row == 0) {//选择医院
            
            NSLog(@"%@",self.name.text);
            
        }else if (indexPath.section == 0 && indexPath.row == 1){
            
            NSLog(@"%@",self.sex.text);
            
            
        }else if (indexPath.section == 0 && indexPath.row == 2){
            
            NSLog(@"%@",self.age.text);
            
            
        }else if (indexPath.section == 0 && indexPath.row == 3){
            
            NSLog(@"%@",self.phone.text);
            
            
        }else{
            
            
            
        }
        
    }else{
    
        if (indexPath.section == 0 && indexPath.row == 0) {//选择范围
            
        }  else if (indexPath.section == 0 && indexPath.row == 1) {//选择医院
            
            
            if ([self.ran.sex isEqualToString:@"0"]) {
                
                SelectMacherViewController *mach = [SelectMacherViewController new];
                
                mach.title = @"选择医生";
                
                mach.hospital = ^(JopModel *model) {
                    
                    self.hospital.text = model.name;
                    
                    self.hid = model.id;
                    
                    NSLog(@"%@%@",model.name,model.id);
                  
                    
                };
                
                [self.navigationController pushViewController:mach animated:YES];
                
                
            }else{
            
                SelectTeamListViewController *hispital = [SelectTeamListViewController new];
                hispital.title = @"选择团队";
                
                hispital.hospital = ^(JopModel *model) {
                    
                    self.mach.text = model.name;
                    
                    self.did = model.id;
                    
                    NSLog(@"%@%@",model.name,model.id);

                };
                
                [self.navigationController pushViewController:hispital animated:YES];
                
            }
            
            
        }else if (indexPath.section == 1 && indexPath.row == 0) {//选择医院
            
            NSLog(@"%@",self.name.text);
            
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            
            NSLog(@"%@",self.sex.text);
            
            
        }else if (indexPath.section == 1 && indexPath.row == 2){
            
            NSLog(@"%@",self.age.text);
            
            
        }else if (indexPath.section == 1 && indexPath.row == 3){
            
            NSLog(@"%@",self.phone.text);
            
            
        }else{
            
            
            
        }

    }
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.nameString) {
        self.name.text = self.nameString;
    }
    
    if (self.ageString) {
        self.age.text = self.ageString;
    }
    
    if (self.sexal) {
        if ([self.sexal isEqualToString:@"男"]) {
            [self.sex setSex:@"1"];
        }else{
            [self.sex setSex:@"0"];
        }
    }
    
    if (self.sexal) {
        _SexString = self.sexal;
    }else{
        _SexString = @"男";
    }
    
    if (self.des) {
        self.textView.text = self.des;
    }
    
    if (self.phoneString) {
        self.phone.text = self.phoneString;
        NSLog(@"%@",self.imageArr);
    }
    
  
    self.typeCell.backgroundColor = [UIColor whiteColor];
    self.typeCell.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [self.view addSubview:self.typeCell];
    self.typeCell.sex = @"1";

    NSLog(@"%@",self.typeCell.sex);
    
    weakify(self);
    self.typeCell.type = ^(NSString *type){
        strongify(self);
        
        self.typeNum = type;
        
        NSLog(@"[][][][]%@",type);
        
        [self.tableView reloadData];

    };
    
    self.ran.type = ^(NSString *type){
        strongify(self);
        
        self.typeDir = type;
        
        NSLog(@"--------%@",type);
        
        [self.tableView reloadData];
        
    };
    
    self.sex.type = ^(NSString *type) {
        strongify(self);

        if ([type isEqualToString:@"0"]) {
            
            self.SexString = @"女";
            
        }else{
            
            self.SexString = @"男";
        
        }
        
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(self.typeCell.mas_bottom);
        make.bottom.mas_equalTo(-50);
    }];
    
    self.sectionOne = @[self.ran, self.hospital];
    self.sectionThe = @[self.ran, self.mach];

    self.sectionTne = @[self.name, self.sex,self.age,self.phone];

    [self.tableView registerClass:[DesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DesTableViewCell class])];

    [self.tableView registerClass:[PhotoUpLoadTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhotoUpLoadTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    self.BGmamediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 1)];
    if (self.imageArr.count > 0) {
        self.BGmamediaView .preShowMedias = self.imageArr;
    }
    self.BGmamediaView .type = ACMediaTypePhotoAndCamera;
    self.BGmamediaView .maxImageSelected = 12;
    self.BGmamediaView .naviBarBgColor = AppStyleColor;
    self.BGmamediaView .rowImageCount = 3;
    self.BGmamediaView .lineSpacing = 20;
    self.BGmamediaView .interitemSpacing = 20;
    self.BGmamediaView .sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.BGmamediaView  observeViewHeight:^(CGFloat mediaHeight) {
        self.tableView.tableFooterView = self.BGmamediaView;
    }];
    if (self.isFill == NO) {
        [self.urlImageArray addObjectsFromArray:self.imageArr];
    }
    [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        NSLog(@"%@",list);
        if (self.isFill == YES) {
            self.imageObjectArray = [NSMutableArray array];
            [self.imageObjectArray removeAllObjects];
            self.urlImageArray = [NSMutableArray array];
            [self.urlImageArray removeAllObjects];
            for (ACMediaModel *model in list) {
                [self.imageObjectArray addObject:model.image];
            }
            if (!self.imageObjectArray) {
                return ;
            }else{
                [Utils addHudOnView:self.view];
                //请求签名
                UploadHeader *header = [[UploadHeader alloc]init];
                header.target = @"generalDControl";
                header.method = @"getDOssSign";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                UploadBody *bodyer = [[UploadBody alloc]init];
                UploadToolRequest *requester = [[UploadToolRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                NSLog(@"%@",requester);
                [self.Ossapi getoss:requester.mj_keyValues.mutableCopy];
            }
        }else{
            self.imageObjectArray = [NSMutableArray array];
            [self.imageObjectArray removeAllObjects];
            self.urlImageArray = [NSMutableArray array];
            [self.urlImageArray removeAllObjects];
            for (ACMediaModel *model in list) {
                if (model.imageUrlString) {
                    [self.urlImageArray addObject:model.imageUrlString];
                }else{
                    [self.imageObjectArray addObject:model.image];
                }
            }
            
            if (!self.imageObjectArray) {
                return ;
            }else{
                [Utils addHudOnView:self.view];
                //请求签名
                UploadHeader *header = [[UploadHeader alloc]init];
                header.target = @"generalDControl";
                header.method = @"getDOssSign";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                UploadBody *bodyer = [[UploadBody alloc]init];
                UploadToolRequest *requester = [[UploadToolRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                NSLog(@"%@",requester);
                [self.Ossapi getoss:requester.mj_keyValues.mutableCopy];
            }
        }
    }];
    
    [self.tableView reloadData];
    
    self.commitButton = [YQWaveButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.commitButton];
    
    [self.commitButton setTitle:@"提交申请" forState:UIControlStateNormal];
    
    self.commitButton.titleLabel.font  = Font(16);
    
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.commitButton.backgroundColor = AppStyleColor;
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    [self.commitButton addTarget:self action:@selector(commitApply) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}


-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
    
}


- (void)commitApply{

    if ([Utils showLoginPageIfNeeded]) {} else {
        if (self.name.text.length <= 0) {
            [Utils postMessage:@"姓名不能为空" onView:self.view];
            return;
        }
        if (self.age.text.length <= 0) {
            [Utils postMessage:@"请填写病患者年龄" onView:self.view];
            return;
        }
        
        if (self.phone.text.length <= 0) {
            [Utils postMessage:@"请填写病患者手机号" onView:self.view];
            return;
        }
        
        NSError *error = nil;
        if (![ValidatorUtil isValidMobile:self.phone.text error:&error]) {
            
            [self toast:[error localizedDescription]];
            
            return;
        }
        
        if ([self.typeNum isEqualToString:@"0"]) {
            
            [self applyNoDir];
            
        }else{
            
            if ([self.typeDir isEqualToString:@"0"]) {
                
                [self applyToMach];

            }else{
                
                [self applyToHospital];
                
                
            }
        }
    
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
