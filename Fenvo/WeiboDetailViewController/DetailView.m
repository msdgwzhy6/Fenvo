//
//  DetailView.m
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DetailView.h"
#import "WeiboLabel.h"
#import "BaseHeaderView.h"
#import "BaseWeiboView.h"
#import "BaseImagesView.h"
#import "BaseButtonView.h"

#import "StyleOfRemindSubviews.h"

@interface DetailView()<WeiboLabelDelegate>{
    BaseHeaderView *_header;
    WeiboLabel *_text;
    WeiboLabel *_retweeted_text;
    BaseImagesView *_imagesView;
    UIView *_retweetedContentView;
    BaseButtonView *_buttonView;
}
@end
@implementation DetailView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)initSubviews {
    _header = [[BaseHeaderView alloc]init];
    _header.customBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _header.customBtn.layer.borderWidth = 1.0f;
    _header.customBtn.layer.cornerRadius = 3.0;
    _header.customBtn.layer.masksToBounds = YES;
    [_header.customBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_header.customBtn addTarget:self action:@selector(customEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_header];
    
    _text = [[WeiboLabel alloc]init];
    _text.textColor = [UIColor whiteColor];
    _text.font = [StyleOfRemindSubviews middleFont];
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping;
    _text.weiboLabelDelegate = self;
    _text.isNeedAtAndPoundSign = YES;
    [self addSubview:_text];
    
    _retweeted_text = [[WeiboLabel alloc]init];
    _retweeted_text.textColor = [UIColor whiteColor];
    _retweeted_text.font = [StyleOfRemindSubviews middleFont];
    _retweeted_text.numberOfLines = 0;
    _retweeted_text.lineBreakMode = NSLineBreakByCharWrapping;
    _retweeted_text.weiboLabelDelegate = self;
    _retweeted_text.isNeedAtAndPoundSign = YES;
    [_retweeted_text setHidden:YES];
    [_retweetedContentView addSubview:_retweeted_text];
    
    _buttonView = [[BaseButtonView alloc]init];
    [self addSubview:_buttonView];
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg {
    _weiboMsg = weiboMsg;
    
    self.frame = CGRectMake(12, 4, self.frame.size.width - 24, 0);
    CGFloat width = self.frame.size.width - 16;
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];
    
    _header.frame = CGRectMake(spacing, spacing, width, 30);
    _header.username.text = weiboMsg.user.name;
    _header.createAt.text = weiboMsg.created_at;
    _header.source.text = weiboMsg.source;
    [_header.avatar sd_setImageWithURL:[NSURL URLWithString:weiboMsg.user.profile_image_url]];
    [_header.avatar setUserInfo:weiboMsg.user];
    CGFloat headerY = CGRectGetMaxY(_header.frame) + spacing;
    
    
    CGSize textSize = [weiboMsg.wbDetail
                       boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@ "HYQiHei-BEJ" size:15.0]}
                       context:nil].size;
    CGRect textRect = CGRectMake(spacing, headerY, width, textSize.height);
    _text.frame = textRect;
    [_text setEmojiText:weiboMsg.wbDetail];
    CGFloat textY = CGRectGetMaxY(_text.frame) + spacing;
    
    if (weiboMsg.retweeted_status){
        CGSize retweeted_textSize = [weiboMsg.retweeted_status.wbDetail
                           boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@ "HYQiHei-BEJ" size:15.0]}
                           context:nil].size;
        CGRect retweeted_textRect = CGRectMake(spacing, headerY, width, retweeted_textSize.height);
        _retweeted_text.frame = retweeted_textRect;
        [_retweeted_text setEmojiText:weiboMsg.retweeted_status.wbDetail];
        //textY = CGRectGetMaxY()
        if (weiboMsg.retweeted_status.pic_urls) {
            BaseImagesView *imagesView = [[BaseImagesView alloc]init];
            [self addSubview:imagesView];
            imagesView.frame = CGRectMake(spacing, textY, width, 0);
            imagesView.thumbnailUrl = weiboMsg.retweeted_status.pic_urls;
            imagesView.frame = CGRectMake(spacing, textY, width, imagesView.imagesHeight);
            textY = CGRectGetMaxY(imagesView.frame) + spacing;
        }
    }else if(weiboMsg.pic_urls){
        BaseImagesView *imagesView = [[BaseImagesView alloc]init];
        [self addSubview:imagesView];
        imagesView.frame = CGRectMake(spacing, textY, width, 0);
        imagesView.thumbnailUrl = weiboMsg.pic_urls;
        imagesView.frame = CGRectMake(spacing, textY, width, imagesView.imagesHeight);
        textY = CGRectGetMaxY(imagesView.frame) + spacing;
    }
    
    _buttonView.frame = CGRectMake(spacing, textY, width, 20);
    
    CGFloat height = CGRectGetMaxY(_buttonView.frame) + spacing;
    
    self.frame = CGRectMake(12, 8, self.frame.size.width - 24, height);
    //CGFloat mainContentViewHeight = CGRectGetMaxY(_mainContentView.frame) + spacing;
    //_atMeStore.height = @(mainContentViewHeight);
    
}
@end
