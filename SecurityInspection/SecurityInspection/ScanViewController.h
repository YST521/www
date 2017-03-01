//
//  ScanViewController.h
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic)int num;
@property (nonatomic)BOOL upOrdown;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)UIImageView * line;
@property (nonatomic,strong)NSString *planId;
@property (nonatomic,strong)NSString *banciId;
@property (nonatomic,strong)NSString *planStartTime;
@property (nonatomic,strong)NSString *pointId;
@property (nonatomic,strong)NSString *needImage;
@property (nonatomic,strong)NSString *isStart;
@property (nonatomic,strong)NSString *pointCode;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *allDataAry;

@end
