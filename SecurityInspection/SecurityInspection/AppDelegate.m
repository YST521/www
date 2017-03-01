//
//  AppDelegate.m
//  SecurityInspection
//
//  Created by cs on 15/4/20.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"
#import "GPSModel.h"

@interface AppDelegate ()
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
@end
BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:baiduMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    _locationDataAry = [[NSMutableArray alloc]init];
    
    IntroViewController * intro = [[IntroViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:intro];
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.10.png"] forBarMetrics:UIBarMetricsDefault];
//    [nav.navigationBar setBackgroundColor:RGB(0.70, 0.07, 0.15)];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xb91822)];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                      }];

//    NSLog(@"%f",[UIScreen mainScreen].scale);
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startLocationService
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [_locService startUserLocationService];
}

- (void)stopLocationService
{
    [_locService stopUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
    [defaulte setObject:@"YES" forKey:@"is_GPS_work"];
    [defaulte setObject:[NSString stringWithFormat:@"%.6f",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [defaulte setObject:[NSString stringWithFormat:@"%.6f",userLocation.location.coordinate.longitude] forKey:@"longitude"];
    NSDate *currentLocationTimestamp = [NSDate date];
    NSDate *lastLocationUpdateTiemstamp;
    
    int locationUpdateInterval = 10;//
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        
        lastLocationUpdateTiemstamp = [userDefaults objectForKey:@"currentMinute"];
        
        if (!([currentLocationTimestamp timeIntervalSinceDate:lastLocationUpdateTiemstamp] < locationUpdateInterval)) {
            
            [userDefaults setObject:currentLocationTimestamp forKey:@"currentMinute"];
            
            //TODO:需要保存一次
            NSDictionary * dict =@{
              @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
              @"gps_longitude":[NSNumber numberWithDouble:userLocation.location.coordinate.longitude],
              @"gps_latitude":[NSNumber numberWithDouble:userLocation.location.coordinate.latitude],
              @"time":[PublicFunction currentTime],
              @"project_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"project_id"]
              };
            [_locationDataAry addObject:dict];
        }
    }

    if (_locationDataAry.count == 20) {
        //TODO:上传GPS,满20个清除一次
        [[GPSModel sharedInstance] uploadGPSWithArray:_locationDataAry successBlock:^(id responseObject, NSDictionary *userInfo) {
//            NSLog(@"%@",responseObject);
        } errorBlock:^(NSError *error) {
        }];
        
        [_locationDataAry removeAllObjects];
    }
    //经纬度获取
//    NSLog(@"嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)backgroundHandler {
    UIApplication * app = [UIApplication sharedApplication];
    
    //声明一个任务标记 可在.h中声明为全局的  __block    UIBackgroundTaskIdentifier bgTask;
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.bgTask != UIBackgroundTaskInvalid) {
                self.bgTask = UIBackgroundTaskInvalid;
            }
        });
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self backgroundHandler];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - checkNetwork
-(void)startNotificationNetwork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    reachability=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
}

// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == NotReachable) {
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }
}

@end
