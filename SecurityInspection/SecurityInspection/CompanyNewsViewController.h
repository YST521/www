//
//  CompanyNewsViewController.h
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyNewsViewController : UIViewController
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * contentTitle;
@end
