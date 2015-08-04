//
//  RemindBaseTableViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboLabel.h"
#import "WeiboAvatarView.h"
#import "WeiboComment.h"


@interface RemindBaseTableViewCell : UITableViewCell

//数据模型对象

@property (nonatomic, strong)WeiboComment *comment;
//背景框
@property(nonatomic, strong)UIView *containView;
@property(nonatomic, strong)WeiboAvatarView *avatar;
@property(nonatomic, strong)UILabel *userName;
@property(nonatomic, strong)UILabel *createTime;
@property(nonatomic, strong)UILabel *source;
@property(nonatomic, strong)WeiboLabel *wbCommentText;
@property(nonatomic, strong)WeiboLabel *wbCommentDetail;


@end
