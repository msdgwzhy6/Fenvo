//
//  WeiboComment.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboComment;

@interface WeiboComment : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * ids;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) WeiboComment *reply_comment;
@property (nonatomic, retain) NSManagedObject *weiboMsg;

@end