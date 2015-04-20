//
//  WeiboImageBrowser.m
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboImageBrowser.h"

@interface WeiboImageBrowser ()<UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIScrollView *scrollView;
    UIScrollView *mainScrollView;
    UIPageControl *pageControl;
    NSMutableArray *bmiddle_pic_urls;
    NSMutableArray *original_pic_urls;
}
@end

@implementation WeiboImageBrowser:NSObject
static CGRect oldImageViewFrame;
+(WeiboImageBrowser *)sharedWeiboImageBrowser{
    static WeiboImageBrowser *weiboImageBrowser;
    @synchronized(self){
        if (!weiboImageBrowser) {
            weiboImageBrowser = [[self alloc]init];
        }
    }
    return weiboImageBrowser;
}

-(void)showBmiddlePic:(WeiboImageView *)weiboImageView andTag:(NSInteger)tag{
    NSString *url = weiboImageView.bmiddle_pic_url;
    bmiddle_pic_urls = weiboImageView.bmiddle_pic_urls;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //
    mainScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mainScrollView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    mainScrollView.alpha = 0.5;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(weiboImageView.bmiddle_pic_urls.count * IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 15, IPHONE_SCREEN_HEIGHT - 20, 30, 10)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = bmiddle_pic_urls.count;
    pageControl.currentPage = tag;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [window addSubview:mainScrollView];
    [window addSubview:pageControl];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(pageControl.currentPage*IPHONE_SCREEN_WIDTH, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    oldImageViewFrame = [weiboImageView convertRect:weiboImageView.bounds toView:window];
    scrollView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.5;
    imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image) {
            imageView.image = image;
            CGSize imageSize = image.size;
            float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
            if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
            }
            else{
                imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
            }
            NSLog(@"scrollview image download finished%@%@",imageURL,image);
        }
        
    }];
    
    
    imageView.tag = 901;
    [scrollView addSubview:imageView];
    [mainScrollView addSubview:scrollView];
    
    UITapGestureRecognizer *tap_closeScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBmiddlePic:)];
    [mainScrollView addGestureRecognizer:tap_closeScrollView];
    [UIScrollView animateWithDuration:0.3 animations:^{
        mainScrollView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}
-(void)pageTurn:(UIPageControl *)aPageControl{
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(aPageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    scrollView.frame = rect;
    [mainScrollView scrollRectToVisible:rect animated:YES];
    [mainScrollView scrollRectToVisible:rect animated:YES];
    [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddle_pic_urls[pageControl.currentPage]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image) {
            imageView.image = image;
            CGSize imageSize = image.size;
            float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
            if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
            }
            else{
                imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
            }
            NSLog(@"scrollview image download finished%@%@",imageURL,image);
        }
        
    }];
}

-(void)closeBmiddlePic:(UITapGestureRecognizer *)tap{
    UIScrollView *backgroundView = tap.view;
    UIImageView *aimageView = (UIImageView *)[tap.view viewWithTag:901];
    [UIScrollView animateWithDuration:0.3 animations:^{
        aimageView.frame = oldImageViewFrame;
        backgroundView.alpha = 0;
        pageControl.alpha = 0;
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView{
    if (aScrollView == scrollView) {
        return imageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)ascrollView{
    if (ascrollView == scrollView) {
        CGFloat offsetX = (ascrollView.bounds.size.width > ascrollView.contentSize.width)?
        (ascrollView.bounds.size.width - ascrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (ascrollView.bounds.size.height > ascrollView.contentSize.height)?
        (ascrollView.bounds.size.height - ascrollView.contentSize.height) * 0.5 : 0.0;
        imageView.center = CGPointMake(ascrollView.contentSize.width * 0.5 + offsetX,
                                       ascrollView.contentSize.height * 0.5 + offsetY);
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)myScrollView{
    if (myScrollView == mainScrollView) {
        CGPoint offset = myScrollView.contentOffset;
        pageControl.currentPage = offset.x/(mainScrollView.bounds.size.width);
        CGSize viewSize = scrollView.frame.size;
        CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
        scrollView.frame = rect;
        [mainScrollView scrollRectToVisible:rect animated:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddle_pic_urls[pageControl.currentPage]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            if (image) {
                imageView.image = image;
                CGSize imageSize = image.size;
                float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
                if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                    imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                    scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
                }
                else{
                    imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                }
                NSLog(@"scrollview image download finished%@%@",imageURL,image);
            }
            
        }];

    }
}

@end
