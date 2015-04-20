//
//  WeiboImageView.m
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboImageView.h"
#import "WeiboImageBrowser.h"

@implementation WeiboImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (WeiboImageView *)initWithStyleAndTag:(NSInteger)tag{
    
    self = [super init];
    if (self) {
        self.tag = tag;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        //self.layer.borderWidth = 1.0;
        //此处使用cgcolor
        //self.layer.borderColor = [UIColor grayColor].CGColor;
        self.hidden = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = RGBACOLOR(220, 220, 220, 0.5);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBmiddleImage:)];
        [self addGestureRecognizer:tap];
        
    }
    return  self;
}
- (void)setOriginal_pic_url{
    _original_pic_url = _original_pic_urls[self.tag];
}
- (void)setBmiddle_pic_url{
    _bmiddle_pic_url = _bmiddle_pic_urls[self.tag];
}
- (void)setBmiddle_pic_urls:(NSMutableArray *)bmiddle_pic_urls{
    _bmiddle_pic_urls = bmiddle_pic_urls;
    [self setBmiddle_pic_url];
}
- (void)setOriginal_pic_urls:(NSMutableArray *)original_pic_urls{
    _original_pic_urls = original_pic_urls;
    [self setOriginal_pic_url];
}

-(void)showOriginalImage:(NSString *)original_pic_url{
    
}
-(void)showBmiddleImage:(NSString *)bmiddle_pic_url{
    [[WeiboImageBrowser sharedWeiboImageBrowser] showBmiddlePic:self andTag:self.tag];
}

@end