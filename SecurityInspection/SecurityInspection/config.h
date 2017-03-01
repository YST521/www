//
//  config.h
//  SecurityInspection
//
//  Created by chase on 15/4/20.
//  Copyright (c) 2015年 chase. All rights reserved.
//

#ifndef SecurityInspection_config_h
#define SecurityInspection_config_h

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define NSNumWithInt(i)      ([NSNumber numberWithInt:(i)])
#define NSNumWithFloat(f)    ([NSNumber numberWithFloat:(f)])
#define NSNumWithBool(b)     ([NSNumber numberWithBool:(b)])
#define  CACHES_FOLDER_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define  DOCUMENT_FOLDER_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APPLICATION_SUPPORT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define LANUCH_DIRECTORY    [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:@"LanuchImg"]
#define ApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#define SharedApplication [UIApplication sharedApplication]
#define MainBundle [NSBundle mainBundle]
#define MainScreen [UIScreen mainScreen]
#define NavBar self.navigationController.navigationBar
#define TabBar self.tabBarController.tabBar
#define NavBarHeight self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ViewWidth(v) v.frame.size.width
#define ViewHeight(v) v.frame.size.height
#define ViewX(v) v.frame.origin.x
#define ViewY(v) v.frame.origin.y
#define SelfViewWidth self.view.bounds.size.width
#define SelfViewHeight self.view.bounds.size.height
#define RGB(r, g, b) [UIColor colorWithRed:r green:g blue:b alpha:1.0]
#define kLoginButtonFont [UIFont fontWithName:@"HelveticaNeue-Light" size:20] != nil ? [UIFont fontWithName:@"HelveticaNeue-Light" size:20] : [UIFont systemFontOfSize:20]
#define NAVIGATIONBARHEIGHT  44
#define STATUSBARHEIGHT 20
#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
// Colors
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define ThemeColor RGB(242, 242, 242)
#define ControlColor RGB(0, 205, 249)
#define BGColor RGB(233, 233, 233)
#define DarkTextColor RGB(51, 51, 51)
#define GrayTextColor RGB(136, 136, 136)
#define BackGrayColor RGB(60, 60, 60)

//

//baiduMap key
#define baiduMapKey @"25mF07OEDKH46hBoTzIdVjc3"

// Server API URLs

#ifdef TARGET_VERSION_BETA
//Beta Server
//#define ServerUrl @"http://180.168.71.206:580/youchi/index.php?option=com_check&method="
//#define ImageURL @"http://180.168.71.206:580/youchi/"
#define ServerUrl @"http://120.24.240.191/youchi/index.php?option=com_check&method="
#define ImageURL @"http://120.24.240.191/youchi/"
#else
//Live Server
#define ServerUrl @""

#endif

#define kURL_login @"login"//done
#define kURL_getInformations @"getInformations"//done
#define kURL_updateWorkingStatus @"updateWorkingStatus"//done
#define kURL_uploadGPSInfo @"uploadGPSInfo"//done
#define kURL_getProjectInfo @"getProjectInfo"//done
#define kURL_uploadCheckingStatus @"uploadCheckingStatus"//done
#define kURL_getLastCheckInTime @"getLastCheckInTime"//done
#define kURL_getOwnerInfo @"getOwnerInfo"//done
#define kURL_getProjects @"getProjects"//unuse


#define ImageURLLaunch @"youchi_ads/"
#define FullImageURL(x, y) [[ImageURL stringByAppendingString:x] stringByAppendingString:y]
#define FullURL(x) [ServerUrl stringByAppendingString:x]

#endif

