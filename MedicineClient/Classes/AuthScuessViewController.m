//
//  AuthScuessViewController.m
//  MedicineClient
//
//  Created by XI YANGUI on 2018/3/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuthScuessViewController.h"
#import "UIImage+GradientColor.h"
@interface AuthScuessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *desCriLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation AuthScuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"back"] highligthtedImage:[UIImage imageNamed:@"back"] action:@selector(back)];
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.button setBackgroundImage:bgImg forState:UIControlStateNormal];
    self.titleLabel.textColor = AppStyleColor;
    self.desLabel.textColor = DefaultGrayTextClor;
    self.desCriLabel.textColor = DefaultGrayTextClor;
    self.button.layer.cornerRadius = 5;
    self.button.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backTohome:(id)sender {
   
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index >3) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-4)] animated:YES];
    }else
    {
        //            [self.navigationController popToRootViewControllerAnimated:YES];
    }
//   [Utils jumpToHomepage];
    
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
