//
//  FollowingListViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/6/7.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowerListViewCell.h"

@implementation FollowerListViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _relationBtn.layer.cornerRadius = 5.0;
    _relationBtn.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUserInfo:(WeiboUserInfo *)userInfo {
    _avatar.image = userInfo.user_avatar;
    
    _userName.text = userInfo.screen_name;
    
    _userDescription.text = userInfo.descriptions;
    
    
    
    if (userInfo.following == true) {
        [self.relationBtn setTitle:@"Friend" forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:RGBACOLOR(35, 206, 80, 1)];
    }else {
        [self.relationBtn setTitle:@"Follower" forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (IBAction)following:(id)sender {
}


@end
