//
//  PlanViewController.m
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "PlanViewController.h"
#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "PatrolConditionViewController.h"

#define LABELWIDTH  ScreenWidth/4
#define LABELHEIGHT 25

@interface PlanViewController ()

@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    NSNotificationCenter * center = [NSNotificationCenter
                                     defaultCenter];
    [center addObserver:self selector:@selector(updateCheckPointids:) name:@"updateCheckPointids" object:nil];
    [self getData];
}

- (void)updateCheckPointids:(NSNotification *)notification {
    NSString * pointid = notification.object;
    [_checkPointIds addObject:pointid];
    [_tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    NavBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData
{
    _dataAry = _allDataAry[0][@"points"];
//    NSLog(@"%@",_dataAry);
    [_tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    // 次序
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, LABELHEIGHT)];
    orderLabel.text = @"次序";
    orderLabel.textColor = [UIColor grayColor];
    orderLabel.font = [UIFont systemFontOfSize:14];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    
    //巡检点
    UILabel *patrolLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, ScreenWidth-200, LABELHEIGHT)];
    patrolLabel.text = @"巡检点";
    patrolLabel.textColor = [UIColor grayColor];
    patrolLabel.font = [UIFont systemFontOfSize:14];
    patrolLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //完成状态
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-155, 10, 80, LABELHEIGHT)];
    statusLabel.text = @"完成状态";
    statusLabel.textColor = [UIColor grayColor];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:orderLabel];
    [headView addSubview:patrolLabel];
    [headView addSubview:statusLabel];
    
    
    return headView;
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
    NSArray *views = [cell subviews];
    for(UIView* subview in views)
    {
        [subview removeFromSuperview];
    }
    
    //次序
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, LABELHEIGHT)];
//    numberLabel.text = _dataAry[indexPath.row][@"ordering"];
    numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.textAlignment = NSTextAlignmentCenter;
        
        
    //巡检点
    UILabel *pollingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-200, 42)];
    pollingLabel.text = _dataAry[indexPath.row][@"name"];
    pollingLabel.textColor = [UIColor blackColor];
    pollingLabel.font = [UIFont systemFontOfSize:14];
    pollingLabel.textAlignment = NSTextAlignmentCenter;
    pollingLabel.numberOfLines = 2;
        
    //完成状态
    UILabel *isCompleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-155, 10, 80, LABELHEIGHT)];
    NSString * printid = _dataAry[indexPath.row][@"id"];
    BOOL isupload = [_checkPointIds containsObject:printid];
    if (isupload) {
        isCompleteLabel.text = @"已完成";
    }else{
        isCompleteLabel.text = @"未完成";
    }
    isCompleteLabel.textColor = [UIColor blackColor];
    isCompleteLabel.font = [UIFont systemFontOfSize:14];
    isCompleteLabel.textAlignment = NSTextAlignmentCenter;
        
    //扫描
    UIButton *scanBtn = [[UIButton alloc]init];
    scanBtn.frame = CGRectMake(ScreenWidth-75, 7, 70,30);
    [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [scanBtn.layer setMasksToBounds:YES];
    [scanBtn.layer setCornerRadius:2.0];
    scanBtn.titleLabel.textColor = [UIColor whiteColor];
    scanBtn.tag = indexPath.row;
    if (!isupload) {
        scanBtn.backgroundColor = [UIColor redColor];
        scanBtn.enabled = YES;
        [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        scanBtn.backgroundColor = [UIColor grayColor];
        scanBtn.enabled = NO;
    }
    [cell addSubview:numberLabel];
    [cell addSubview:pollingLabel];
    [cell addSubview:isCompleteLabel];
    [cell addSubview:scanBtn];

    
    return cell;
}

- (void)scanBtnClick:(UIButton *)sender
{
    if(IOS7)
    {
        ScanViewController * scanVC = [[ScanViewController alloc]init];
//        [self presentViewController:scanVC animated:YES completion:^{
//            
//            PatrolConditionViewController *patrolConditionVC = [[PatrolConditionViewController alloc]init];
//            [self.navigationController pushViewController:patrolConditionVC animated:YES];
//            
//        }];
        scanVC.planId = _planId;
        scanVC.banciId = _banciId;
        scanVC.planStartTime = _planStartTime;
        scanVC.pointId = _dataAry[sender.tag][@"id"];
        scanVC.needImage = _dataAry[sender.tag][@"need_image"];
        scanVC.isStart = _dataAry[sender.tag][@"is_start"];
        scanVC.pointCode = _dataAry[sender.tag][@"code"];
        scanVC.allDataAry = _allDataAry;
        scanVC.dataAry = _allDataAry[0][@"items"];
        scanVC.allDataAry = _allDataAry;
        //NSLog(@"%@",scanVC.dataAry);
        [self.navigationController pushViewController:scanVC animated:YES];
    }
    else
    {
        [self scanBtnAction];
    }

}

-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        
//        NSLog(@"%@",result);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
