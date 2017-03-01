//
//  signinViewController.h
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface signinViewController : UIViewController<UIAlertViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong)BMKLocationService* locService;
@property (nonatomic,strong)UIButton *signInBtn;
@property (nonatomic,strong)UIButton *signOutBtn;
@property (nonatomic,strong)UIButton *onGuardBtn;

@end
