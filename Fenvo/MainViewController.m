//
//  MainViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/18.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MainViewController.h"
#import "FollowingWBViewController.h"
#import "TmpViewController.h"

@interface MainViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    FollowingWBViewController *_followingWeiboVC;
    TmpViewController *_followingWeiboVC1;
    
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
    _writeNewWeibo.tintColor = RGBACOLOR(200, 20, 20, 1);
    [self.tabBar setTintColor:RGBACOLOR(220, 0, 0, 1)];
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
    [rootTabBar setAlpha:0.7];
    
    [self.view addSubview:rootTabBar];
    [self setValue:rootTabBar forKey:@"tabBar"];

    _followingWeiboVC = [[FollowingWBViewController alloc]initWithStyle:UITableViewStylePlain];
    //_followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:nil tag:0];
    _followingWeiboVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    _followingWeiboVC.tabBarItem.title = @"Home";

    [self selectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    [self unselectedTapTabBarItems:_followingWeiboVC.tabBarItem];
    
    
    _followingWeiboVC1 = [[TmpViewController alloc]init];
    //_followingWeiboVC1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Message" image:nil tag:1];
    _followingWeiboVC1.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    _followingWeiboVC1.tabBarItem.title = @"Message";
    [self selectedTapTabBarItems:_followingWeiboVC1.tabBarItem];
    [self unselectedTapTabBarItems:_followingWeiboVC1.tabBarItem];
    
    self.viewControllers = @[_followingWeiboVC,_followingWeiboVC1];
    //self.selectedViewController = _followingWeiboVC;
    //self.selectedIndex = 1;//在选择0之前先选择1，然后再选择第0个Item，这样就能解决了
    //self.selectedIndex = 0;
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
            break;
        case 1:
            self.title = @"Message";
            self.navigationItem.rightBarButtonItem = nil;
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
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:14.0],UITextAttributeFont,RGBACOLOR(200, 20, 20, 1.0),UITextAttributeTextColor,nil] forState:UIControlStateSelected];
}
- (void)unselectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:14.0],UITextAttributeFont,RGBACOLOR(0, 0, 0, 1.0),UITextAttributeTextColor,nil] forState:UIControlStateNormal];
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
