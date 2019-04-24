//
//  QQWSearchBar.m
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "QQWSearchBar.h"

@implementation QQWSearchBar

- (id)init {
    
    self = [super init];
    if ( self ) {
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
//        UIImage *searchBackgroundImage = [UIImage imageWithRoundedCornersSize:1.0 usingImage:[UIImage imageWithColor:[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f] size:CGSizeMake(100.0, 28.0)]];
//        [self setSearchFieldBackgroundImage:searchBackgroundImage  forState:UIControlStateNormal];
        
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.searchTextPositionAdjustment = UIOffsetMake(10, 0);
        
//        [self setImage:[UIImage imageNamed:@"nav_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UITextField *searchTextField = [self valueForKey:@"_searchField"];
        if ([searchTextField isKindOfClass:[UITextField class]]) {
            searchTextField.font = Font(13);
            searchTextField.textColor = DefaultGrayLightTextClor;
        }
    }
    return self;
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    UITextField *searchTextField = [self valueForKey:@"_searchField"];
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: DefaultBlackLightTextClor}]];
    }
}

@end
