//
//  FollowingWBViewController.h
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"
#import "WeiboLabel.h"
#import "ANBlurredTableView.h"
#import "AMScrollingNavbarViewController.h"

@interface FollowingWBViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,WeiboLabelDelegate>
@property(strong, nonatomic)NSString *access_token;
@property(strong, nonatomic)ANBlurredTableView *tableView;
@end
