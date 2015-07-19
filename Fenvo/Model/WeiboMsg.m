//
//  WeiboMsg.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboMsg.h"
#import "WeiboGeoInfo.h"
#import "WeiboMsg.h"
#import "WeiboUserInfo.h"
#import "WeiboVisibleInfo.h"


@implementation WeiboMsg

@dynamic attitudes_count;
@dynamic bmiddle_pic;
@dynamic comments_count;
@dynamic created_at;
@dynamic favorited;
@dynamic height;
@dynamic ids;
@dynamic idstr;
@dynamic mid;
@dynamic reposts_count;
@dynamic source;
@dynamic thumbnail_pic;
@dynamic truncated;
@dynamic wbDetail;
@dynamic pic_urls;
@dynamic pic_ids;
@dynamic original_pic_urls;
@dynamic bmiddle_pic_urls;
@dynamic original_pic;
@dynamic geo;
@dynamic retweeted_status;
@dynamic user;
@dynamic visible;

+ (WeiboMsg *)createByDictionary:(NSDictionary *)dic {
    WeiboMsg *weiboMsg = [WeiboMsg createdInCoreData];
    
    if ([dic allKeys].count > 0) {
        weiboMsg.ids = [NSNumber numberWithLongLong:[dic[@"id"] longLongValue]];
        weiboMsg.mid = [NSNumber numberWithLongLong:[dic[@"mid"]longLongValue]];
        weiboMsg.idstr = dic[@"idstr"];
        weiboMsg.wbDetail = dic[@"text"];
        weiboMsg.source = dic[@"source"];
        weiboMsg.favorited = [NSNumber numberWithBool:[dic[@"favorited"]boolValue]];
        weiboMsg.truncated = [NSNumber numberWithBool:[dic[@"truncated"]boolValue]];
        weiboMsg.thumbnail_pic = dic[@"thumbnail_pic"];
        weiboMsg.bmiddle_pic = dic[@"bmiddle_pic"];
        weiboMsg.original_pic = dic[@"original_pic"];
        //
        //NSDictionary *geos = dic[@"geo"];
        //if (geos) {
        //   self.geo = [[WeiboGeoInfo alloc]initWithDictionary:geos];
        // }
        //
        NSDictionary *user = dic[@"user"];
        weiboMsg.user = [WeiboUserInfo createdByDictionary:user];
        //
        NSDictionary *retweeted_weibo = dic[@"retweeted_status"];
        if (retweeted_weibo) {
            weiboMsg.retweeted_status = [WeiboMsg createByDictionary:retweeted_weibo];
        }
        // attitudes_count	int	表态数
        weiboMsg.attitudes_count = [NSNumber numberWithInteger:[dic[@"attitudes_count"]integerValue]];
        weiboMsg.reposts_count = [NSNumber numberWithInteger:[dic[@"reposts_count"]integerValue]];
        weiboMsg.comments_count = [NSNumber numberWithInteger:[dic[@"comments_count"]integerValue]];
        //
        NSDictionary *visible = dic[@"visible"];
        weiboMsg.visible = [WeiboVisibleInfo createdByDictionary:visible];
        //
        weiboMsg.pic_ids = dic[@"pic_ids"];
        
        NSArray *pic_url= dic[@"pic_urls"];
        
        weiboMsg.pic_urls = [WeiboMsg getThumbnailUrl:pic_url];
        weiboMsg.original_pic_urls = [WeiboMsg getOriginalPicUrl:weiboMsg.pic_urls];
        weiboMsg.bmiddle_pic_urls = [WeiboMsg getBmiddlePicUrl:weiboMsg.pic_urls];
        
        NSString *timeStr = dic[@"created_at"];
        weiboMsg.created_at = [WeiboMsg getTimeString:timeStr];
        NSString *wbSource = dic[@"source"];
        wbSource = [WeiboMsg getSourceString:wbSource];
        if (wbSource != nil && ![wbSource isEqualToString:@""]) {
            weiboMsg.source = [NSString stringWithFormat:@"来自 %@", wbSource];
        }else{
            weiboMsg.source = @"";
        }
    }
    
    return weiboMsg;
}

+ (WeiboMsg *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboMsg *weiboMsg = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboMsg class]) inManagedObjectContext:managedObjectContext];
    
    return weiboMsg;
}


//------------------数据转换部分--------------------
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


+ (NSString *) getThumbnailUrl:(NSArray *)pic_urls {
    
    NSString *thumbailUrl = @"";
    
    for (int i = 0; i < pic_urls.count; i++) {
        NSDictionary *dict = pic_urls[i];
        NSString *pic_url = dict[@"thumbnail_pic"];
        
        if (i == pic_urls.count - 1)
            thumbailUrl = [thumbailUrl stringByAppendingString:pic_url];
        else
            thumbailUrl = [NSString stringWithFormat:@"%@,",[thumbailUrl stringByAppendingString:pic_url]];
        
    }
    
    return [thumbailUrl copy];
}

+ (NSString *) getOriginalPicUrl:(NSString *)thumbnail_pic_urls{
    
    NSString *url = thumbnail_pic_urls;
    url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    
    return [url copy];
}

+ (NSString *) getBmiddlePicUrl:(NSString *)thumbnail_pic_urls{
    
    NSString *url = thumbnail_pic_urls;
    url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    return [url copy];
}
@end
