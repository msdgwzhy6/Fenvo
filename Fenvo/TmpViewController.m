//
//  TmpViewController.m
//  Fenvo
//
//  Created by Caesar on 15/4/7.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "TmpViewController.h"

@interface TmpViewController ()

@end

@implementation TmpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT/2-20, IPHONE_SCREEN_WIDTH, 40)];
    label.text = @"WAITING FOR ME";
    label.font = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = RGBACOLOR(200, 20, 20, 1);
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
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
