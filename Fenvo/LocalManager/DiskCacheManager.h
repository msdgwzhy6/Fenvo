//
//  DiskCacheManager.h
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCacheManager : NSObject
+ (void)setDiskCache:(NSString *)key
              object:(id)object;
+ (void)getDiskCache:(NSString *)key
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSString *decription))failure;

+ (void)compressObject:(NSArray *)arrTimeLine
           autoSaveKey:(NSString *)key;
+ (void)extractObjectWithKey:(NSString *)key
                     success:(void(^)(NSArray *arrTimeLine, NSNumber *since_id, NSNumber *max_id))success
                     failure:(void(^)(NSString *description))failure;
@end
