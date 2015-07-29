//
//  WeiboStoreManager.h
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboStoreManager : NSObject

+ (NSArray *)getWeiboMsgInCoreData;

+ (NSArray *)queryAllWeiboStore;
+ (void)removeAllWeiboStore;
+ (void)removeWeiboMsg:(long long)weiboID;

+ (void)saveInCoreData;
@end
