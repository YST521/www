//
//  AppDelegate.h
//  SecurityInspection
//
//  Created by cs on 15/4/20.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKLocationServiceDelegate>
{
    Reachability  *reachability;
}
@property (nonatomic,strong)NSMutableArray *locationDataAry;
@property (nonatomic,strong)BMKLocationService* locService;
@property (strong, nonatomic) UIWindow *window;
- (void)startLocationService;
- (void)stopLocationService;

@end

