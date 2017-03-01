//
//  noticeViewController.m
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "noticeViewController.h"
#import "staffModel.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "informationsModel.h"
#import "noticeTitleCell.h"
#import "noticeTableViewCell.h"
#import "managementTitleCell.h"
#import "managementCell.h"
#import "CompanyNewsViewController.h"
@interface noticeViewController (){
    NSMutableArray * readedRules;
    NSMutableArray * readedstatus;
}

@end

@implementation noticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工公告";
    _noticeArr = [NSMutableArray array];
    _managementArr = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    readedRules = [[NSUserDefaults standardUserDefaults] objectForKey:@"readedRules"];
    readedstatus= [[NSUserDefaults standardUserDefaults] objectForKey:@"readedstatus"];
    [self getdata];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [_tableView reloadData];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getdata
- (void)getdata{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"数据加载中";
    hud.margin = 10.f;
    hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [[informationsModel sharedInstance] getInformations:@"3,4" successBlock:^(id responseObject, NSDictionary *userInfo) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
            if (200 == statusCode) {
                if ([dict[@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray * arr = dict[@"content"];
                    NSMutableArray * temrulesIdarr = [NSMutableArray array];
                    NSMutableArray * temstatusIdarr = [NSMutableArray array];
                    for (NSDictionary * dic in arr) {
                        if ([dic[@"kind"] isEqualToString:@"3"]) {
                            [_noticeArr addObject:dic];
                            [temrulesIdarr addObject:dic[@"id"]];
                        }else{
                            [_managementArr addObject:dic];
                            [temstatusIdarr addObject:dic[@"id"]];
                        }
                    }
                    if (readedRules) {
                        for (NSString * str in readedRules) {
                            if (![temrulesIdarr containsObject:str]) {
                                [readedRules removeObject:str];
                            }
                        }
                    }else{
                        readedRules = [[NSMutableArray alloc]init];
                    }
                    if (readedstatus) {
                        for (NSString * str in readedstatus) {
                            if (![temstatusIdarr containsObject:str]) {
                                [readedstatus removeObject:str];
                            }
                        }
                    }else{
                        readedstatus = [[NSMutableArray alloc]init];
                    }
                    NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"modify_time" ascending:NO];
                    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
                    NSArray *sortArray=[_noticeArr sortedArrayUsingDescriptors:sortDescriptors];
                    //                    NSLog(@"公司简介%@",_introductiondic);
                    _noticeArr = [NSMutableArray arrayWithArray:sortArray];
                    NSArray *sortArray2=[_managementArr sortedArrayUsingDescriptors:sortDescriptors];
                    //                    NSLog(@"公司简介%@",_introductiondic);
                    _managementArr = [NSMutableArray arrayWithArray:sortArray2];
//                    NSLog(@"%@",dict);
//                    NSLog(@"%@",_noticeArr);
//                    NSLog(@"%@",_managementArr);
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _noticeArr.count+1;
    }else{
        return _managementArr.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
//    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if (indexPath.section == 0) {
//        if (_noticeArr.count != 0) {
//            if ([_noticeArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary * dic = _noticeArr[indexPath.row];
//                cell.textLabel.text = dic[@"title"];
//            }
//        }
//    }else{
//        if (_managementArr.count != 0) {
//            if ([_managementArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary * dic = _managementArr[indexPath.row];
//                cell.textLabel.text = dic[@"title"];
//            }
//        }
//    }
//    cell.textLabel.textColor = [UIColor blackColor];
//    cell.textLabel.numberOfLines = 0;
//    return cell;
    if (indexPath.section ==0 && indexPath.row == 0) {
        static NSString *CellTableIdentifier = @"noticeTitleCell";
        noticeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                  CellTableIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"noticeTitleCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section ==0 && indexPath.row != 0){
        static NSString *CellTableIdentifier = @"noticeTableViewCell";
        noticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        CellTableIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"noticeTableViewCell" owner:self options:nil]lastObject];
        }
        if (_noticeArr.count != 0) {
            if ([_noticeArr[indexPath.row-1] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * dic = _noticeArr[indexPath.row-1];
                    cell.title.text = dic[@"title"];
                if ([readedRules containsObject:dic[@"id"]]) {
                    cell.isreaded = YES;
                }else{
                    cell.isreaded = NO;
                }
                [cell isNeedShowNew:dic[@"modify_time"]];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        return cell;
    }else if (indexPath.section !=0 && indexPath.row == 0){
        static NSString *CellTableIdentifier = @"managementTitleCell";
        managementTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        CellTableIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"managementTitleCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *CellTableIdentifier = @"managementCell";
        managementCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          CellTableIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"managementCell" owner:self options:nil]lastObject];
        }
        if (_managementArr.count != 0) {
            if ([_managementArr[indexPath.row-1] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _managementArr[indexPath.row-1];
                cell.title.text = dic[@"title"];
                if ([readedstatus containsObject:dic[@"id"]]) {
                    cell.isReaded = YES;
                }else{
                    cell.isReaded = NO;
                }
                [cell isNeedShowNew:dic[@"modify_time"]];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyNewsViewController *companyNewsVC = [[CompanyNewsViewController alloc]init];
    if (indexPath.section ==0 && indexPath.row != 0){
        if (_noticeArr.count != 0) {
            if ([_noticeArr[indexPath.row-1] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _noticeArr[indexPath.row-1];
                companyNewsVC.content = dic[@"content"];
                companyNewsVC.contentTitle = dic[@"title"];
                NSString * notice_id = dic[@"id"];
                if (![readedRules containsObject:notice_id]) {
                    NSMutableArray * tempArr = readedRules;
//                    tempArr = [NSMutableArray array];
                    [tempArr addObject:notice_id];
                    readedRules =tempArr;
                    [[NSUserDefaults standardUserDefaults] setObject:readedRules forKey:@"readedRules"];
                }
                [self.navigationController pushViewController:companyNewsVC animated:YES];
            }
        }
    }else if (indexPath.section !=0 && indexPath.row != 0){
        if (_managementArr.count != 0) {
            if ([_managementArr[indexPath.row-1] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _managementArr[indexPath.row-1];
                companyNewsVC.content = dic[@"content"];
                companyNewsVC.contentTitle = dic[@"title"];
                NSString * notice_id = dic[@"id"];
                if (![readedstatus containsObject:notice_id]) {
                    NSMutableArray * tempArr = readedstatus;
                    [tempArr addObject:notice_id];
                    readedstatus =tempArr;
                    [[NSUserDefaults standardUserDefaults] setObject:readedstatus forKey:@"readedstatus"];
                }
                [self.navigationController pushViewController:companyNewsVC animated:YES];
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
@end
