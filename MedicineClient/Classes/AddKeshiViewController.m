//
//  AddKeshiViewController.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/4/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AddKeshiViewController.h"
#import "AuthenticationViewController.h"
#import "UpdateProfileViewController.h"
@interface AddKeshiViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keshiTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation AddKeshiViewController


- (IBAction)commit:(id)sender {
    
    [self.keshiTextField resignFirstResponder];
    if (self.keshiTextField.text.length <= 0) {
        [Utils postMessage:@"请输入要添加的医院所在科室名称" onView:self.view];
        return;
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AuthenticationViewController class]]) {
            AuthenticationViewController *revise =(AuthenticationViewController *)controller;
            revise.keshiName(self.keshiTextField.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
        if ([controller isKindOfClass:[UpdateProfileViewController class]]) {
            UpdateProfileViewController *revise =(UpdateProfileViewController *)controller;
            revise.keshiName(self.keshiTextField.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.commitButton.layer.cornerRadius = 6;
    self.commitButton.layer.masksToBounds = YES;
    self.keshiTextField.layer.cornerRadius = 4;
    self.keshiTextField.delegate = self;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    // Do any additional setup after loading the view from its nib.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
