//
//  MainViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/18.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MainViewController.h"
#import "FollowingWBViewController.h"
#import "ProfileViewController.h"

@interface MainViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    FollowingWBViewController *_followingWeiboVC;
    ProfileViewController *_profileVC;
    
    UIBarButtonItem *_writeNewWeibo;
    UIBarButtonItem *_settingBtn;
}
@end

@implementation MainViewController
NSString *access_token;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubView];
    self.selectedIndex = 0;
    _writeNewWeibo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(writeWeibo)];
    _writeNewWeibo.tintColor = RGBACOLOR(30, 40, 50, 1);
    [self.tabBar setTintColor:RGBACOLOR(30, 40, 50, 1)];
    [self tabBar:self.tabBar didSelectItem:_followingWeiboVC.tabBarItem];
    // Do any additional setup after loading the view.
    
}
- (void)initSubView{
    //自定义tabbar实现透明效果，替换时要使用[self setValue:  forKey:];因为其自带tabbar是只读，不能使用赋值形式。
    UITabBar * rootTabBar = [[UITabBar alloc] init];
    [rootTabBar setUserInteractionEnabled:YES];
    [rootTabBar setDelegate:self];
    [rootTabBar setBackgroundColor:[UIColor clearColor]];
    [rootTabBar setFrame:self.tabBar.frame];
    [rootTabBar setAlpha:1];
    
    [self.view addSubview:rootTabBar];
    [self setValue:rootTabBar forKey:@"tabBar"];

    _followingWeiboVC = [[FollowingWBViewController alloc]initWithStyle:UITableViewStylePlain];
    //_followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:nil tag:0];
    _followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    _followingWeiboVC.tabBarItem.title = @"Home";

    [self selectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    [self unselectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    
    
    _profileVC = [[ProfileViewController alloc]init];
    [_profileVC setAccess_token:_followingWeiboVC.access_token];
    [_profileVC initWithComponent];
    //_followingWeiboVC1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Message" image:nil tag:1];
    _profileVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    _profileVC.tabBarItem.title = @"Message";
    [self selectedTapTabBarItems:_profileVC.tabBarItem];
    [self unselectedTapTabBarItems:_profileVC.tabBarItem];
    
    self.viewControllers = @[_followingWeiboVC,_profileVC];
    for (UIViewController *controller in self.viewControllers) {
        UIViewController *view= controller.view;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            self.title = @"Home";
            self.navigationItem.rightBarButtonItem = _writeNewWeibo;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"opaque_b.png"] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
         
            break;
        case 1:
            self.title = @"Profile";
            self.navigationItem.rightBarButtonItem = nil;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"opaque_bg.png"] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            break;
        case 2:
            self.title = @"Hot";
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case 3:
            self.title = @"Profile";
            self.navigationItem.rightBarButtonItem = _settingBtn;
            break;
        default:
            break;
    }
}

- (void)selectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:14.0],UITextAttributeFont,RGBACOLOR(30, 40, 50, 1.0),UITextAttributeTextColor,nil] forState:UIControlStateSelected];
}
- (void)unselectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:14.0],UITextAttributeFont,RGBACOLOR(150, 150, 150, 1.0),UITextAttributeTextColor,nil] forState:UIControlStateNormal];
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
