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
#import "WeiboRemindVC.h"
#import "NewWeiboVC.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "MainTabBar.h"

@interface MainViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    FollowingWBViewController *_followingWeiboVC;
    ProfileViewController *_profileVC;
    WeiboRemindVC *_remindVC;
    
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
    _writeNewWeibo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithIcon:@"fa-pencil-square-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] style:UIBarButtonItemStyleDone target:self action:@selector(writeWeibo)];
    [self tabBar:self.tabBar didSelectItem:_followingWeiboVC.tabBarItem];
    // Do any additional setup after loading the view.
    
}
- (void)initSubView{
    //自定义tabbar实现透明效果，替换时要使用[self setValue:  forKey:];因为其自带tabbar是只读，不能使用赋值形式。
    UITabBar * rootTabBar = [[MainTabBar alloc] init];
    
    [self.view addSubview:rootTabBar];
    [self setValue:rootTabBar forKey:@"tabBar"];

    _followingWeiboVC = [[FollowingWBViewController alloc]initWithStyle:UITableViewStylePlain];
    //_followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:nil tag:0];
    _followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Me" image:[UIImage imageWithIcon:@"fa-home" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-home" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];
    _followingWeiboVC.tabBarItem.tag = 0;

    [self selectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    [self unselectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    
    
    _remindVC = [[WeiboRemindVC alloc]initWithStyle:UITableViewStyleGrouped];
    _remindVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Message" image:[UIImage imageWithIcon:@"fa-envelope" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-envelope" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];
    _remindVC.tabBarItem.tag = 1;
    [self selectedTapTabBarItems:_remindVC.tabBarItem];
    [self unselectedTapTabBarItems:_remindVC.tabBarItem];
    
    _profileVC = [[ProfileViewController alloc]init];
    //_followingWeiboVC1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Message" image:nil tag:1];
    _profileVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Me" image:[UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];
    _profileVC.tabBarItem.tag = 3;
    [self selectedTapTabBarItems:_profileVC.tabBarItem];
    [self unselectedTapTabBarItems:_profileVC.tabBarItem];
    
    
    
    self.viewControllers = @[_followingWeiboVC,_remindVC,_profileVC];
    for (UIViewController *controller in self.viewControllers) {
        UIViewController *view= controller.view;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)writeWeibo {
    NewWeiboVC *newWeiboVC = [[NewWeiboVC alloc]initWithNibName:@"NewWeiboVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:newWeiboVC animated:YES];
}
#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            self.title = @"Home";
            self.navigationItem.rightBarButtonItem = _writeNewWeibo;
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            break;
        case 1:
            self.title = @"Remind";
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            break;
        case 2:
            self.title = @"Hot";
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case 3:
            self.title = @"Profile";
            self.navigationItem.rightBarButtonItem = nil;
            //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"opaque_bg.png"] forBarMetrics:UIBarMetricsDefault];
            //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = _settingBtn;
            break;
        default:
            break;
    }
}

- (void)selectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],UITextAttributeFont,RGBACOLOR(250, 143, 5, 1),UITextAttributeTextColor,nil] forState:UIControlStateSelected];
}
- (void)unselectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],UITextAttributeFont,[UIColor lightGrayColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
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
