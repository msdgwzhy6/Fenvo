//
//  ProfileViewController.h
//  Fenvo
//
//  Created by Caesar on 15/5/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboUserInfo.h"

@interface ProfileViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(copy, nonatomic)NSString *access_token;
@property(copy, nonatomic)NSString *uid;
- (void)initWithComponent;

//get others user profile
//using the uid. Forbidden Now.
- (void)downloadUserProfileWithUid:(long long)uid;
//using the userInfo that got from the weiboMsg
- (void)refreshUserProfileWithUser:(WeiboUserInfo *)userInfo;

- (id)init;
@end
