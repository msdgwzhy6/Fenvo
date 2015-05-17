//
//  FollowingWBViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingWBViewController.h"
#import "WeiboMsg.h"
#import "FollowingWBViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WeiboAvatarView.h"

#define WBAPIURL_FRIENDS @"https://api.weibo.com/2/statuses/home_timeline.json"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@interface FollowingWBViewController (){
    //UITableView *_tableView;
    NSMutableArray *_weiboMsgArray;
    NSMutableArray *_weiboCells;
    MBProgressHUD *_hud;
    NSMutableArray *_array;
    UIButton *_bottomRefresh;
}
@end
@implementation FollowingWBViewController

CGSize screenSize;
int page = 0;
NSMutableArray *_tmp;
int refreshtime = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    screenSize = [[UIScreen mainScreen]bounds].size;
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.frame = CGRectMake(0, 0, screenSize.width, self.view.bounds.size.height);
    NSLog(@"%f%f%f",self.tableView.frame.size.height, self.tabBarController.tabBar.frame.size.height,self.navigationController.navigationBar.frame.size.height);
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    [center addObserver:self selector:@selector(getWeiboMsg:) name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    _weiboMsgArray = [[NSMutableArray alloc]init];
    [self addRefreshViewController];
}
- (void)addRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshWeiboMsg)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getWeiboMsgWithPage)];
    
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
    // Dispose of any resources that can be recreated.
}


- (void)getWeiboMsg:(NSNotification *)notification {
    page ++;
    _access_token = [notification.userInfo objectForKey:@"token"];
   // NSLog(@"在FollowingVC中的access_token是：%@",_access_token);
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            _hud.dimBackground = YES;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = @"大爷姑奶奶您稍等...";
            _hud.labelFont = WBStatusHUDTextFont;
            [_hud show:YES];
            [self.view addSubview:_hud];
    //dispatch_queue_t queue;
    
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
                //http请求头应该添加text/plain。接受类型内容无text/plain
                manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
                NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
                NSString *getPublicWeibo = [getPublicWeiboTmp stringByAppendingString:_access_token];
                NSLog(@"%@",getPublicWeibo);
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
                    
                    //NSLog(@"%@",[self getNormalJSONString:jsonString]);
                    jsonStrings = [self getNormalJSONString:jsonStrings];
                    
                    
                    NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                    NSLog(@"%d",weiboMsgDictionary.count);
                    if (weiboMsgDictionary.count > 0) {

                       for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                            NSDictionary *dict = weiboMsgDictionary[i];
                            WeiboMsg *weiboMsg = [[WeiboMsg alloc]init];
                            weiboMsg = [weiboMsg initWithDictionary:dict];
                            [_weiboMsgArray addObject:weiboMsg];
                        
                        }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"reloadData success.%d",_weiboMsgArray.count);
                            [self.tableView reloadData];
                            [_hud removeFromSuperview];
                            [self downloadUserAvatar];
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
    page = 1;
    refreshtime ++;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
        NSString *getPublicWeibo = [getPublicWeiboTmp stringByAppendingString:_access_token];
        NSLog(@"%@",getPublicWeibo);
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
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                 NSLog(@"%lu",weiboMsgDictionary.count);
                 if (weiboMsgDictionary.count > 0) {
                     _weiboMsgArray = [[NSMutableArray alloc]init];
                     for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [[WeiboMsg alloc]init];
                         weiboMsg = [weiboMsg initWithDictionary:dict];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                     [self.tableView.header endRefreshing];
                     [self downloadUserAvatar];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.header endRefreshing];
                 NSLog(@"public weibo get failure");
             }];
        
        
    });
    
}
- (void)getWeiboMsgWithPage{
    page++;
    NSLog(@"在FollowingVC中的access_token是：%@",_access_token);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes =
        [manager.responseSerializer.acceptableContentTypes
         setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_FRIENDS;
        NSString *getPublicWeibo = [getPublicWeiboTmp stringByAppendingString:_access_token];
        NSLog(@"%@",getPublicWeibo);
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *pages = [NSNumber numberWithInt:page];
        dict0= @{@"access_token":_access_token, @"page":pages};
        //
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
                 
                 NSLog(@"%@",[self getNormalJSONString:jsonString]);
                 jsonString = [self getNormalJSONString:jsonString];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonString objectFromJSONString];
                 NSLog(@"%d",weiboMsgDictionary.count);
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [[WeiboMsg alloc]init];
                         weiboMsg = [weiboMsg initWithDictionary:dict];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                     [self.tableView.footer endRefreshing];
                     [self downloadUserAvatar];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.footer endRefreshing];
                 NSLog(@"public weibo get failure");
             }];
    });
}

#pragma mark - 下载微博头像
- (void)downloadUserAvatar{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

    for (int i = 0; i < _weiboMsgArray.count; i++) {
        WeiboMsg *weiboMsg = _weiboMsgArray[i];
        NSString *url = weiboMsg.user.profile_image_url;
        [[SDWebImageManager sharedManager]   downloadWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize,NSInteger expectedSize) {
            NSLog(@"%d %d",receivedSize,expectedSize);
        } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            [_weiboMsgArray[i] setUser_avatar:aImage];
            NSLog(@"成功了:%d",UIImageJPEGRepresentation(aImage, 1).length);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"downloadAvatar over.");
        });
        //有转发
        if (weiboMsg.retweeted_status != nil) {
            //有配图
            if (weiboMsg.retweeted_status.thumbnail_pic != nil) {
                for (int j = 0; j < weiboMsg.retweeted_status.pic_urls.count; j++) {
                    NSString *pic_url = weiboMsg.retweeted_status.pic_urls[j];
                    NSLog(@"第%d个微博:%@",i,pic_url);
                    /*
                    NSData *dataOfPic = [NSData dataWithContentsOfURL:[NSURL URLWithString:pic_url]];
                    UIImage *image = [[UIImage alloc]initWithData:dataOfPic];
                    if (image != nil) {
                        NSLog(@"%d in image is fucking download finish.",i);
                        [_weiboMsgArray[i] addWeibo_pics:image];
                    }else{
                        NSLog(@"%d image is nil", i);
                    }*/
                    [[SDWebImageManager sharedManager]   downloadWithURL:[NSURL URLWithString:pic_url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize,NSInteger expectedSize) {
                        NSLog(@"%d %d",receivedSize,expectedSize);
                    } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        if (aImage) {
                            [_weiboMsgArray[i] addWeibo_pics:aImage];
                           
                        }else{
                             NSLog(@"吃屎了:%d",UIImageJPEGRepresentation(aImage, 1).length);
                        }
                    }];
                    
                }
                if (weiboMsg.retweeted_status.pic_urls.count == weiboMsg.retweeted_status.weibo_pics.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        NSLog(@"%d in*** idownloadAvatar over.",i);
                    });
                }
            }
        }
        //无转发
        else{
            //有配图
            if (weiboMsg.thumbnail_pic != nil) {
                for (int j = 0; j < weiboMsg.pic_urls.count; j++) {
                    NSString *pic_url = weiboMsg.pic_urls[j];
                    NSLog(@"第%d个微博:%@",i,pic_url);
                    [[SDWebImageManager sharedManager]   downloadWithURL:[NSURL URLWithString:pic_url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize,NSInteger expectedSize) {
                        NSLog(@"%ld %ld",receivedSize,expectedSize);
                    } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        if (aImage) {
                            [_weiboMsgArray[i] addWeibo_pics:aImage];
                            
                        }else{
                            NSLog(@"吃屎了:%ld",UIImageJPEGRepresentation(aImage, 1).length);
                        }
                        
                    }];
                }
                if (weiboMsg.pic_urls.count == weiboMsg.weibo_pics.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                       NSLog(@"%d in ====idownloadAvatar over.",i);
                    });
                }
            }
        }
        

    }
        
       
    });
    
}

#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

- (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    NSLog(@"%@",str1);
    //
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
        NSLog(@"%@",jsonStrings);
    }
    
    return jsonStrings;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _weiboMsgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //去除重用机制
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,refreshtime];

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
    NSInteger yHeight = weiboMsg.height;
    return yHeight;
}

/*
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

#pragma mark - 实现egoRefresh附加的实现UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}
 */
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
