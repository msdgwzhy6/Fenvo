//
//  WeiboMsg.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboGeoInfo, WeiboMsg, WeiboUserInfo, WeiboVisibleInfo;

@interface WeiboMsg : NSManagedObject

@property (nonatomic, retain) NSNumber * attitudes_count;
@property (nonatomic, retain) NSString * bmiddle_pic;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * ids;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * reposts_count;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * thumbnail_pic;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) NSString * wbDetail;
@property (nonatomic, retain) NSString * pic_urls;
@property (nonatomic, retain) NSString * pic_ids;
@property (nonatomic, retain) NSString * original_pic_urls;
@property (nonatomic, retain) NSString * bmiddle_pic_urls;
@property (nonatomic, retain) NSString * original_pic;
@property (nonatomic, retain) WeiboGeoInfo *geo;
@property (nonatomic, retain) WeiboMsg *retweeted_status;
@property (nonatomic, retain) WeiboUserInfo *user;
@property (nonatomic, retain) WeiboVisibleInfo *visible;

+ (WeiboMsg *)createByDictionary:(NSDictionary *)dic;
@end
