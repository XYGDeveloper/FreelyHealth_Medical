//
//  AddHospitalViewController.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/4/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AddHospitalViewController.h"
#import "AuthenticationViewController.h"
#import "UpdateProfileViewController.h"
@interface AddHospitalViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;
@property (weak, nonatomic) IBOutlet UIButton *commit;

@end

@implementation AddHospitalViewController


- (IBAction)tosure:(id)sender {
    [self.hospitalTextField resignFirstResponder];
    if (self.hospitalTextField.text.length <= 0) {
        [Utils postMessage:@"请输入要添加的医院名称" onView:self.view];
        return;
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AuthenticationViewController class]]) {
            AuthenticationViewController *revise =(AuthenticationViewController *)controller;
            revise.hospitalName(self.hospitalTextField.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
        if ([controller isKindOfClass:[UpdateProfileViewController class]]) {
            UpdateProfileViewController *revise =(UpdateProfileViewController *)controller;
            revise.hospitalName(self.hospitalTextField.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hospitalTextField.delegate = self;
    self.commit.layer.cornerRadius = 6;
    self.commit.layer.masksToBounds = YES;
    self.hospitalTextField.delegate = self;
    self.hospitalTextField.layer.cornerRadius = 4;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];

    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
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
