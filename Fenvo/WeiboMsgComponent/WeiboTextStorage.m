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

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range{
    [self beginEditing];
    [_backingStore addAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)removeAttribute:(NSString *)name range:(NSRange)range{
    [self beginEditing];
    [_backingStore removeAttribute:name range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:(NSTextStorageEditedCharacters | NSTextStorageEditedAttributes) range:range changeInLength:str.length - range.length];
    [self endEditing];
}

#pragma mark Private methods

- (BOOL)isValidRange:(NSRange)range isString:(NSMutableAttributedString *)str{
    if (range.location < str.length && range.location + range.length <= str.length) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
