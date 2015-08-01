//
//  WeiboStoreManager.h
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^timeLineBlock)(NSArray *timeLineArr, long long max_id);
typedef void(^failuresBlock)(NSString *desc);

@interface WeiboStoreManager : NSObject

+ (NSArray *)getWeiboMsgInCoreData;

+ (void)queryTimeLineWithMaxId:(NSNumber *)max_id
                       success:(timeLineBlock)success
                       failure:(failuresBlock)failure;


+ (void)queryAllWeiboStoreSucces:(timeLineBlock)success
                         failure:(failuresBlock)failure;

+ (void)removeAllWeiboStore;
+ (void)removeWeiboMsg:(long long)weiboID;

+ (void)saveInCoreData;
@end
