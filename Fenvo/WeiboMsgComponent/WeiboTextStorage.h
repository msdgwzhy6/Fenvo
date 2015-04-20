//
//  WeiboTextStorage.h
//  Fenvo
//
//  Created by Caesar on 15/4/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTextStorage : NSTextStorage

- (NSAttributedString *)attributedString;

- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
- (void)removeAttribute:(NSString *)name range:(NSRange)range;

@end
