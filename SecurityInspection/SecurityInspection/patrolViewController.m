//
//  patrolViewController.m
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "patrolViewController.h"
#import "PlanViewController.h"
#import "ZBarSDK.h"
#import "LoginViewController.h"
#import "ProjectInfoModel.h"
#import "staffModel.h"
#import "MBProgressHUD.h"
#import "signinViewController.h"
#import "selectprojectViewController.h"
#import "UIViewController+MaryPopin.h"
#define  LABELWIDTH  (ScreenWidth-40)/4
#define LABELHEIGHT  30

@interface patrolViewController ()<selectprojectItemDelegate>{
    selectprojectViewController * selectprojectView;
    BOOL isfristLoad;
}

@end

@implementation patrolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isfristLoad= YES;
    _dataAry = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    if (![UserDefaults boolForKey:@"isqiandao"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请首先进行上班签到再进行巡检" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 99;
        [alert show];
    }else{
        [[staffModel sharedInstance] requestCheckTimeSuccessBlock:^(id responseObject, NSDictionary *userInfo) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //                NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject;
                NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
                if (200 == statusCode) {
                    if ([dict[@"content"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *staffinfo = dict[@"content"];
                        NSString *check_time = [staffinfo objectForKey:@"check_time"];
                        if ([check_time isEqualToString:@""]) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请首先进行上班签到再进行巡检" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 99;
                            [alert show];
                        }else {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
                            
                            [formatter setTimeZone:timeZone];
                            [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
                            NSDate *dateTime = [formatter dateFromString:check_time];
                            NSInteger check_time_interval = [timeZone secondsFromGMTForDate:dateTime];
                            dateTime = [dateTime dateByAddingTimeInterval:check_time_interval];
                            
                            //获取当前时间
                            NSDate *currentTime = [NSDate date];
                            NSTimeZone *zone = [NSTimeZone systemTimeZone];
                            
                            NSInteger interval = [zone secondsFromGMTForDate:currentTime];
                            
                            NSDate *localeDate = [currentTime dateByAddingTimeInterval:interval];
                            
                            
                            int locationUpdateInterval = 3600*16;//16 hour
                            if ([localeDate timeIntervalSinceDate:dateTime] > locationUpdateInterval) {
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请首先进行上班签到再进行巡检" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alert.tag = 99;
                                [alert show];
                            }else{
                                selectprojectView = [[selectprojectViewController alloc] initWithNibName:@"selectprojectViewController" bundle:nil];
                                selectprojectView.delegate = self;
                                [selectprojectView setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
                                [selectprojectView setPopinOptions:BKTPopinDefault];
                                [selectprojectView setPopinAlignment:BKTPopinAlignementOptionCentered];
                                [selectprojectView setPreferedPopinContentSize:CGSizeMake(300.0, 155.0)];
                                [selectprojectView setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
                                [self.navigationController presentPopinController:selectprojectView animated:YES completion:^{
                                    //        NSLog(@"Popin presented !");
                                    
                                }];
                            }
                            
                        }
                    }
                }
            }
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
    
}

- (void)gotogetprojectinfo{
    [self getData];
}

- (void)getData
{
    //MBProgressHUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"数据加载中";
    hud.margin = 10.f;
    hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    
    
    [[ProjectInfoModel sharedInstance]getProjectInfoWithUserID:[staffModel sharedInstance].user_id successBlock:^(id responseObject, NSDictionary *userInfo) {
//        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
            if (200 == statusCode) {
                
                //设置title
                self.title = dict[@"content"][0][@"name"];
                
                _allDataAry = dict[@"content"];
                _dataAry = dict[@"content"][0][@"plans"];
                [_tableView reloadData];
//                NSLog(@"%lu",(unsigned long)_dataAry.count);
//                NSLog(@"%@",_dataAry);
            }
            else {
                //获取信息失败
            }
        }
        [hud hide:YES];
    } errorBlock:^(NSError *error) {
        [hud hide:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    headView.backgroundColor = [UIColor whiteColor];
//    headView.layer.borderWidth = 0.5;
//    headView.layer.edgeAntialiasingMask = kCALayerBottomEdge;
    headView.layer.shadowOffset = CGSizeMake(0, 2);// 设置阴影的偏移量
    headView.layer.shadowRadius = 1.0;// 设置阴影的半径
    headView.layer.shadowColor = [UIColor grayColor].CGColor;// 设置阴影的颜色为黑色
    headView.layer.shadowOpacity = 0.5;// 设置阴影的不透明度
    
//    headView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UILabel *circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50, LABELHEIGHT)];
    circleLabel.font = [UIFont systemFontOfSize:14];
    circleLabel.text = @"圈数";
    circleLabel.textColor = [UIColor grayColor];
    circleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, LABELHEIGHT)];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.text = @"完成状态";
    statusLabel.textColor = [UIColor grayColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 70, LABELHEIGHT)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = @"开始时间";
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *banciLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 5, ScreenWidth-210, LABELHEIGHT)];
    banciLabel.font = [UIFont systemFontOfSize:14];
    banciLabel.text = @"班次";
    banciLabel.textColor = [UIColor grayColor];
    banciLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [headView addSubview:circleLabel];
    [headView addSubview:statusLabel];
    [headView addSubview:timeLabel];
    [headView addSubview:banciLabel];
    
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    UILabel *circleLabel;
    UILabel *statusLabel;
    UILabel *timeLabel;
    UILabel *banciLabel;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50, LABELHEIGHT)];
        circleLabel.font = [UIFont systemFontOfSize:14];
        
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, LABELHEIGHT)];
        statusLabel.font = [UIFont systemFontOfSize:14];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 70, LABELHEIGHT)];
        timeLabel.font = [UIFont systemFontOfSize:14];
        
        banciLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 0, ScreenWidth-210, 42)];
        banciLabel.font = [UIFont systemFontOfSize:14];
        banciLabel.numberOfLines = 2;
        circleLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        banciLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:circleLabel];
        [cell addSubview:statusLabel];
        [cell addSubview:timeLabel];
        [cell addSubview:banciLabel];
    }
    
//    cell.textLabel.numberOfLines = 0;
//    NSArray *views = [cell subviews];
//    for(UIView* subview in views)
//    {
//        [subview removeFromSuperview];
//    }
    
    circleLabel.text = [NSString stringWithFormat:@"第%ld圈",(long)indexPath.row+1];
    
    NSString *checkPointIds = [_dataAry[indexPath.row] objectForKey:@"check_point_ids"];
    //NSString *checkPointIds = @"1,2,3";
    NSMutableArray *pointsAry = _allDataAry[0][@"points"];

    NSMutableArray *pointIdsAry = [[NSMutableArray alloc]init];
    for (int i =0; i<pointsAry.count; i++) {
        NSString *pointId = [NSString stringWithFormat:@"%@",pointsAry[i][@"id"]];
        [pointIdsAry addObject:pointId];
    }
    
    if ([checkPointIds isKindOfClass:[NSNull class]]) {
        statusLabel.text = @"未完成";
    }
    else {
        NSArray *temp = [checkPointIds componentsSeparatedByString:@","];
        
        if ([NSSet setWithArray:temp].count==[NSSet setWithArray:pointIdsAry].count) {
            statusLabel.text = @"已完成";
        }
        else {
            statusLabel.text = @"未完成";
        }
    }
    
    timeLabel.text = [_dataAry[indexPath.row] objectForKey:@"plan_start_time"];
    banciLabel.text = [_dataAry[indexPath.row] objectForKey:@"banci_name"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanViewController *planVc = [[PlanViewController alloc]init];
    planVc.allDataAry = _allDataAry;
    planVc.planId = [_dataAry[indexPath.row] objectForKey:@"plan_id"];
    planVc.banciId = [_dataAry[indexPath.row] objectForKey:@"banci_id"];
    planVc.planStartTime = [_dataAry[indexPath.row] objectForKey:@"plan_start_time"];
    NSString *check_Point_Ids = [_dataAry[indexPath.row] objectForKey:@"check_point_ids"];
    if ([check_Point_Ids isKindOfClass:[NSNull class]]) {
        planVc.checkPointIds = [NSMutableArray array];
    }
    else {
        NSArray *array = [check_Point_Ids componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        NSLog(@"array:%@",array);
        planVc.checkPointIds= [NSMutableArray arrayWithArray:array];
    }
    planVc.title = [NSString stringWithFormat:@"第%ld圈",(long)indexPath.row+1];
    
    [self.navigationController pushViewController:planVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //第一次安装的用户，需要调用check_time接口，如果为空，应该弹出alert提示，并push到签到页面
    if (!isfristLoad) {
        [self getData];
    }
    isfristLoad = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99 && buttonIndex == 0) {
//        signinViewController *signinVC = [[signinViewController alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
