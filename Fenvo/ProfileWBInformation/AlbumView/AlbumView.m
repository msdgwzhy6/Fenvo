//
//  AlbumView.m
//  Fenvo
//
//  Created by Caesar on 15/5/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AlbumView.h"
#import "ImageScrollView.h"

@interface AlbumView ()
{
    ImageScrollView *_albumView;
}
@end

@implementation AlbumView

- (void)viewDidLoad {
    [super viewDidLoad];
    _albumView = [[ImageScrollView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:_albumView];
    // Do any additional setup after loading the view.
}
- (void)setAccessToken {
    [_albumView setAccess_token];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
