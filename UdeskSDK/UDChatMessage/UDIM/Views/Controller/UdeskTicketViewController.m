//
//  UdeskTicketViewController.m
//  UdeskSDK
//
//  Created by Udesk on 15/11/26.
//  Copyright (c) 2015年 Udesk. All rights reserved.
//

#import "UdeskTicketViewController.h"
#import "UdeskManager.h"
#import "UdeskUtils.h"
#import "UdeskTools.h"
#import "UdeskFoundationMacro.h"
#import "UdeskLanguageTool.h"
#import "UdeskCustomNavigation.h"
#import "UdeskViewExt.h"
#import <WebKit/WebKit.h>

@interface UdeskTicketViewController ()

@end

@implementation UdeskTicketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UdeskCustomNavigation *customNav = [[UdeskCustomNavigation alloc] initWithFrame:CGRectMake(0, 0, UD_SCREEN_WIDTH, 64)];
    
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    
    customNav.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
    @try {
        
        self.view.backgroundColor = self.sdkConfig.sdkStyle.tableViewBackGroundColor;
        
       
        
        if (self.sdkConfig.sdkStyle.navigationColor) {
            customNav.backgroundColor = self.sdkConfig.sdkStyle.navigationColor;
        }
        if (self.sdkConfig.sdkStyle.titleColor) {
            customNav.titleLabel.textColor = [UIColor whiteColor];
        }
        if (self.sdkConfig.sdkStyle.navBackButtonColor) {
            [customNav.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        if (self.sdkConfig.ticketTitle) {
            customNav.titleLabel.text = self.sdkConfig.ticketTitle;
        }
        else {
            customNav.titleLabel.text = getUDLocalizedString(@"udesk_leave_msg");
        }
        
        [self.view addSubview:customNav];
        
        customNav.closeViewController = ^(){
            [super dismissViewControllerAnimated:YES completion:nil];
        };
        
        NSString *key = [UdeskManager key];
        NSString *domain = [UdeskManager domain];
        
        if (![UdeskTools isBlankString:key]||[UdeskTools isBlankString:domain]) {
            
            NSURL *ticketURL =  [UdeskManager getSubmitTicketURL];
            // 设置语言
            NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
            // 默认是中文
            if (!tmp)
            {
                tmp = @"zh-Hans";
            }
            
            NSString *language;
            if ([tmp isEqualToString:@"zh-Hans"]) {
                language = @"&language=zh-cn";
            }
            else {
                language = @"&language=en-us";
            }
            
            ticketURL = [NSURL URLWithString:[ticketURL.absoluteString stringByAppendingString:language]];
            
            if (ud_isIOS8) {
                
                WKWebView *ticketWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, customNav.ud_bottom, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-customNav.ud_bottom)];
                ticketWebView.backgroundColor = [UIColor whiteColor];
                [ticketWebView loadRequest:[NSURLRequest requestWithURL:ticketURL]];
                [self.view addSubview:ticketWebView];
                
                
            }
            else {
            
                UIWebView *ticketWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, customNav.ud_bottom, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-customNav.ud_bottom)];
                ticketWebView.backgroundColor = [UIColor whiteColor];
                [ticketWebView loadRequest:[NSURLRequest requestWithURL:ticketURL]];
                [self.view addSubview:ticketWebView];
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if ( self.presentedViewController)
    {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)dealloc
{
    NSLog(@"%@销毁了",[self class]);
}

@end
