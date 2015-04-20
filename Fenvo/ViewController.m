//
//  ViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "AppDelegate.h"


@interface ViewController (){
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
    NSString *OAuthURL = @"https://api.weibo.com/oauth2/authorize?client_id=3151711642&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:OAuthURL]];
    [self.loginView setDelegate:self];
    [self.loginView loadRequest:request];
}

- (void)initInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginView = [[UIWebView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.scalesPageToFit = YES;
    self.loginView.opaque = YES;
    self.loginView.userInteractionEnabled = YES;
    [self.view addSubview:self.loginView];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
     activityIndicatorView.center=CGPointMake(self.view.center.x,240);
    [self.navigationController.view addSubview:activityIndicatorView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView stopAnimating];
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"%@",url);
    //NSRange rang = NSMakeRange(40, 32);
    if ([url hasPrefix:@"https://api.weibo.com/oauth2/default.html?"]) {
        
        
    //获得code
    NSString *code = [url substringFromIndex:47];
        NSLog(@"%@",code);
        
    NSString *urlTmp = @"https://api.weibo.com/oauth2/access_token?client_id=3151711642&client_secret=a9145449b749ca064e7acbcae7589818&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&code=";
        NSString *getTokenUrlString = [urlTmp stringByAppendingString:code];
        NSLog(@"%@",getTokenUrlString);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSDictionary *dict = @{@"format": @"json"};
        
        /////////////////////////////////////////////////////////////////
        ////*********此处请求方式应该设为POST而不应该为GET！！！***********////
        /////////////////////////////////////////////////////////////////
        [manager POST:getTokenUrlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *dict;
            NSLog(@"%@",responseObject);
            dict = responseObject;
            self.access_token = dict[@"access_token"];
            NSString *expires_in = dict[@"expires_in"];
            
            NSLog(@"%@\nexpires_in :%@",self.access_token,expires_in);
            NSDictionary *token = [[NSDictionary alloc]init];
            token = @{@"token":self.access_token,@"expires_in":expires_in};
            NSLog(@"%@",token);
            //[NSDictionary dictionaryWithObject:self.access_token forKey:@"token"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:@YES userInfo:token];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             NSLog(@"server error.%@",error);
        }];

    }
}
-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    
}
@end
