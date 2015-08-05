//
//  StringFormatTool.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "StringFormatTool.h"

@implementation StringFormatTool

+ (NSString *) getTimeString : (NSString *)timeStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *input = [inputFormatter dateFromString:timeStr];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *output = [outputFormatter stringFromDate:input];
    return output;
}

+ (NSString *) getSourceString:(NSString *)src{
    if(src.length > 0){
        NSString *tmpStr = [[NSString alloc]init];
        NSRange range = [src rangeOfString:@">"];
        tmpStr = [src substringFromIndex:range.location + 1];
        range = [tmpStr rangeOfString:@"</a>"];
        src = [tmpStr substringToIndex:range.location];
    }
    return src;
}

@end
