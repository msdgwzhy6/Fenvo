//
//  RemindBaseView.m
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "RemindBaseView.h"
#import "StyleOfRemindSubviews.h"

@implementation RemindBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    [self addSubview:_image];
    
    CGFloat imageX = CGRectGetMaxX(_image.frame) + 8;
    _username = [[UILabel alloc]initWithFrame:CGRectMake(imageX, 2, width - imageX, [StyleOfRemindSubviews usernameHeight])];
    [self addSubview:_username];
    
    CGFloat usernameY = CGRectGetMaxY(_username.frame);
    _detail = [[UILabel alloc]initWithFrame:CGRectMake(imageX, usernameY, width - imageX, [StyleOfRemindSubviews detailHeight])];
    [self addSubview:_detail];

}


@end
