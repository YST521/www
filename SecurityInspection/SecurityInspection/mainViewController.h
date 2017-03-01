//
//  mainViewController.h
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIButton *previousBtn;
@property (nonatomic,strong)UIButton *guideBtn;
@property (nonatomic,strong)UIButton *noticeBtn;
@property (nonatomic,strong)UIButton *signInBtn;
@property (nonatomic,strong)UIButton *patrolBtn;
@property (nonatomic,strong)UIButton *loginOutBtn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSDictionary * introductiondic;

@end
