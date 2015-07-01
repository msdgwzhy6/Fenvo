//
//  WeiboAvatarView.m
//  Fenvo
//
//  Created by Caesar on 15/4/1.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboAvatarView.h"
#import "ProfileViewController.h"
#import "MainViewController.h"
@interface WeiboAvatarView(){
    ProfileViewController *_profileVC;
}
@end
@implementation WeiboAvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setStyle{
    //set the style of avatar
    self.layer.cornerRadius = 20.0;
    self.layer.masksToBounds = YES;
    self.hidden = NO;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = RGBACOLOR(220, 220, 220, 0.5);
}

-(void)setUid:(long long)uid {
    //set user's uid
    _uid = uid;
    
    /*
    //add gesture
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserProfile)];
    [self addGestureRecognizer:tap];
     */
}
- (void)setUserInfo:(WeiboUserInfo *)userInfo {
    //set userInfo
    _userInfo = userInfo;
    _uid = _userInfo.ids;
    
    //add gesture
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserProfile)];
    [self addGestureRecognizer:tap];
}

- (void)openUserProfile{
    if (_userInfo) {
        _profileVC = [[ProfileViewController alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_profileVC refreshUserProfileWithUser:_userInfo];
        });
        [[self viewController].navigationController pushViewController:_profileVC animated:YES];
    }else {
        NSLog(@"set uidss :%lld",_uid);
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[MainViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
