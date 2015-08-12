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

@interface WeiboDetailViewController ()
{
    DetailView *_detailView;
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
    
    if (![self.tableView isKindOfClass:[ANBlurredTableView class]]) {
        self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.tableView setEndTintAlpha:0.6f];
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
    
    
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg {
    _weiboMsg = weiboMsg;
    
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
