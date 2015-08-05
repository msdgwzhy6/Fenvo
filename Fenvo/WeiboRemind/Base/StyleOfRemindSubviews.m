//
//  StyleOfRemindSubviews.m
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "StyleOfRemindSubviews.h"

@implementation StyleOfRemindSubviews

+ (CGFloat)imageHeight {
    return 50;
}

+ (CGFloat)usernameHeight {
    return 18;
}

+ (CGFloat)detailHeight {
    return 30;
}



+ (UIFont *)buttonFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:13.0];
}

+ (UIFont *)middleFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:12.0];
}

+ (UIFont *)smallFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:10.0];
}

+ (UIFont *)largeFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:16.0];
}



+ (UIColor *)middleGreyColor {
    return RGBACOLOR(160, 160, 160, 1);
}

+ (UIColor *)greyColor {
    return RGBACOLOR(60, 60, 60, 1);
}

+ (UIColor *)lightGreyColor {
    return RGBACOLOR(220, 220, 220, 1);
}

@end
