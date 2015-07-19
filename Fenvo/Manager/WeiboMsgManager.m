//
//  WeiboMsgManager.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboMsgManager.h"
#import "WeiboMsg.h"

@implementation WeiboMsgManager

+ (NSArray *)getWeiboMsgInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    /**************
     通过CoreData获取sqlite中的WeiboMsg数据
     *************/
    
    //通过实体名进行请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([WeiboMsg class])];
    
    //定义分组与排序规则：通过weiboMsg.ids进行排序
    NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"ids" ascending:YES];
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
    
    NSArray *sections = [fetchedResultsController sections];
    NSLog(@"getWeiboMsgInCoreData sections : %@",sections);
    
    
    NSArray *weiboMsgArr = [fetchedResultsController fetchedObjects];
    
    return weiboMsgArr;
}

@end
