//
//  STTweetLabel.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

typedef enum {
    WeiboAccount = 0,
    WeiboHashtag,
    WeiboLink
} WeiboHotWord;

@interface WeiboLabel : UILabel

@property (nonatomic, strong) NSArray *validProtocols;
@property (nonatomic, assign) BOOL leftToRight;
@property (nonatomic, assign) BOOL textSelectable;
@property (nonatomic, strong) UIColor *selectionColor;
@property (nonatomic, copy) void (^detectionBlock)(WeiboHotWord hotWord, NSString *string, NSString *protocol, NSRange range);

- (void)setAttributes:(NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes hotWord:(WeiboHotWord)hotWord;

- (NSDictionary *)attributes;
- (NSDictionary *)attributesForHotWord:(WeiboHotWord)hotWord;

- (CGSize)suggestedFrameSizeToFitEntireStringConstraintedToWidth:(CGFloat)width;

@end
