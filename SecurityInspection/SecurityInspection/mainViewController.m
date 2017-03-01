//
//  mainViewController.m
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "mainViewController.h"
#import "noticeViewController.h"
#import "signinViewController.h"
#import "patrolViewController.h"
#import "LoginViewController.h"
#import "CompanyNewsTableViewCell.h"
#import "newsTitleTableViewCell.h"
#import "CompanyIntroductionTableViewCell.h"
#import "PublicFunction.h"
#import "CompanyNewsViewController.h"
#import "informationsModel.h"
#import "MBProgressHUD.h"
#import "staffModel.h"
#import "AppDelegate.h"
//#import "New.h"

#define BTNWIDTH  ScreenWidth/4
#define BTNHEIGHT 44
#define newsCellHeight 30
#define barimageWidth 24
#define barimageHight 24
#define barimageTop 2
#define bartextWidth 50
#define bartextHight 10
#define bartextTop 28
@interface mainViewController (){
    NSInteger btnnum;
    UIImageView *noticeImageView;
    UILabel *noticeLabel;
    UIImageView *signInImageView;
    UILabel *signInLabel;
    UIImageView *patrolImageView;
    UILabel *patrolLabel;
    UIImageView *loginOutImageView;
    UILabel *loginOutLabel;
    NSMutableArray * readedNews;
}
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智慧管家";
    NSNotificationCenter * center = [NSNotificationCenter
                                     defaultCenter];
    [center addObserver:self selector:@selector(loginfinish:) name:@"loginfinish" object:nil];
    self.view.backgroundColor = RGB(0.90, 0.90, 0.90);
    _dataArr = [NSMutableArray array];

    _noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight - BTNHEIGHT, BTNWIDTH, BTNHEIGHT)];
    _noticeBtn.backgroundColor = [UIColor whiteColor];
    noticeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/2-barimageWidth/2, barimageTop, barimageWidth, barimageHight)];
    noticeImageView.image = [PublicFunction skinFromImageName:@"announcement_off.png"];
    [_noticeBtn addSubview:noticeImageView];
    noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2-bartextWidth/2, bartextTop, bartextWidth, bartextHight)];
    noticeLabel.text = @"公告";
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = [UIFont systemFontOfSize:11];
    [_noticeBtn addSubview:noticeLabel];
    _noticeBtn.tag = 9001;
    [_noticeBtn addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
    [_noticeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _signInBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTNWIDTH, ScreenHeight - BTNHEIGHT, BTNWIDTH, BTNHEIGHT)];
    _signInBtn.backgroundColor = [UIColor whiteColor];
    signInImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/2-barimageWidth/2, barimageTop, barimageWidth, barimageHight)];
    signInImageView.image = [PublicFunction skinFromImageName:@"registration_off.png"];
    [_signInBtn addSubview:signInImageView];
    signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2-bartextWidth/2, bartextTop, bartextWidth, bartextHight)];
    signInLabel.text = @"签到";
    signInLabel.textAlignment = NSTextAlignmentCenter;
    signInLabel.font = [UIFont systemFontOfSize:11];
    [_signInBtn addSubview:signInLabel];
    _signInBtn.tag = 9002;
    [_signInBtn addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
    [_signInBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _patrolBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTNWIDTH*2, ScreenHeight - BTNHEIGHT, BTNWIDTH, BTNHEIGHT)];
    _patrolBtn.backgroundColor = [UIColor whiteColor];
    patrolImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/2-barimageWidth/2, barimageTop+3, barimageWidth, 17)];
    patrolImageView.image = [PublicFunction skinFromImageName:@"patrol_off.png"];
    [_patrolBtn addSubview:patrolImageView];
    patrolLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2-bartextWidth/2, bartextTop, bartextWidth, bartextHight)];
    patrolLabel.text = @"巡检";
    patrolLabel.textAlignment = NSTextAlignmentCenter;
    patrolLabel.font = [UIFont systemFontOfSize:11];
    [_patrolBtn addSubview:patrolLabel];
    _patrolBtn.tag = 9003;
    [_patrolBtn addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
    [_patrolBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTNWIDTH*3, ScreenHeight - BTNHEIGHT, BTNWIDTH, BTNHEIGHT)];
    _loginOutBtn.backgroundColor = [UIColor whiteColor];
    loginOutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/2-barimageWidth/2, barimageTop, barimageWidth, barimageHight)];
    loginOutImageView.image = [PublicFunction skinFromImageName:@"dropoff_off.png"];
    [_loginOutBtn addSubview:loginOutImageView];
    loginOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2-bartextWidth/2, bartextTop, bartextWidth, bartextHight)];
    loginOutLabel.text = @"退出";
    loginOutLabel.textAlignment = NSTextAlignmentCenter;
    loginOutLabel.font = [UIFont systemFontOfSize:11];
    [_loginOutBtn addSubview:loginOutLabel];
    [_loginOutBtn addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
    [_loginOutBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_guideBtn];
    [self.view addSubview:_noticeBtn];
    [self.view addSubview:_signInBtn];
    [self.view addSubview:_patrolBtn];
    [self.view addSubview:_loginOutBtn];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight*0.4)];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    //公司新闻
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+ScreenHeight*0.4+1, ScreenWidth, 45)];
    headView.backgroundColor = [UIColor whiteColor];
//        headView.layer.borderWidth = 0.5;
//        headView.layer.edgeAntialiasingMask = kCALayerBottomEdge;
    headView.layer.shadowOffset = CGSizeMake(0, 1);// 设置阴影的偏移量
    headView.layer.shadowRadius = 1.0;// 设置阴影的半径
    headView.layer.shadowColor = [UIColor grayColor].CGColor;// 设置阴影的颜色为黑色
    headView.layer.shadowOpacity = 0.5;// 设置阴影的不透明度
    
    UIImageView *newsImageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 24, 23)];
    newsImageview.image = [PublicFunction skinFromImageName:@"newspaper.png"];
    
    UILabel *newsLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 6, 132, 30)];
    newsLabel.text = @"公司新闻";
    newsLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:21];
    
    [headView addSubview:newsImageview];
    [headView addSubview:newsLabel];
    
    [self.view addSubview:headView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+ScreenHeight*0.4+45+2, ScreenWidth, ScreenHeight-BTNHEIGHT-STATUSBARHEIGHT-NAVIGATIONBARHEIGHT-ScreenHeight*0.4-45-3) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.shadowOffset = CGSizeMake(0, 1);// 设置阴影的偏移量
    _tableView.layer.shadowRadius = 1.0;// 设置阴影的半径
    _tableView.layer.shadowColor = [UIColor grayColor].CGColor;// 设置阴影的颜色为黑色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    headView.layer.shadowOpacity = 0.5;// 设置阴影的不透明度
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view from its nib.
    readedNews = [[NSUserDefaults standardUserDefaults] objectForKey:@"readedNews"];
    [self getdata];
}

- (void)loginfinish:(NSNotification *)notification {
        noticeViewController * noticeview = [[noticeViewController alloc]init];
        signinViewController * signinview = [[signinViewController alloc]init];
        patrolViewController * patrolview = [[patrolViewController alloc]init];
    switch (btnnum) {
        case 9001:
            [self.navigationController pushViewController:noticeview animated:YES];
            break;
        case 9002:
            [self.navigationController pushViewController:signinview animated:YES];
            break;
        case 9003:
            [self.navigationController pushViewController:patrolview animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;

    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"home_icon_on.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [_tableView reloadData];
//    _dataArr = [NSMutableArray array];
}

- (void)leftButtonClick
{
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getdata
- (void)getdata{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"数据加载中";
    hud.margin = 10.f;
    hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [[informationsModel sharedInstance] getInformations:@"1,2" successBlock:^(id responseObject, NSDictionary *userInfo) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
            if (200 == statusCode) {
                if ([dict[@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray * arr = dict[@"content"];
                    NSMutableArray * temnewsIdarr = [NSMutableArray array];
                    for (NSDictionary * dic in arr) {
                        if ([dic[@"kind"] isEqualToString:@"1"]) {
                            _introductiondic = dic;
                        }else{
                            [_dataArr addObject:dic];
                            [temnewsIdarr addObject:dic[@"id"]];
                        }
                    }
                    if (readedNews) {
                        NSMutableArray * temp = [NSMutableArray arrayWithArray:readedNews];
                        for (NSString * str in readedNews) {
                            if (![temnewsIdarr containsObject:str]) {
                                [temp removeObject:str];
                            }
                        }
                        readedNews = temp;
                    }else{
                        readedNews = [[NSMutableArray alloc]init];
                    }

                    NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"modify_time" ascending:NO];
                    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
                    NSArray *sortArray=[_dataArr sortedArrayUsingDescriptors:sortDescriptors];
//                    NSLog(@"公司简介%@",_introductiondic);
                    _dataArr = [NSMutableArray arrayWithArray:sortArray];
//                    NSLog(@"公司新闻%@",sortArray);
                    NSString * str = [NSString stringWithFormat:@"%@%@%@",@"<html><head><meta name=\'viewport\' content=\'width=device-width,user-scalable=no\'/><style> img{max-width:100%;}</style></head><body>",_introductiondic[@"content"],@"</body></html>"];
                    [_webView loadHTMLString:str baseURL:nil];
                    [_tableView reloadData];
                }
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未知错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        [hud hide:YES];
    } errorBlock:^(NSError *error) {
        [hud hide:YES];
    }];
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置某个章节内的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//设置每个单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellTableIdentifier = @"CompanyNews";
    CompanyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        CellTableIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CompanyNewsTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    cell.newsTitle.text = @"拳击比赛";
    if (_dataArr.count != 0) {
        if ([_dataArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _dataArr[indexPath.row];
                cell.newsTitle.text = dic[@"title"];
            if ([readedNews containsObject:dic[@"id"]]) {
                cell.isreaded = YES;
            }else{
                cell.isreaded = NO;
            }

            [cell isNeedShowNew:dic[@"modify_time"]];
        }
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    CompanyNewsViewController *companyNewsVC = [[CompanyNewsViewController alloc]init];
    if (_dataArr.count != 0) {
        if ([_dataArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = _dataArr[indexPath.row];
            companyNewsVC.content = dic[@"content"];
            NSString * notice_id = dic[@"id"];
            if (![readedNews containsObject:notice_id]) {
                NSMutableArray * tempArr = [NSMutableArray arrayWithArray:readedNews];
                //                    tempArr = [NSMutableArray array];
                [tempArr addObject:notice_id];
                readedNews =tempArr;
                [[NSUserDefaults standardUserDefaults] setObject:readedNews forKey:@"readedNews"];
            }

        }
    }
    CompanyNewsTableViewCell *cell = (CompanyNewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    companyNewsVC.contentTitle = cell.newsTitle.text;
    [self.navigationController pushViewController:companyNewsVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 45;
}

#pragma mark - btnClick
- (void)TouchDown:(UIButton *)sender{
    sender.backgroundColor = [UIColor redColor];
    if (sender == _noticeBtn) {
        noticeImageView.image = [PublicFunction skinFromImageName:@"announcement_on.png"];
        noticeLabel.textColor = [UIColor whiteColor];
    }
    if (sender == _signInBtn) {
        signInImageView.image = [PublicFunction skinFromImageName:@"registration_on.png"];
        signInLabel.textColor = [UIColor whiteColor];
    }
    if (sender == _patrolBtn) {
        patrolImageView.image = [PublicFunction skinFromImageName:@"patrol_on.png"];
        patrolLabel.textColor = [UIColor whiteColor];
    }
    if (sender == _loginOutBtn) {
        loginOutImageView.image = [PublicFunction skinFromImageName:@"dropoff_on.png"];
        loginOutLabel.textColor = [UIColor whiteColor];
    }
}


- (void)btnClick:(UIButton *)sender{
    sender.backgroundColor = [UIColor whiteColor];
    if (sender == _noticeBtn) {
        noticeImageView.image = [PublicFunction skinFromImageName:@"announcement_off.png"];
        noticeLabel.textColor = [UIColor blackColor];
    }
    if (sender == _signInBtn) {
        signInImageView.image = [PublicFunction skinFromImageName:@"registration_off.png"];
        signInLabel.textColor = [UIColor blackColor];
    }
    if (sender == _patrolBtn) {
        patrolImageView.image = [PublicFunction skinFromImageName:@"patrol_off.png"];
        patrolLabel.textColor = [UIColor blackColor];
    }
    if (sender == _loginOutBtn) {
        loginOutImageView.image = [PublicFunction skinFromImageName:@"dropoff_off.png"];
        loginOutLabel.textColor = [UIColor blackColor];
    }
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    
    if ([staffModel sharedInstance].loginType == LOGINSUCCESS) {
        if (sender == _noticeBtn) {
            
            noticeViewController * noticeview = [[noticeViewController alloc]init];
            [self.navigationController pushViewController:noticeview animated:YES];
            
        }
        if (sender == _signInBtn) {
            
            signinViewController * signinview = [[signinViewController alloc]init];
            [self.navigationController pushViewController:signinview animated:YES];
        }
        if (sender == _patrolBtn) {
//            //TODO:调用获取check_time的接口获取check_time跟现在的时间比
//            [[staffModel sharedInstance] requestCheckTimeSuccessBlock:^(id responseObject, NSDictionary *userInfo) {
//                if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                    NSLog(@"%@",responseObject);
//                    NSDictionary *dict = responseObject;
//                    NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
//                    if (200 == statusCode) {
//                        if ([dict[@"content"] isKindOfClass:[NSDictionary class]]) {
//                            NSDictionary *staffinfo = dict[@"content"];
//                            NSString *check_time = [staffinfo objectForKey:@"check_time"];
//                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                            NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//                            
//                            [formatter setTimeZone:timeZone];
//                            [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
//                            NSDate *dateTime = [formatter dateFromString:check_time];
//                            NSInteger check_time_interval = [timeZone secondsFromGMTForDate:dateTime];
//                            dateTime = [dateTime dateByAddingTimeInterval:check_time_interval];
//                            
//                            //获取当前时间
//                            NSDate *currentTime = [NSDate date];
//                            NSTimeZone *zone = [NSTimeZone systemTimeZone];
//                            
//                            NSInteger interval = [zone secondsFromGMTForDate:currentTime];
//                            
//                            NSDate *localeDate = [currentTime dateByAddingTimeInterval:interval];
//                        
//                            
//                            int locationUpdateInterval = 3600*16;//16 hour
//                            if ([localeDate timeIntervalSinceDate:dateTime] > locationUpdateInterval) {
//                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请首先进行上班签到再进行巡检" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                alert.tag = 99;
//                                [alert show];
//                            }
//                        }
//                    }
//                }
//                
//            } errorBlock:^(NSError *error) {
//                
//            }];
            
            patrolViewController * patrolview = [[patrolViewController alloc]init];
            [self.navigationController pushViewController:patrolview animated:YES];
        }
    }
    else if(sender != _loginOutBtn){
//        [self.navigationController pushViewController:loginVC animated:NO];
        btnnum = sender.tag;
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
    }
    
    if (sender == _loginOutBtn){
        if ([staffModel sharedInstance].loginType == LOGINSUCCESS) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您确定要退出吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 9;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还没有登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99 && buttonIndex == 0) {
        signinViewController *signinVC = [[signinViewController alloc]init];
        [self.navigationController pushViewController:signinVC animated:YES];
    }
    
    if (alertView.tag == 9 && buttonIndex == 0) {
        [UserDefaults setObject:nil forKey:@"user_id"];
        [UserDefaults setObject:nil forKey:@"name"];
        [UserDefaults setObject:nil forKey:@"password"];
        [UserDefaults setObject:nil forKey:@"username"];
        //                    [UserDefaults setValue:project_id forKey:@"project_id"];
        [UserDefaults synchronize];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate stopLocationService];
//        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
