//
//  FollowingWBViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/6/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingWBViewCell.h"
@interface FollowingWBViewCell(){
    UIButton *_favouriteBtn;
    BOOL _isFavourite;
}
@end
@implementation FollowingWBViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _favouriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favouriteBtn.tag = 999;
        _favouriteBtn.titleLabel.font = WBStatusButtonFont;
        [_favouriteBtn setTitleColor:RGBACOLOR(30, 40, 50, 1) forState:UIControlStateNormal];
        [_favouriteBtn setTitle:@"Star" forState:UIControlStateNormal];
        [self.containView addSubview:_favouriteBtn];
        [_favouriteBtn addTarget:self action:@selector(isFavourite) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg{
    [super setWeiboMsg:weiboMsg];
    _isFavourite = weiboMsg.favorited;
    if (_isFavourite == true) {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Expression_67"] forState:UIControlStateNormal];
    }else {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Expression_68"] forState:UIControlStateNormal];
    }
    _favouriteBtn.frame = CGRectMake(self.containView.frame.size.width - 55, 5, 50, 20);
}

- (void)isFavourite {
    _isFavourite = !_isFavourite;
    if (_isFavourite == true) {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Expression_67"] forState:UIControlStateNormal];
    }else {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Expression_68"] forState:UIControlStateNormal];
    }
}
@end
