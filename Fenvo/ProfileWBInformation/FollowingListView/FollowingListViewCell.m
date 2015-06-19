//
//  FollowingListViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/6/7.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingListViewCell.h"

@implementation FollowingListViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _relationBtn.layer.cornerRadius = 5.0;
    _relationBtn.layer.masksToBounds = YES;
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"followingCell"];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUserInfo:(WeiboUserInfo *)userInfo {
    _avatar.image = userInfo.user_avatar;
    
    _userName.text = userInfo.screen_name;
    
    _userDescription.text = userInfo.descriptions;
    
    
    
    if (userInfo.follow_me == true) {
        [self.relationBtn setTitle:@"Friend" forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:RGBACOLOR(35, 206, 80, 1)];
    }else {
        [self.relationBtn setTitle:@"Following" forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (IBAction)unfollowing:(id)sender {
}

@end
