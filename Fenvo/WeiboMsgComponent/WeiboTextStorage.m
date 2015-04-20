//
//  WeiboTextStorage.m
//  Fenvo
//
//  Created by Caesar on 15/4/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboTextStorage.h"

@implementation WeiboTextStorage {
    NSMutableAttributedString *_backingStore;
}

- (id)init {
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc]init];
    }
    
    return self;
}

- (NSString *)string {
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (NSAttributedString *)attributedString {
    return _backingStore;
}

- (void)

@end
