//
//  WeiboAvatarView.m
//  Fenvo
//
//  Created by Caesar on 15/4/1.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboAvatarView.h"

@implementation WeiboAvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        //self.layer.borderWidth = 1.0;
        //此处使用cgcolor
        //self.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = RGBACOLOR(220, 220, 220, 0.5);
    }
    return  self;
}
@end
