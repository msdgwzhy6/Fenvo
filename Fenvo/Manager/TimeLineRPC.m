//
//  TimeLineRPC.m
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "TimeLineRPC.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboMsg.h"
#import "AFHTTPRequestOperationManager.h"

@implementation TimeLineRPC


+ (void)getPublicTimeLineWithSinceId:(NSNumber *)since_id success:(publicTimeLineBlock)success failure:(failureBlock)failure{
    NSMutableArray *weiboMsgArray = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
    //http请求头应该添加text/plain。接受类型内容无text/plain
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    NSString *getPublicTimeLine = Public_TimeLine;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    NSDictionary *dict;
    if (since_id == nil) {
        dict = [NSDictionary
                 dictionaryWithObject:appDelegate.access_token
                 forKey:@"access_token"];
    }
    
    [manager GET:getPublicTimeLine
      parameters:dict
         success:^(AFHTTPRequestOperation *operation, id responserObject){
             NSError *error;
             NSData *jsonDatas = [responserObject
                                  JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                  error:&error];
             NSString *jsonStrings = [[NSString alloc]
                                      initWithData:jsonDatas
                                      encoding:NSUTF8StringEncoding];
             
             NSDictionary *dict = [jsonStrings objectFromJSONString];
             long long since_id = [dict[@"since_id"] longLongValue];
             long long max_id = [dict[@"max_id"] longLongValue];
             long long previous_cursor = [dict[@"previous_cursor"] longLongValue];
             long long next_cursor = [dict[@"next_cursor"] longLongValue];
             
             jsonStrings = [TimeLineRPC getNormalJSONString:jsonStrings];
             
             NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
             if (weiboMsgDictionary.count > 0) {
                 
                 for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                     NSDictionary *dict = weiboMsgDictionary[i];
                     WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict];
                     [weiboMsgArray addObject:weiboMsg];
                     
                 }
             }
             
             success([weiboMsgArray copy], since_id, max_id, previous_cursor, next_cursor);
             
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
             failure(@"Get public timeline failure", error);
         }];
    
    
}


+ (void)getHomeTimeLineWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id success:(homeTimeLineBlock)success failure:(failureBlock)failure{
    
    NSMutableArray *weiboMsgArray = [[NSMutableArray alloc]init];
    
    //http请求头应该添加text/plain。接受类型内容无text/plain
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *dict;
    if (since_id == nil && max_id == nil) {
        dict = @{@"access_token":appDelegate.access_token};
    }else if(since_id != nil && max_id == nil){
        dict = @{@"access_token":appDelegate.access_token, @"since_id":since_id};
    }else if(since_id == nil && max_id != nil){
        dict = @{@"access_token":appDelegate.access_token, @"max_id":max_id};
    }
    
    
    
    [manager GET:Home_TimeLine
      parameters:dict
         success:^(AFHTTPRequestOperation *operation, id responserObject){
             NSError *error;
             NSData *jsonDatas = [responserObject
                                  JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                  error:&error];
             NSString *jsonStrings = [[NSString alloc]
                                      initWithData:jsonDatas
                                      encoding:NSUTF8StringEncoding];
             
             NSDictionary *dict = [jsonStrings objectFromJSONString];
             long long since_id = [dict[@"since_id"] longLongValue];
             long long max_id = [dict[@"max_id"] longLongValue];
             long long previous_cursor = [dict[@"previous_cursor"] longLongValue];
             long long next_cursor = [dict[@"next_cursor"] longLongValue];
             
             jsonStrings = [self getNormalJSONString:jsonStrings];
             
             
             NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
             if (weiboMsgDictionary.count > 0) {
                 
                 for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                     NSDictionary *dict = weiboMsgDictionary[i];
                     WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict];
                     [weiboMsgArray addObject:weiboMsg];
                     
                 }
             }
             
             success(weiboMsgArray, since_id, max_id, previous_cursor, next_cursor);

             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error){
             failure(@"Get home timeline failure.",error);
         }];
}



#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

+ (NSString *)getNormalJSONString:(NSString *)jsonStrings{

    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}

+ (NSString *)getRefreshJSONString: (NSString *)jsonStrings {
    NSDictionary *dict = [jsonStrings objectFromJSONString];
    long long since_id = [dict[@"since_id"] longLongValue];
    long long previous_cursor = [dict[@"previous_cursor"] longLongValue];
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}
@end
