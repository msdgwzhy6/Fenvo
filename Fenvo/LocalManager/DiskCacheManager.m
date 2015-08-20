//
//  DiskCacheManager.m
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DiskCacheManager.h"
#import "WeiboMsg.h"
#import "NSString+MD5String.h"

@implementation DiskCacheManager

+ (void)setDiskCache:(NSString *)key
              object:(id)object {
    if (!key || [key isEqualToString:@""]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:[NSString MD5:key]];
}

+ (void)getDiskCache:(NSString *)key
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSString *decription))failure {
    if (!key || [key isEqualToString:@""]) {
        failure(@"DiskCacheManager-GetDiskCache-Failure: !key || [key isEqualToString:@""]");
    }
    id object = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString MD5:key]];
    if (!object) {
        failure(@"DiskCacheManager-GetDiskCache-Failure: !object");
    }else {
        success(object);
    }
}

+ (void)compressObject:(NSArray *)arrTimeLine
           autoSaveKey:(NSString *)key {
    if (!arrTimeLine || arrTimeLine.count == 0) {
        return;
    }
    
    NSMutableArray *arrID = [[NSMutableArray alloc]init];
    for (WeiboMsg *weibo in arrTimeLine) {
        [arrID addObject:weibo.ids];
    }
    NSData *encodeData_arrID = [NSKeyedArchiver archivedDataWithRootObject:(NSArray *)[arrID copy]];
    if (key && ![key isEqualToString:@""]) {
        [DiskCacheManager setDiskCache:[NSString MD5:key] object:encodeData_arrID];
    }
}

+ (void)extractObject:(NSString *)key
              success:(void(^)(NSArray *arrTimeLine))success
              failure:(void(^)(NSString *description))failure {
    if (!key || [key isEqualToString:@""]) {
        failure(@"DiskCacheManager-ExtractObject-Failure: !key || [key isEqualToString:@""]");
    }
    [DiskCacheManager getDiskCache:[NSString MD5:key] success:^(id responseObject) {
        NSArray *arrID = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
    } failure:^(NSString *decription) {
        failure(decription);
    }];
}
@end
