//
//  BottomView.h
//  Fenvo
//
//  Created by Caesar on 15/8/13.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"

@interface BottomView : UIView
@property (nonatomic, weak)UIButton *comment;
@property (nonatomic, weak)UIButton *like;
@property (nonatomic, weak)UIButton *repost;

@property (nonatomic, strong)WeiboMsg *weiboMsg;
@end
