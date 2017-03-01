//
//  ScanViewController.m
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "ScanViewController.h"
#import "PatrolConditionViewController.h"
#import "MBProgressHUD.h"
#define SCANBUTTONX  100/320*ScreenWidth
#define SCANBUTTONY  420/480*ScreenHeight
#define SCANBUTTONWIDTH  120/320*ScreenWidth
#define SCANBUTTONHeight  40/480*ScreenHeight

@interface ScanViewController ()

@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    NSLog(@"%f,%f",ScreenWidth,ScreenHeight);
    scanButton.frame = CGRectMake(ScreenWidth/2-60, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];

    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-145, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, 100, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    _upOrdown = NO;
    _num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-110, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
}
-(void)animation1
{
    if (_upOrdown == NO) {
        _num ++;
        _line.frame = CGRectMake(ScreenWidth/2-125, 110+2*_num, 250, 2);
        if (2*_num == 280) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
        _line.frame = CGRectMake(ScreenWidth/2-125, 110+2*_num, 250, 2);
        if (_num == 0) {
            _upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [_timer invalidate];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    [_timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    NavBar.hidden = YES;
//    [self setupCamera];
    [self checkAVAuthorizationStatus];
}

- (void)checkAVAuthorizationStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
    if(status == AVAuthorizationStatusDenied) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        // Configure for text only and offset down
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请在设置-隐私-相机中\n允许智慧管家访问相机应用。";
//        hud.labelColor = [UIColor blackColor];
//        hud.margin = 10.f;
//        hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
//        hud.color = RGB(1.0, 1.0, 1.0);
//        hud.removeFromSuperViewOnHide = YES;
//        //        [self.navigationController popViewControllerAnimated:YES];
//        [hud hide:YES afterDelay:3];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"请在设置-隐私-相机中允许智慧管家访问相机应用。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self setupCamera];
    }
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(ScreenWidth/2-140,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"xxxxx%@",stringValue);
    }
    
    //扫描出来的结果要跟code这个字段进行比对，相同时push下级页面，不同时返回上级页面并弹出提示框
    if ([stringValue isEqualToString:_pointCode]) {
        [_timer invalidate];
        [_session stopRunning];
        PatrolConditionViewController *patrolConditionVC = [[PatrolConditionViewController alloc]init];
        patrolConditionVC.planId = _planId;
        patrolConditionVC.banci_id = _banciId;
        patrolConditionVC.pointId = _pointId;
        patrolConditionVC.needImage = _needImage;
        patrolConditionVC.is_start = _isStart;
        patrolConditionVC.planStartTime = _planStartTime;
        patrolConditionVC.dataAry = [NSMutableArray array];
        for (NSDictionary *itemDic in _dataAry) {
            if ([patrolConditionVC.pointId isEqualToString:[itemDic objectForKey:@"point_id"]]) {
                [patrolConditionVC.dataAry addObject:itemDic];
            }
        }
//        NSLog(@"%@",patrolConditionVC.dataAry);
        patrolConditionVC.allDataAry = _allDataAry;
        [self.navigationController pushViewController:patrolConditionVC animated:YES];
    }
    else {
        [_timer invalidate];
        [_session stopRunning];
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"扫描结果与当前巡检点不匹配。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
