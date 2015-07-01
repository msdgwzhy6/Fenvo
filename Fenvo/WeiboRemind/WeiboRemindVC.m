//
//  WeiboRemindVC.m
//  Fenvo
//
//  Created by Caesar on 15/6/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboRemindVC.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "KVNProgress.h"
#import "ChatCell.h"

@interface WeiboRemindVC () {
 
    //chat list
    NSMutableArray *_chatList;
    
    //function list @、comment、like
    NSArray *_func_list;
    
    
}
@end

@implementation WeiboRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //let the view which in front of the tableview be opaque
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tableView.backgroundColor = RGBACOLOR(30, 40, 50, 1);
    
    //cancel tableview extend edge
    //because navigationBar or tabBar maybe covers the tableView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(69, 0, 44, 0);
    //add refresh control
    //[self addRefreshViewController];
    
    
    //功能列表
    _func_list = [NSArray arrayWithObjects:
                  @"Comment",
                  @"@  Event",
                  @"Like",
                  @"Chat",
                  nil];
}

- (void)addRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
    
    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;

    //
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"客官您稍等，我马上帮你拉" forState:MJRefreshHeaderStateRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* normal_cellID = @"normal_cellID";
    static NSString* chat_cellID = @"chat_cellID";
    
    //if the indexPath.row <= 2
    if (indexPath.row <= 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal_cellID];
        cell.backgroundColor = RGBACOLOR(255, 255, 255, 0.6);
        cell.text = _func_list[indexPath.row];
        cell.font = [UIFont systemFontOfSize:18];
        return cell;
    }
    //else if other indexPath.row
    else {
        // 拿到一个标识先去缓存池中查找对应的Cell
        ChatCell *cell;
        // Using the cellID to search the cell in cache pool
        cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier:chat_cellID];
        if (cell == nil) {
            UINib *nibs = [UINib nibWithNibName:@"ChatCell" bundle:nil];
            cell = [nibs instantiateWithOwner:nil options:nil][0];
            
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
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