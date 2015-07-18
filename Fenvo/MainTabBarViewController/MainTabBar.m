//
//  MainTabBar.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MainTabBar.h"

@implementation MainTabBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize osize = [super sizeThatFits:size];
    if(osize.height < 80) osize.height = 80;
    
    return osize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUserInteractionEnabled:YES];
    [self setTintColor:RGBACOLOR(250, 143, 5, 1) ];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setAlpha:0.75];
}

@end
