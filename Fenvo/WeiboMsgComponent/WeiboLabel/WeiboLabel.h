//
//  MLEmojiLabel.h
//  MLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TTTAttributedLabel.h"


typedef NS_OPTIONS(NSUInteger, WeiboLabelLinkType) {
    MLEmojiLabelLinkTypeURL = 0,
    MLEmojiLabelLinkTypePhoneNumber,
    MLEmojiLabelLinkTypeEmail,
    MLEmojiLabelLinkTypeAt,
    MLEmojiLabelLinkTypePoundSign,
};


@class WeiboLabel;
@protocol WeiboLabelDelegate <NSObject>

@optional
- (void)mlEmojiLabel:(WeiboLabel*)emojiLabel didSelectLink:(NSString*)link withType:(WeiboLabelLinkType)type;


@end

@interface WeiboLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式

@property (nonatomic, weak) id<WeiboLabelDelegate> weiboLabelDelegate; //点击连接的代理方法

@property (nonatomic, copy) NSString *emojiText; //设置处理文字

@end
