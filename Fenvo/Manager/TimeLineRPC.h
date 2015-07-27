//
//  TimeLineRPC.h
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Public_TimeLine @"https://api.weibo.com/2/statuses/public_timeline.json"
#define Home_TimeLine   @"https://api.weibo.com/2/statuses/home_timeline.json"

typedef void(^publicTimeLineBlock)(NSArray *timeLineArr, long long since_id, long long max_id, long long previous_cursor, long long next_cursor);

typedef void(^homeTimeLineBlock)(NSArray *timeLineArr, long long since_id, long long max_id, long long previous_cursor, long long next_cursor);

typedef void(^failureBlock)(NSString *desc, NSError *error);

@interface TimeLineRPC : NSObject

+ (void)getPublicTimeLineSuccess:(publicTimeLineBlock)success
                         failure:(failureBlock)failure;

+ (void)getHomeTimeLineSuccess:(homeTimeLineBlock)success
                       failure:(failureBlock)failure;

@end
