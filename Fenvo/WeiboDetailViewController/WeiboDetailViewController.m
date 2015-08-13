//
//  WeiboDetailViewController.m
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "DetailView.h"
#import "StyleOfRemindSubviews.h"
#import "BottomView.h"

@interface WeiboDetailViewController ()
{
    DetailView *_detailView;
    BottomView *_buttonView;
}
@end

@implementation WeiboDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.title = @"DETAIL";
    
    if (![self.tableView isKindOfClass:[ANBlurredTableView class]]) {
        self.tableView = [[ANBlurredTableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 44) style:UITableViewStyleGrouped];
    }
    
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.tableView setEndTintAlpha:0.6f];
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
    _buttonView = [[BottomView alloc]init];
    _buttonView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT - [StyleOfRemindSubviews bottomHeight], IPHONE_SCREEN_WIDTH, [StyleOfRemindSubviews bottomHeight]);

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_buttonView removeFromSuperview];
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg {
    _weiboMsg = weiboMsg;
    
    if (![self.tableView isKindOfClass:[ANBlurredTableView class]]) {
        self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    _detailView = [[DetailView alloc]init];
    _detailView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    _detailView.weiboMsg = weiboMsg;
    _detailView.frame = CGRectMake(0, 0, self.view.frame.size.width, _detailView.height);
    self.tableView.tableHeaderView = _detailView;
    
    UIView *view = self.tableView.tableHeaderView;
    CGRect frame = view.frame;
    self.tableView.tableHeaderView.frame = frame;
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:_buttonView];
    _buttonView.weiboMsg = weiboMsg;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"dfdf";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
//    if (sectionTitle == nil) {
//        return  nil;
//    }
//    
//    BottomView *bottom = [[BottomView alloc]init];
//    bottom.frame = CGRectMake(0, 0, tableView.bounds.size.width, 22);
//    
//    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
//    [sectionView setBackgroundColor:[UIColor blackColor]];
//    [sectionView addSubview:bottom];
//    return sectionView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"detailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [StyleOfRemindSubviews whiteOpaqueColor];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
