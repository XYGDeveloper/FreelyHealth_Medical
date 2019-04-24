//
//  UpdateProfileViewController.m
//  MedicineClient
//
//  Created by xyg on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "HClActionSheet.h"
#import "SelectJViewController.h"
#import "SelectHospitalViewController.h"
#import "KeshViewController.h"
#import "JopModel.h"
#import "MyProfilwModel.h"
#import "UpDateDetailTableViewCell.h"
#import "PhotoImgTableViewCell.h"
#import "UpdateProfileApi.h"
#import "UpdateProfileRequest.h"
#import "PhotoPickManager.h"
#import "UpdateProfileModel.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import "LSProgressHUD.h"
#import "FillIntroTableViewCell.h"
#import "ImgProfileTableViewCell.h"
#import "YYImageClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ACActionSheet.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+Block.h"
#define ORIGINAL_MAX_WIDTH [UIScreen mainScreen].bounds.size.width

@interface UpdateProfileViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ApiRequestDelegate,ACActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,
YYImageClipDelegate
>
@property (nonatomic, strong) UIImageView *portraitImageView;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)UIImage *tempImage;

@property (nonatomic,strong)NSString *imageUrl;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong)SelectTypeTableViewCell *name;

@property (nonatomic,strong)SelectTypeTableViewCell *sex;

@property (nonatomic,strong)SelectTypeTableViewCell *email;

@property (nonatomic,strong)JGProgressHUD *hud;

//
@property (nonatomic,strong)FillIntroTableViewCell *profileIntro;
@property (nonatomic,strong)FillIntroTableViewCell *menzhenTime;
//
@property (nonatomic,strong)ImgProfileTableViewCell *imgProfile;

@property (nonatomic,strong)SelectTypeTableViewCell *hotel;

@property (nonatomic,strong)SelectTypeTableViewCell *keshi;

@property (nonatomic,strong)SelectTypeTableViewCell *jop;
//
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *sectionDataArray;

@property (nonatomic, strong) NSArray *introArray;

@property (nonatomic, strong) NSArray *menzhenArray;

@property (nonatomic, strong) NSArray *profileArray;

@property (nonatomic,strong)UpDateDetailTableViewCell
 *cell;
@property (nonatomic,strong)UpDateDetailTableViewCell *timeCell;

@property (nonatomic, strong) UpdateProfileModel *Updatemodel;

//
@property (nonatomic,strong)HClActionSheet *selectSex;

@property (nonatomic,strong)NSString *hosID;

@property (nonatomic,strong)NSString *keshiID;

@property (nonatomic,strong)NSString *JopID;

@property (nonatomic,strong)UpdateProfileApi *updateApi;

@property (nonatomic,strong)ACActionSheet *actionsheet3;

@property (nonatomic,strong)ACActionSheet *actionsheet2;
@property (nonatomic,strong)ACActionSheet *actionsheet1;

@property (nonatomic,strong)YYImageClipViewController *cliper1;

@property (nonatomic,strong)YYImageClipViewController *cliper2;

@property (nonatomic,strong)YYImageClipViewController *cliper3;

@property (nonatomic,strong)UIImagePickerController *picker1;

@property (nonatomic,strong)UIImagePickerController *picker2;

@property (nonatomic,strong)UIImagePickerController *picker3;
@property (nonatomic,strong)UIImageView *imageSide;

@property (nonatomic,strong)UIImageView *imageOther;

@property (nonatomic,strong)UIImage *changeimageSide;

@property (nonatomic,strong)UIImage *changeimageOther;

@property (nonatomic,strong)UIImageView *faceImage;

//盛放所有的图片数组
@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic,strong)PhotoImgTableViewCell *photocell;

@property (nonatomic,strong)OSSApi *Ossapi;

@property (nonatomic,strong)OSSApi *Ossapi1;

@property (nonatomic,strong)OSSApi *Ossapi2;

@property (nonatomic,strong)OSSModel *ossmodel;

@property (nonatomic,strong)NSString *imageSideString;

@property (nonatomic,strong)NSString *imageOtherSideString;

@property (nonatomic,strong)UIButton *modifyButton;




@end

@implementation UpdateProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    weakify(self);
    self.hospitalName = ^(NSString *hospital) {
        strongify(self);
        self.hotel.textField.text = hospital;
        self.hosID = @"";
    };
    
    self.keshiName = ^(NSString *Keshi) {
        strongify(self);
        self.keshi.textField.text = Keshi;
        self.keshiID = @"";
    };
}

- (UIButton *)modifyButton{
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyButton.backgroundColor = AppStyleColor;
        [_modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    return _modifyButton;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (OSSApi *)Ossapi
{
    if (!_Ossapi) {
        _Ossapi = [[OSSApi alloc]init];
        _Ossapi.delegate  =self;
    }
    return _Ossapi;
}

- (OSSApi *)Ossapi1
{
    if (!_Ossapi1) {
        _Ossapi1 = [[OSSApi alloc]init];
        _Ossapi1.delegate  =self;
    }
    return _Ossapi1;
}


- (OSSApi *)Ossapi2
{
    if (!_Ossapi2) {
        _Ossapi2 = [[OSSApi alloc]init];
        _Ossapi2.delegate  =self;
    }
    return _Ossapi2;
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    if (api == _updateApi) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.Updatemodel = responsObject;
        [User LocalUser].name = self.Updatemodel.name;
        [User LocalUser].pname = self.Updatemodel.pname;
        [User LocalUser].hname = self.Updatemodel.hname;
        [User LocalUser].dname = self.Updatemodel.dname;
        [User LocalUser].tname = self.Updatemodel.tname;
        [User LocalUser].sex = self.Updatemodel.sex;
        [User LocalUser].facepath = self.Updatemodel.facepath;
        [User LocalUser].isauthenticate = self.Updatemodel.isauthenticate;
        [User saveToDisk];
        //选择类型字段
        UdeskCustomer *updatecustomer = [UdeskCustomer new];
        updatecustomer.sdkToken = [User LocalUser].token;
        updatecustomer.customerDescription = self.Updatemodel.introduction;
        UdeskCustomerCustomField *textField = [UdeskCustomerCustomField new];
        textField.fieldKey = @"TextField_20157";
        textField.fieldValue = @"暂无留言";
        ;
        UdeskCustomerCustomField *keshiField = [UdeskCustomerCustomField new];
        keshiField.fieldKey = @"TextField_21228";
        keshiField.fieldValue = self.Updatemodel.dname;
        
        UdeskCustomerCustomField *hosField = [UdeskCustomerCustomField new];
        hosField.fieldKey = @"TextField_21229";
        hosField.fieldValue = self.Updatemodel.hname;
        
        UdeskCustomerCustomField *tField = [UdeskCustomerCustomField new];
        tField.fieldKey = @"TextField_21230";
        tField.fieldValue = self.Updatemodel.tname;
        UdeskCustomerCustomField *zhichengField = [UdeskCustomerCustomField new];
        zhichengField.fieldKey = @"TextField_21231";
        zhichengField.fieldValue = self.Updatemodel.pname;
        UdeskCustomerCustomField *selectField = [UdeskCustomerCustomField new];
        selectField.fieldKey = @"SelectField_10248";
        
        if ([self.Updatemodel.sex isEqualToString:@"男"]) {
            
            selectField.fieldValue = @[@"0"];
            
        }else{
            
            selectField.fieldValue = @[@"1"];
            
        }
        
        updatecustomer.customField = @[textField,keshiField,hosField,zhichengField,selectField];

        [UdeskManager updateCustomer:updatecustomer];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }
    
    if (api == _Ossapi) {
        
        OSSModel *model = responsObject;
        
        NSLog(@"%@",responsObject);
        

        [OSSImageUploader asyncUploadImages:@[self.changeimageSide] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                for (NSString *name in names) {
                    
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    
                    self.imageSideString = url;
                    
                    [self.imgProfile.imageSide sd_setImageWithURL:[NSURL URLWithString:url]];
                    
                }
            });
            
        }];

        
    }
    
    if (api == _Ossapi1) {
        OSSModel *model = responsObject;
        self.hud = [Public hudWhenRequest];
        [OSSImageUploader asyncUploadImages:@[self.changeimageOther] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                for (NSString *name in names) {
                    NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                    self.imageOtherSideString = url;
                    [self.imgProfile.imageOther sd_setImageWithURL:[NSURL URLWithString:url]];
                    [_hud dismissAnimated:YES];
                }
            });
            
        }];

    }
    
    if (api == _Ossapi2) {
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        [OSSImageUploader asyncUploadImages:@[self.tempImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSString *name in names) {
                
                NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                
                self.imageUrl = url;
                
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
                
            }
            });

        }];
    }
    
}


- (UpdateProfileApi *)updateApi
{

    if (!_updateApi) {
        
        _updateApi = [[UpdateProfileApi alloc]init];
        
        _updateApi.delegate  =self;
        
    }

    return _updateApi;

}



- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"姓名" placeholder:@""];
        
    }
    return _name;
}

- (SelectTypeTableViewCell *)sex {
    if (!_sex) {
        _sex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _sex.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_sex setTypeName:@"性别" placeholder:@""];
        [_sex setEditAble:NO];
        
    }
    return _sex;
}

- (SelectTypeTableViewCell *)email {
    if (!_email) {
        _email = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_email setTypeName:@"邮箱" placeholder:@""];
        _email.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _email;
}


//

- (SelectTypeTableViewCell *)hotel {
    if (!_hotel) {
        _hotel = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_hotel setTypeName:@"医院" placeholder:@""];
        _hotel.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _hotel.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        _hotel.textField.userInteractionEnabled = YES;
        
        [_hotel setEditAble:NO];
        
    }
    return _hotel;
    
}

- (SelectTypeTableViewCell *)keshi {
    if (!_keshi) {
        _keshi = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_keshi setTypeName:@"科室" placeholder:@""];
        _keshi.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _keshi.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

        _keshi.textField.userInteractionEnabled = YES;
        
        [_keshi setEditAble:NO];
        
    }
    return _keshi;
}

- (SelectTypeTableViewCell *)jop {
    if (!_jop) {
        _jop = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_jop setTypeName:@"职位" placeholder:@""];
        _jop.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _jop.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        _jop.textField.userInteractionEnabled = YES;
        
        [_jop setEditAble:NO];
        
    }
    return _jop;
}

- (FillIntroTableViewCell *)profileIntro {
    if (!_profileIntro) {
        _profileIntro = [[FillIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_profileIntro setTypeName:@"个人简介" placeholder:@"请设置个人资料简介"];
    }
    return _profileIntro;
}

- (FillIntroTableViewCell *)menzhenTime {
    if (!_menzhenTime) {
        _menzhenTime = [[FillIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_menzhenTime setTypeName:@"门诊时间" placeholder:@"请输入门诊时间"];
    }
    return _menzhenTime;
}

- (ImgProfileTableViewCell *)imgProfile {
    if (!_imgProfile) {
        _imgProfile = [[ImgProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_imgProfile setTypeleftImage:self.model.certification rightImg:self.model.workcard];
    }
    return _imgProfile;
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
    
}
- (void)layoutsubview{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UpDateDetailTableViewCell class] forCellReuseIdentifier:@"menzhen"];

    [self.tableView registerClass:[UpDateDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UpDateDetailTableViewCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoImgTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PhotoImgTableViewCell class])];

    self.tableView.separatorColor = RGBA(102, 102, 102, 0.25);

    [self.view addSubview:self.tableView];
 
    [self layoutsubview];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.headView;
    
    UILabel *des = [[UILabel alloc]init];
    
    des.text  =@"头像";
    des.userInteractionEnabled = YES;
    des.font = Font(16);
    des.textColor = DefaultGrayTextClor;
    des.textAlignment = NSTextAlignmentLeft;
    
    [self.headView addSubview:des];
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.headView.mas_centerY);
        make.left.mas_equalTo(20);
    }];
    
    self.headImage = [[UIImageView alloc]init];
        
    [self.headView addSubview:self.headImage];
    
    self.headImage.userInteractionEnabled = YES;
    
    self.headImage.layer.cornerRadius = 35;
    
    self.headImage.layer.masksToBounds = YES;
    
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.headImage.clipsToBounds = YES;
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(des.mas_right).mas_equalTo(40);
        make.width.height.mas_equalTo(70);
        make.centerY.mas_equalTo(self.headView.mas_centerY);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headView addSubview:button];
    [button setImage:[UIImage imageNamed:@"rrow"] forState:UIControlStateNormal];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.headView.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHead)];
    [self.headView addGestureRecognizer:tap];
    self.sectionDataArray = @[self.name,self.sex,self.email];
    self.dataArray = @[self.hotel, self.keshi, self.jop];
    self.introArray = @[self.profileIntro];
    self.menzhenArray = @[self.menzhenTime];
    self.profileArray = @[self.imgProfile];
    self.name.text = self.model.name;
    self.sex.text  =self.model.sex;
    self.email.text  =self.model.email;
    self.hotel.text = self.model.hname;
    self.keshi.text  =self.model.dname;
    self.profileIntro.text = self.model.introduction;
    self.menzhenTime.text = self.model.menzhen;
    self.jop.text  =self.model.pname;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]];
    self.cell.textView.text = self.model.introduction;
    [self.tableView reloadData];
    
    [self.view addSubview:self.modifyButton];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.modifyButton addTarget:self action:@selector(NextStep) forControlEvents:UIControlEventTouchUpInside];
    
    weakify(self);
    self.imgProfile.leftimage = ^{
        strongify(self);
        [self addPic1];
    };
    
    self.imgProfile.rightimage = ^{
        strongify(self);
        [self addPic2];
    };
    // Do any additional setup after loading the view.
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.sectionDataArray.count;
    }else if(section == 1){
        return self.dataArray.count;
    }else if(section == 2){
        return self.introArray.count;
    }else if(section == 3){
        return self.menzhenArray.count;
    }else{
        return self.profileArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 45.0;
    }else if( indexPath.section == 2 ||indexPath.section == 3){
        return  100;
    }else{
        return 155;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self.sectionDataArray safeObjectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 1){
        return [self.dataArray safeObjectAtIndex:indexPath.row];
    }else if (indexPath.section == 2){
        return [self.introArray safeObjectAtIndex:indexPath.row];
    }else if (indexPath.section == 3){
      
        return [self.menzhenArray safeObjectAtIndex:indexPath.row];
    }else{
        return [self.profileArray safeObjectAtIndex:indexPath.row];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0){
            return 10;
        }else{
            return 5;
        }
    }else{
        if (section == 0){
            return 10;
        }else{
            return 5;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        }

    }else{
        if (section == 0){
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        }else{
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        }
    }
}

- (void)changeHead{
    
    self.actionsheet3 = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //相机权限
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }else{
                self.picker3 = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    self.picker3 = [[UIImagePickerController alloc] init];
                    self.picker3.delegate = self;
                    self.picker3.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker3.allowsEditing = YES;
                    self.picker3.showsCameraControls = YES;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker3.mediaTypes = mediaTypes;
                    self.picker3.delegate = self;
                    [self presentViewController: self.picker3
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertV show];
                }
            }
         
        }else if(buttonIndex == 1){
            
            ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"权限设置" message:@"请您在手机设置里面打开相机读取和写入权限" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }
                }];
                [alert show];
                
            }else{
                
                if ([self isPhotoLibraryAvailable]) {
                    self.picker3 = [[UIImagePickerController alloc] init];
                    self.picker3.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker3.mediaTypes = mediaTypes;
                    self.picker3.delegate = self;
                    [self presentViewController: self.picker3
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }
            }
        }
        
    }];
    
    self.actionsheet3.delegate = self;
    
    [self.actionsheet3 show];

    
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == self.picker3) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.cliper3 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        self.cliper3.delegate = self;
        [picker pushViewController:self.cliper3 animated:NO];
    }
    
    if (picker == self.picker2) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.cliper2 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        self.cliper2.delegate = self;
        [picker pushViewController:self.cliper2 animated:NO];
    }
   
    if (picker == self.picker1) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.cliper1 = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        self.cliper1.delegate = self;
        [picker pushViewController:self.cliper1 animated:NO];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (cropperViewController == self.cliper3) {
        self.tempImage = editedImage;
        if (!self.tempImage) {
            [Utils postMessage:@"请选择可编辑的照片" onView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在修改...";
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
        
        [self.Ossapi2 getoss:requester.mj_keyValues.mutableCopy];
        
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (cropperViewController == self.cliper2) {
        self.changeimageOther = editedImage;
        if (!self.changeimageOther) {
            [Utils postMessage:@"请选择可编辑的照片" onView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在修改...";
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
        
        [self.Ossapi1 getoss:requester.mj_keyValues.mutableCopy];
        
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (cropperViewController == self.cliper1) {
        self.changeimageSide = editedImage;
        if (!self.changeimageSide) {
            [Utils postMessage:@"请选择可编辑的照片" onView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在修改...";
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

        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark - camera utility
- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    weakify(self);
    if (indexPath.section == 0 && indexPath.row == 0) {//选择
        
    } else if (indexPath.section == 0 &&indexPath.row == 1) {//选择
        self.selectSex = [[HClActionSheet alloc] initWithTitle:@"请选择性别" style:HClSheetStyleWeiChat itemTitles:@[@"男",@"女"]];
        self.selectSex.delegate = self;
        self.selectSex.tag = 60;
        self.selectSex.titleTextColor = DefaultBlackLightTextClor;
        self.selectSex.titleTextFont = Font(16);
        self.selectSex.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectSex.itemTextColor = DefaultGrayTextClor;
        self.selectSex.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectSex.cancleTextColor = DefaultGrayTextClor;
        [self.selectSex didFinishSelectIndex:^(NSInteger index, NSString *title) {
            strongify(self);
            self.sex.text = title;
        }];
        
    }else if (indexPath.section == 0 &&indexPath.row == 2) {//选择
        
    }else if (indexPath.section == 1 &&indexPath.row == 0) {//选择
        
        SelectHospitalViewController *hos = [SelectHospitalViewController new];
        hos.Auhospital = YES;
        hos.title = @"选择医院";
        
        hos.hospital = ^(JopModel *model) {
            
            self.hotel.textField.text = model.name;
            
            self.hosID = model.id;
            
        };
        
        [self.navigationController pushViewController:hos animated:YES];
        
    }else if (indexPath.section == 1 &&indexPath.row == 1) {//选择
        
        KeshViewController *keshi = [KeshViewController new];
        keshi.Aukeshi = YES;
        keshi.keshi = ^(JopModel *model) {
            self.keshi.textField.text = model.name;
            self.keshiID = model.id;
        };
        keshi.title = @"选择科室";
        [self.navigationController pushViewController:keshi animated:YES];
        
    }else if (indexPath.section == 1 &&indexPath.row == 2) {//选择
        
        SelectJViewController *jop = [SelectJViewController new];
        
        jop.jop = ^(JopModel *model) {
            self.jop.textField.text = model.name;
            self.JopID = model.id;
        };
        jop.title = @"选择职位";
        [self.navigationController pushViewController:jop animated:YES];
    }
    
    
}


- (void)NextStep{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在修改...";
    updateProfileHeader *header = [[updateProfileHeader alloc]init];
    
    header.target = @"ownDControl";
    
    header.method = @"updateMyInfos";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    updateProfileBody *bodyer = [[updateProfileBody alloc]init];
    bodyer.name  = self.name.text;
    bodyer.sex = self.sex.text;
    bodyer.email = self.email.text;
    if (self.hosID.length <= 0) {
        bodyer.hospitalname = self.hotel.textField.text;
        if (self.model.hid.length > 0) {
            bodyer.hid = self.model.hid;
        }else{
            bodyer.hid = @"";
        }
    }else{
        bodyer.hid = self.hosID;
    }
    
    if (self.keshiID.length <= 0) {
        bodyer.departmentname = self.keshi.textField.text;
        if (self.model.did.length > 0) {
            bodyer.did = self.model.did;
        }else{
            bodyer.did = @"";
        }
    }else{
        bodyer.did = self.keshiID;
    }
    bodyer.pid = self.JopID.length <= 0?self.model.pid:self.JopID;
    bodyer.introduction =  self.profileIntro.text.length <=0?self.model.introduction:self.profileIntro.text;
    bodyer.menzhen = self.menzhenTime.text.length <=0?self.model.menzhen:self.menzhenTime.text;
    bodyer.facepath = self.imageUrl.length <=0?self.model.facepath:self.imageUrl;
    bodyer.certification = self.imageSideString.length <=0?self.model.certification:self.imageSideString;
    bodyer.workcard = self.imageOtherSideString.length <=0?self.model.workcard:self.imageOtherSideString;
    //图片处理
    UpdateProfileRequest *requester = [[UpdateProfileRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self.updateApi updateProfile:requester.mj_keyValues.mutableCopy];

}

- (void)addPic1{

    self.actionsheet1 = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }else{
                self.picker1 = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    self.picker1 = [[UIImagePickerController alloc] init];
                    self.picker1.delegate = self;
                    self.picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker1.allowsEditing = YES;
                    self.picker1.showsCameraControls = YES;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker1.mediaTypes = mediaTypes;
                    self.picker1.delegate = self;
                    [self presentViewController: self.picker1
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertV show];
                }
            }
          
        }else if(buttonIndex == 1){
            
            ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"权限设置" message:@"请您在手机设置里面打开相机读取和写入权限" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }
                }];
                [alert show];
                
            }else{
                // 从相册中选取
                if ([self isPhotoLibraryAvailable]) {
                    self.picker1 = [[UIImagePickerController alloc] init];
                    self.picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker1.mediaTypes = mediaTypes;
                    self.picker1.delegate = self;
                    [self presentViewController:self.picker1
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }
            }
        }
    }];
    
    self.actionsheet1.delegate = self;
    
    [self.actionsheet1 show];

}

- (void)addPic2{
    
    self.actionsheet2 = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }else{
                self.picker2 = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    self.picker2 = [[UIImagePickerController alloc] init];
                    self.picker2.delegate = self;
                    self.picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker2.allowsEditing = YES;
                    self.picker2.showsCameraControls = YES;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker2.mediaTypes = mediaTypes;
                    self.picker2.delegate = self;
                    [self presentViewController: self.picker2
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }else{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertV show];
                }
                
            }
          
        }else if(buttonIndex == 1){
            
            ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"权限设置" message:@"请您在手机设置里面打开相机读取和写入权限" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                    }
                }];
                [alert show];
                
            }else{
                // 从相册中选取
                if ([self isPhotoLibraryAvailable]) {
                    self.picker2 = [[UIImagePickerController alloc] init];
                    self.picker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                    self.picker2.mediaTypes = mediaTypes;
                    self.picker2.delegate = self;
                    [self presentViewController:self.picker2
                                       animated:YES
                                     completion:^(void){
                                         NSLog(@"Picker View Controller is presented");
                                     }];
                }
            }
         
        }
    }];
    
    self.actionsheet2.delegate = self;
    
    [self.actionsheet2 show];
}

@end
