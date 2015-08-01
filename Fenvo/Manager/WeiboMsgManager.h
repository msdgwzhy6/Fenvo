//
//  WeiboMsgManager.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeiboMsgManager : NSObject<NSFetchedResultsControllerDelegate>


+ (void)saveInCoreData;
@end
