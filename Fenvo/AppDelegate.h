//
//  AppDelegate.h
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//微博 access_token 与微博 uid 以及微博 Oauth2.0 认证时长 expires_in

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *expires_in;

@end

