//
//  CommentRPC.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Comment_ToMe @"https://api.weibo.com/2/comments/to_me.json"

typedef void(^requestCommentSuccessBlock)(NSArray *commentArr, long long since_id, long long max_id);
typedef void(^requestCommentFailureBlock)(NSString *desc, NSError *error);

@interface CommentRPC : NSObject

+ (void)getCommentWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id
                      success:(requestCommentSuccessBlock)success
                      failure:(requestCommentFailureBlock)failure;


@end
