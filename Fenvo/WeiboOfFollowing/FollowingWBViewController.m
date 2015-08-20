//
//  FollowingWBViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//
#import "FollowingWBViewController.h"
#import "WeiboDetailViewController.h"
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
#import "TimeLineRPC.h"
#import "WeiboStoreManager.h"
#import "WeiboStore.h"
#import "WeiboGetBlurImage.h"
#import "AppDelegate.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "NewWeiboVC.h"
#import "CoreDataManager.h"
#import "DiskCacheManager.h"


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
    
    //
    UIBarButtonItem *_writeNewWeibo;
    
    //刷新微博
    //下次返回比since_id晚的微博
    long long _since_id;
    //根据max_id返回比max_id早的微博
    long long _max_id;
    //next_cursor、previous_cursor指定返回的之后、之前的游标值。暂未支持
    long long _next_cursor;
    long long _previous_cursor;
    
    
    //是从coredata中找数据还是从服务器上
    BOOL _isFindInCoredata;
}
@end
@implementation FollowingWBViewController
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = RGBACOLOR(250, 143, 5, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _writeNewWeibo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithIcon:@"fa-pencil-square-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] style:UIBarButtonItemStyleDone target:self action:@selector(writeWeibo)];
    self.navigationItem.rightBarButtonItem = _writeNewWeibo;

    self.title = @"HOME";
    //
    _isFindInCoredata = true;
    
    //self.tableView = [[ANBlurredTableView alloc]initWithFrame:];
    self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //self.tableView.style = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    //[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;

    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    // We want to animate our background's alpha, so switch this to yes.
    //[self.tableView setAnimateTintAlpha:YES];
   // [self.tableView setStartTintAlpha:0.2f];
    [self.tableView setEndTintAlpha:0.6f];
    
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    


    
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
    
    
    [WeiboStoreManager queryAllWeiboStoreSucces:^(NSArray *timeLineArr, long long max_id) {
        _weiboMsgArray = [[NSMutableArray alloc]initWithArray:timeLineArr];
        WeiboMsg *weibo = [_weiboMsgArray lastObject];
        _max_id = weibo.ids.integerValue;
        
    } failure:^(NSString *desc) {
         [self getWeiboMsgFromRemote];
    }];
    
    
    //[WeiboStoreManager saveInCoreData];
    
}

- (void)getWeiboMsgFromRemote {
    
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
        
        
        
        [TimeLineRPC getHomeTimeLineWithSinceId:nil
                                        orMaxId:nil
                                        success:^(NSArray *timeLineArr, long long since_id, long long max_id, long long previous_cursor, long long next_cursor) {
                                            [_weiboMsgArray addObjectsFromArray:timeLineArr];
                                            _since_id = since_id;
                                            _max_id = max_id;
                                            _previous_cursor = previous_cursor;
                                            _next_cursor = next_cursor;
                                            
                                            for (WeiboMsg *weiboMsg in timeLineArr) {
                                                [WeiboStore createByWeiboMsg:weiboMsg];
                                            }
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.tableView reloadData];
                                                [_spinnerHud removeFromSuperview];
                                                [_spinnerView removeFromSuperview];
                                            });
                                            
                                        } failure:^(NSString *desc, NSError *error) {
                                            NSLog(@"%@", desc);
                                        }];
        
    });

}
- (void)refreshWeiboMsg{
        
        NSNumber *since_id = [NSNumber numberWithLongLong:_since_id];
        
        [TimeLineRPC getHomeTimeLineWithSinceId:since_id
                                        orMaxId:nil
                                        success:^(NSArray *timeLineArr, long long since_id, long long max_id, long long previous_cursor, long long next_cursor) {
                                            
                                            if (timeLineArr.count > 0) {
                                                for (long i = (timeLineArr.count - 1); i >= 0; i --) {
                                                    WeiboMsg *weiboMsg = (WeiboMsg *)timeLineArr[i];
                                                    [_weiboMsgArray insertObject:weiboMsg atIndex:0];
                                                }
                                            }else {
                                                [KVNProgress showSuccessWithStatus:@"No More Weibo"];
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.tableView reloadData];
                                                [self.tableView.header endRefreshing];
                                            });
                                            
                                        } failure:^(NSString *desc, NSError *error) {
                                            [self.tableView.header endRefreshing];
                                            NSLog(@"public weibo get failure");
                                        }];
    
}
- (void)getMoreWeibo{
    
    if (_isFindInCoredata == false) {
        [self getMoreWeiboFromRemote];
        return;
    };

    [WeiboStoreManager queryTimeLineWithMaxId:[NSNumber numberWithLongLong:_max_id]
                                      success:^(NSArray *timeLineArr, long long max_id) {
                                          
                                          if (timeLineArr.count > 0) {
                                              [self reloadData:timeLineArr];
                                          }else {
                                              [self getMoreWeiboFromRemote];
                                          }
                                          
                                      } failure:^(NSString *desc) {
                                          [self getMoreWeiboFromRemote];
                                      }];
    

}

- (void)getMoreWeiboFromRemote {
    
    _isFindInCoredata = false;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSNumber *max_id = [NSNumber numberWithLongLong:_max_id];
        
        [TimeLineRPC getHomeTimeLineWithSinceId:nil
                                        orMaxId:max_id
                                        success:^(NSArray *timeLineArr, long long since_id, long long max_id, long long previous_cursor, long long next_cursor) {
                                            
                                            [self reloadData:timeLineArr];
                                            
                                            _max_id = max_id;
                                            
                                        } failure:^(NSString *desc, NSError *error) {
                                            [self.tableView.footer endRefreshing];
                                            NSLog(@"public weibo get failure");
                                        }];
        
    });
}

- (void)reloadData:(NSArray *)timeLineArr {
         
    if (timeLineArr.count > 0) {
        for (int i = 0; i < timeLineArr.count; i ++) {
            WeiboMsg *weiboMsg = (WeiboMsg *)timeLineArr[i];
            [_weiboMsgArray addObject:weiboMsg];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%lld",_max_id);
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
    [self getMaxId:[_weiboMsgArray lastObject]];
}

- (void)getMaxId:(WeiboMsg *)weiboMsg {
    
    _max_id = weiboMsg.ids.longLongValue;
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
    NSString *cellIdentifier = @"followingCell";
    //[NSString stringWithFormat:@"cell%ld%ld",indexPath.row,refreshtime];

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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _weiboMsgArray.count - 10) {
        [self.tableView.footer beginRefreshing];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detailVC.weiboMsg = weiboMsg;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    CGFloat yHeight = weiboMsg.height.floatValue;
    return yHeight;
}

- (void)writeWeibo {
    NewWeiboVC *newWeiboVC = [[NewWeiboVC alloc]initWithNibName:@"NewWeiboVC" bundle:[NSBundle mainBundle]];
    newWeiboVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newWeiboVC animated:YES];
}

@end
