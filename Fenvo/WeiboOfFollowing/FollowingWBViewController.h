//
//  FollowingWBViewController.h
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"
@interface FollowingWBViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSString *access_token;
@end
