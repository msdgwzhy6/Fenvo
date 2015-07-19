//
//  FollowingWBViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//
#import "FollowingWBViewController.h"
#import "WeiboMsg.h"
#import "WeiboMsgManager.h"
#import "FollowingWBViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ViewController.h"
#import "JSONKit.h"
#import "FeSpinnerTenDot.h"
#import "MJRefresh.h"
#import "WeiboAvatarView.h"
#import "WebViewController.h"
#import "UIColor+flat.h"
#import "KVNProgress.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@interface FollowingWBViewController ()<WeiboLabelDelegate,FeSpinnerTenDotDelegate,UIScrollViewDelegate>{
    NSMutableArray *_weiboMsgArray;
    NSMutableArray *_weiboCells;
    FeSpinnerTenDot *_spinnerHud;
    UIView *_spinnerView;
    NSMutableArray *_array;
    UIButton *_bottomRefresh;
    
    CGSize screenSize;
    NSInteger page;
    NSMutableArray *_tmp;
    NSInteger refreshtime;
    
    //刷新微博
    //下次返回比since_id晚的微博
    long long _since_id;
    //根据max_id返回比max_id早的微博
    long long _max_id;
    //next_cursor、previous_cursor指定返回的之后、之前的游标值。暂未支持
    long long _next_cursor;
    long long _previous_cursor;
}
@end
@implementation FollowingWBViewController
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = RGBACOLOR(250, 143, 5, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //仅做去除重用标志
    refreshtime = 1;
    //设置TableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    [center addObserver:self selector:@selector(getWeiboMsg:) name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    _weiboMsgArray = [[NSMutableArray alloc]init];
    [self addRefreshViewController];
}
- (void)addRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshWeiboMsg)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreWeibo)];
    
    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;
    self.tableView.footer.font = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
    //
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"客官您稍等，我马上帮你拉" forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"上拉加载更多" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"客官您稍等，我马上拉给你 " forState:MJRefreshFooterStateRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)getWeiboMsg:(NSNotification *)notification {
    
    _weiboMsgArray = [[NSMutableArray alloc]initWithArray:[WeiboMsgManager getWeiboMsgInCoreData]];
    if (_weiboMsgArray.count > 0) {
        return;
    }
    
    _access_token = [notification.userInfo objectForKey:@"token"];

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                
                _spinnerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
                _spinnerView.backgroundColor = [UIColor colorWithHexCode:@"#32ce55"];
                _spinnerHud = [[FeSpinnerTenDot alloc]initWithView:_spinnerView withBlur:NO andColor:RGBACOLOR(30, 40, 50, 1)];
                _spinnerHud.titleLabelText = @"Loading...";
                _spinnerHud.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
                _spinnerHud.delegate = self;
                [_spinnerView addSubview:_spinnerHud];
                [_spinnerHud show];
                [[UIApplication sharedApplication].keyWindow addSubview:_spinnerView];
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
                //http请求头应该添加text/plain。接受类型内容无text/plain
                manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
                NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
                NSDictionary *dict0 = [NSDictionary
                                       dictionaryWithObject:_access_token
                                       forKey:@"access_token"];
                [manager GET:getPublicWeiboTmp
                  parameters:dict0
                     success:^(AFHTTPRequestOperation *operation, id responserObject){
                    NSError *error;
                    NSData *jsonDatas = [responserObject
                                         JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                         error:&error];
                    NSString *jsonStrings = [[NSString alloc]
                                            initWithData:jsonDatas
                                            encoding:NSUTF8StringEncoding];
                         NSLog(@"%@",jsonStrings);
                    jsonStrings = [self getNormalJSONString:jsonStrings];
                    
                    
                    NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                    if (weiboMsgDictionary.count > 0) {

                       for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                            NSDictionary *dict = weiboMsgDictionary[i];
                            WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict];
                            [_weiboMsgArray addObject:weiboMsg];
                        
                        }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"%lld",_max_id);
                            [self.tableView reloadData];
                            [_spinnerHud removeFromSuperview];
                            [_spinnerView removeFromSuperview];
                        });
                    
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults removeObjectForKey:@"access_token"];
                    [userDefaults synchronize];
                    NSLog(@"public weibo get failure");
                }];
                
                
            });
   
}
- (void)refreshWeiboMsg{
    refreshtime ++;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *since_id = [NSNumber numberWithLongLong:_since_id];
        dict0= @{@"access_token":_access_token, @"since_id":since_id};
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (long i = (weiboMsgDictionary.count - 1); i >= 0; i --) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict];
                         [_weiboMsgArray insertObject:weiboMsg atIndex:0];
                         
                     }
                 }else {
                     [KVNProgress showSuccessWithStatus:@"No More Weibo"];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"%lld",_since_id);
                     [self.tableView reloadData];
                     [self.tableView.header endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.header endRefreshing];
                 NSLog(@"public weibo get failure");
             }];
        
        
    });
    
}
- (void)getMoreWeibo{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes =
        [manager.responseSerializer.acceptableContentTypes
         setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *max_id = [NSNumber numberWithLongLong:_max_id];
        dict0= @{@"access_token":_access_token, @"max_id":max_id};
        //
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
                 
                 jsonString = [self getNormalJSONString:jsonString];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonString objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"%lld",_max_id);
                     [self.tableView reloadData];
                     [self.tableView.footer endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.footer endRefreshing];
                 NSLog(@"public weibo get failure");
             }];
    });
}


#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

- (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    NSDictionary *dict = [jsonStrings objectFromJSONString];
    _since_id = [dict[@"since_id"] longLongValue];
    _max_id = [dict[@"max_id"] longLongValue];
    _previous_cursor = [dict[@"previous_cursor"] longLongValue];
    _next_cursor = [dict[@"next_cursor"] longLongValue];
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];

    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}

- (NSString *)getRefreshJSONString: (NSString *)jsonStrings {
    NSDictionary *dict = [jsonStrings objectFromJSONString];
    _since_id = [dict[@"since_id"] longLongValue];
    _previous_cursor = [dict[@"previous_cursor"] longLongValue];
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _weiboMsgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //去除重用机制
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.row,refreshtime];

    FollowingWBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[FollowingWBViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    cell.weiboMsg = weiboMsg;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    CGFloat yHeight = weiboMsg.height.floatValue;
    return yHeight;
}

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0.2) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            // iOS 7 设置隐藏状态栏
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}


- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
/*
- (void)swipeDown: (UISwipeGestureRecognizer *)swipeDown{
    NSLog(@"swipeDown");
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];
}
- (void)swipeUp: (UISwipeGestureRecognizer *)swipeUp{
    NSLog(@"swipeUp");
    [self.navigationController setNavigationBarHidden:TRUE animated:TRUE];
    [self.navigationController setToolbarHidden:TRUE animated:TRUE];

}
#pragma mark - egoRefreshFooterViewDelegate
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view{
    [self getWeiboMsgWithPage:2];
}
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view{
    return getMoreReloading;
}
- (NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view{
    return [NSDate date];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
