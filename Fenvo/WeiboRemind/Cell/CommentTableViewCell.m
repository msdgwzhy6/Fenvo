//
//  CommentTableViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "BaseWeiboView.h"
#import "BaseHeaderView.h"
#import "WeiboLabel.h"

#import "StyleOfRemindSubviews.h"

#import "WeiboMsg.h"

@interface CommentTableViewCell()<WeiboLabelDelegate> {
 
    UIView *_mainContentView;
    
    BaseHeaderView *_header;
    WeiboLabel *_text;
    WeiboLabel *_reply_text;
    BaseWeiboView *_weiboView;
    
}
@end

@implementation CommentTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    _mainContentView = [[UIView alloc]init];
    _mainContentView.backgroundColor = [UIColor clearColor];
    _mainContentView.layer.cornerRadius = 3.0;
    _mainContentView.layer.borderWidth = 3.0;
    _mainContentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_mainContentView.layer.masksToBounds = YES;
    _mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainContentView.layer.shadowOffset = CGSizeMake(3, 3);
    _mainContentView.layer.shadowOpacity = 0.6;
    _mainContentView.layer.shadowRadius = 3.0;
    [self addSubview:_mainContentView];
    
    _header = [[BaseHeaderView alloc]init];
    [_mainContentView addSubview:_header];
    
    _text = [[WeiboLabel alloc]init];
    _text.textColor = [UIColor whiteColor];
    _text.font = [StyleOfRemindSubviews middleFont];
    _text.weiboLabelDelegate = self;
    _text.isNeedAtAndPoundSign = YES;
    [_mainContentView addSubview:_text];
    
    _reply_text = [[WeiboLabel alloc]init];
    _reply_text.textColor = [UIColor whiteColor];
    _reply_text.font = [StyleOfRemindSubviews middleFont];
    _reply_text.weiboLabelDelegate = self;
    _reply_text.isNeedAtAndPoundSign = YES;
    [_reply_text setHidden:YES];
    [_mainContentView addSubview:_reply_text];
    
    _weiboView = [[BaseWeiboView alloc]init];
    [_mainContentView addSubview:_weiboView];
    
}

- (void)setComment:(WeiboComment *)comment {

    _comment = comment;
    
    _mainContentView.frame = CGRectMake(8, 4, self.frame.size.width - 16, 0);
    CGFloat width = _mainContentView.frame.size.width - 16;
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];

    _header.frame = CGRectMake(spacing, spacing, width, 30);
    _header.username.text = comment.user.name;
    _header.createAt.text = comment.created_at;
    _header.source.text = comment.source;
    [_header.avatar sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
    CGFloat headerY = CGRectGetMaxY(_header.frame) + spacing;
    
    
    CGSize textSize = [comment.text
                           boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[StyleOfRemindSubviews middleFont]}
                           context:nil].size;
    CGRect textRect = CGRectMake(spacing, headerY, width, textSize.height);
    _text.frame = textRect;
    [_text setEmojiText:comment.text];
    CGFloat textY = CGRectGetMaxY(_text.frame) + spacing;
    
    
    if (comment.reply_comment && ![comment.reply_comment isEqual:@""]) {
        
        CGSize replySize = [comment.reply_comment.text
                            boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:WBStatusCellDetailFont}
                            context:nil].size;
        CGRect replyRect = CGRectMake(spacing, textY, width, replySize.height);
        _reply_text.frame = replyRect;
        [_reply_text setEmojiText:comment.reply_comment.text];
        [_reply_text setHidden:NO];
        textY = CGRectGetMaxY(_reply_text.frame) + spacing;
        
    }
    
    
    _weiboView.frame = CGRectMake(spacing, textY, width, [StyleOfRemindSubviews baseWeiboHeight]);
    if (comment.weiboMsg.thumbnail_pic) {
        [_weiboView.image sd_setImageWithURL:[NSURL URLWithString:comment.weiboMsg.thumbnail_pic]];
    }else if(_comment.weiboMsg.retweeted_status && _comment.weiboMsg.retweeted_status.thumbnail_pic){
        [_weiboView.image sd_setImageWithURL:[NSURL URLWithString:comment.weiboMsg.retweeted_status.thumbnail_pic]];
    }else {
        [_weiboView.image sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
    }
    if (comment.weiboMsg.retweeted_status) {
        _weiboView.detail.text = comment.weiboMsg.retweeted_status.wbDetail;
    }else {
        _weiboView.detail.text = comment.weiboMsg.wbDetail;
    }
    _weiboView.username.text = comment.weiboMsg.user.name;
    
    
    CGFloat height = CGRectGetMaxY(_weiboView.frame) + spacing;
    _mainContentView.frame = CGRectMake(8, 8, self.frame.size.width - 16, height);
    CGFloat mainContentViewHeight = CGRectGetMaxY(_mainContentView.frame) + 8;
    
    
    comment.height = @(mainContentViewHeight);
}



@end