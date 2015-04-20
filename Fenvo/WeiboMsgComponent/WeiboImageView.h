//
//  WeiboImageView.h
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface WeiboImageView : UIImageView
@property(nonatomic, copy)NSString *original_pic_url;
@property(nonatomic, copy)NSString *bmiddle_pic_url;
@property(nonatomic, copy)NSMutableArray *bmiddle_pic_urls;
@property(nonatomic, copy)NSMutableArray *original_pic_urls;

-(WeiboImageView *)initWithStyleAndTag:(NSInteger)tag;
@end
