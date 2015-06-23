//
//  NewWeiboVC.h
//  Fenvo
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewWeiboVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *wbDetail;
@property (strong, nonatomic) IBOutlet UIButton *addImg;

@property (strong, nonatomic)NSMutableArray *imgPaths;
@end
