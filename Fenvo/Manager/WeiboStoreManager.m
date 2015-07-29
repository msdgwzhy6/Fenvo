//
//  WeiboStoreManager.m
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboStoreManager.h"
#import "WeiboStore.h"

@implementation WeiboStoreManager

+ (NSArray *)getWeiboMsgInCoreData {
UIApplication *application = [UIApplication sharedApplication];
id delegate = application.delegate;
NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];

/**************
 通过CoreData获取sqlite中的WeiboMsg数据
 *************/

//通过实体名进行请求
NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([WeiboStore class])];

//定义分组与排序规则：通过weiboMsg.ids进行排序
NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"weiboID" ascending:YES];
[fetchRequest setSortDescriptors:@[sortDesciptor]];

//请求结果进行转换，转换为WeiboMsg数据对象
NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                                          managedObjectContext:managedObjectContext
                                                                                            sectionNameKeyPath:nil
                                                                                                     cacheName:nil];

NSError *error;
if ([fetchedResultsController performFetch:&error]) {
    NSLog(@"%@", [error localizedDescription]);
}


NSArray *weiboMsgArr = [fetchedResultsController fetchedObjects];

    NSMutableArray *weiboArr = [[NSMutableArray alloc]init];
    for (WeiboStore *weiboStore in weiboMsgArr) {
        [weiboArr addObject:weiboStore.weiboMsg];
    }
    
    
    return [weiboArr copy];
    
}

+ (NSArray *)queryAllWeiboStore {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    [WeiboStoreManager sortArray:arr];
    
    NSMutableArray *weiboArr = [[NSMutableArray alloc]init];
    for (WeiboStore *weiboStore in arr) {
        [weiboArr addObject:weiboStore.weiboMsg];
    }
    
    
    return [weiboArr copy];
}

+ (NSArray *)sortArray:(NSArray *)array {
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        WeiboStore *obj_1 = (WeiboStore *)obj1;
        WeiboStore *obj_2 = (WeiboStore *)obj2;
        NSComparisonResult result = [obj_1.weiboID compare:obj_2.weiboID];
        return result;
    }];
    return sortArray;
}

+ (void)removeAllWeiboStore {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore in arr) {
        [context deleteObject:weiboStore];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboStoreManager--delete all object success");
    }else {
        NSLog(@"WeiboStoreManager--delete all object fail");
    }
    
}

+ (void)removeWeiboMsg:(long long)weiboID {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weiboID = %ld",weiboID];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore in result) {
        [context deleteObject:weiboStore];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboStoreManager--delete object success");
    }else {
        NSLog(@"WeiboStoreManager--delete object fail");
    }
    
}


/**
 *  暂时基本不需要，因为没有需要改动的地方
 *
 *  @param weiboStore <#weiboStore description#>
 */
+ (void)modifiedWeibo:(WeiboStore *)weiboStore {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weiboID = %ld",weiboStore.weiboID.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore_query in result) {

    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete object success");
    }else {
        NSLog(@"WeiboMsgManager--delete object fail");
    }
}

+ (void)saveInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}


@end
