//
//  CommentRPC.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CommentRPC.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboComment.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CommentRPC

+ (void)getCommentWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
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
        
        [manager GET:Comment_ToMe
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:YES];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });
}

+ (void)getCommentWithID:(NSNumber *)ID success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        //http请求头应该添加text/plain。接受类型内容无text/plain
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSDictionary *dict;
        dict = @{@"access_token":appDelegate.access_token, @"id":ID};
        
        [manager GET:Comment_Show
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:NO];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });

}

+ (void)getCommentWithID:(NSNumber *)ID SinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        //http请求头应该添加text/plain。接受类型内容无text/plain
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSDictionary *dict;
        if (since_id == nil && max_id == nil) {
            dict = @{@"access_token":appDelegate.access_token, @"id":ID};
        }else if(since_id != nil && max_id == nil){
            dict = @{@"access_token":appDelegate.access_token, @"id":ID, @"since_id":since_id};
        }else if(since_id == nil && max_id != nil){
            dict = @{@"access_token":appDelegate.access_token, @"id":ID, @"max_id":max_id};
        }
        
        [manager GET:Comment_ToMe
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:NO];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });
}

+ (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"comments\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"hasvi"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}

@end
