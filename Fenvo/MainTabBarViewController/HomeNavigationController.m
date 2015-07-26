//
//  HomeNavigationController.m
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "HomeNavigationController.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "NewWeiboVC.h"

@interface HomeNavigationController ()
{
        UIBarButtonItem *_writeNewWeibo;
}
@end

@implementation HomeNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {

        _writeNewWeibo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithIcon:@"fa-pencil-square-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] style:UIBarButtonItemStyleDone target:self action:@selector(writeWeibo)];
        self.navigationItem.rightBarButtonItem = _writeNewWeibo;
    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)writeWeibo {
    NewWeiboVC *newWeiboVC = [[NewWeiboVC alloc]initWithNibName:@"NewWeiboVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:newWeiboVC animated:YES];
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
