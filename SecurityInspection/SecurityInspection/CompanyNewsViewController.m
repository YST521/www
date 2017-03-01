//
//  CompanyNewsViewController.m
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "CompanyNewsViewController.h"
#import "MarqueeLabel.h"
@interface CompanyNewsViewController ()

@end

@implementation CompanyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (_content) {
        NSString * str = [NSString stringWithFormat:@"%@%@%@",@"<html><head><meta name=\'viewport\' content=\'width=device-width,user-scalable=no\'/><style> img{max-width:100%;}</style></head><body>",_content,@"</body></html>"];
        [_webView loadHTMLString:str baseURL:nil];
        _webView.scalesPageToFit = YES;
    }
    [self.view addSubview:_webView];
    MarqueeLabel *scrollyLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44) duration:8.0 andFadeLength:10.0f];
    scrollyLabel.text = _contentTitle;
    scrollyLabel.textAlignment = NSTextAlignmentCenter;
    scrollyLabel.textColor = [UIColor whiteColor];
    UIView * titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
//    titleview.backgroundColor = [UIColor blueColor];
    [titleview addSubview:scrollyLabel];
    self.navigationItem.titleView = titleview;
        // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
