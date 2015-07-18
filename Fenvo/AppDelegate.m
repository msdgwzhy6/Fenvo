//
//  AppDelegate.m
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate (){
    MainViewController *_mainVC;
}
@property (strong, nonatomic) ViewController *loginView;
@end

@implementation AppDelegate
@synthesize access_token = _access_token;
@synthesize uid = _uid;
@synthesize expires_in = _expires_in;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                               name:WBNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,RGBACOLOR(250, 143, 5, 1),UITextAttributeTextColor, nil]];
    }
    
    [self loginStateChange:nil];
    
    
    return YES;
}

- (void)loginStateChange:(NSNotification *)notification {
    UINavigationController *nav = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults synchronize];
    NSString *access_token = [userDefaults stringForKey:@"access_token"];
    NSString *uid = [userDefaults stringForKey:@"uid"];
    if (access_token) {
        if (_mainVC == nil) {
            _mainVC = [[MainViewController alloc]init];
            _mainVC.selectedIndex = 0;
            nav = [[UINavigationController alloc]initWithRootViewController:_mainVC];
        }else{
            nav = _mainVC.navigationController;
        }
        _access_token = access_token;
        _uid = uid;
        NSDictionary *userInfo = @{@"token":access_token,@"uid":uid};
        [[NSNotificationCenter defaultCenter]postNotificationName:WBNOTIFICATION_DOWNLOADDATA object:nil userInfo:userInfo];
    }else{
  
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        
        if (_mainVC == nil) {
            _mainVC = [[MainViewController alloc]init];
            _mainVC.selectedIndex = 0;
            nav = [[UINavigationController alloc]initWithRootViewController:_mainVC];
        }else{
            nav = _mainVC.navigationController;
        }
        NSString *token = [notification.userInfo objectForKey:@"token"];
        NSString *uid = [notification.userInfo objectForKey:@"uid"];
        _access_token = token;
        _uid = uid;
        
        [userDefaults setObject: token forKey:@"access_token"];
        [userDefaults setObject: uid forKey:@"uid"];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:WBNOTIFICATION_DOWNLOADDATA object:nil userInfo:notification.userInfo];
        
        
    }
    else{
        _mainVC = nil;
        ViewController *loginVC = [[ViewController alloc]init];
        nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        loginVC.title = @"登陆授权";
           }
    }
    self.window.rootViewController = nav;

    [nav setNavigationBarHidden:YES];
    [nav setNavigationBarHidden:NO];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "DC.Fenvo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Fenvo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fenvo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
