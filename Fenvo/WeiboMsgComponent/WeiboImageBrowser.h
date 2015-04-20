//
//  WeiboImageBrowser.h
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "WeiboImageView.h"


@interface WeiboImageBrowser : NSObject
+(WeiboImageBrowser *)sharedWeiboImageBrowser;
-(void)showBmiddlePic:(WeiboImageView *)weiboImageView andTag:(NSInteger)tag;
-(void)closeBmiddlePic:(UITapGestureRecognizer *)tap;
@end
