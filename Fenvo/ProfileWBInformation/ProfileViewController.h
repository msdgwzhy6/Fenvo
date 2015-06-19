//
//  ProfileViewController.h
//  Fenvo
//
//  Created by Caesar on 15/5/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(copy, nonatomic)NSString *access_token;
@property(copy, nonatomic)NSString *uid;
- (void)initWithComponent;
@end
