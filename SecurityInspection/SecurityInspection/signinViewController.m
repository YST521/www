//
//  signinViewController.m
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//



#import "signinViewController.h"
#import "LoginViewController.h"
#import "staffModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SigninselectItemView.h"
#import "UIViewController+MaryPopin.h"

#define BTNWIDTH  (ScreenWidth-30)
#define BTNHEIGHT (ScreenHeight-64-60)/3
@interface signinViewController ()<SigninselectItemDelegate,BMKGeoCodeSearchDelegate>{
    NSTimer * updatetimer;
    int times;
    SigninselectItemView *selectItemView;
    BMKGeoCodeSearch * searcher;
    BOOL isMorethan500;
//    ProjectArray * project_array;
    int signtype;
}

@property (nonatomic,strong)NSString *qiandaoTime;

@end

@implementation signinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
//    [UserDefaults setObject:@"9" forKey:@"Id"];
    times = 0;
    self.title = @"考勤签到";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _signInBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15+STATUSBARHEIGHT+NavBarHeight, BTNWIDTH, BTNHEIGHT)];
//    _signInBtn.backgroundColor = [UIColor redColor];
    [_signInBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_signInBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateHighlighted];
    [_signInBtn.layer setMasksToBounds:YES];
    [_signInBtn.layer setCornerRadius:2.0];
    //_signInBtn.showsTouchWhenHighlighted = YES;
    UIImageView *signInImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/4.5,BTNHEIGHT/2-27 ,55 ,54)];
    signInImageView.image = [PublicFunction skinFromImageName:@"qiandao_icon.png"];
    [_signInBtn addSubview:signInImageView];
    UILabel *signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2.2,BTNHEIGHT/2-27, BTNWIDTH, 54)];
    signInLabel.text = @"考勤签到";
    signInLabel.font = [UIFont systemFontOfSize:25];
    signInLabel.textColor = [UIColor whiteColor];
    [_signInBtn addSubview:signInLabel];
    [_signInBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _signOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,15+15+BTNHEIGHT+STATUSBARHEIGHT+NavBarHeight, BTNWIDTH, BTNHEIGHT)];
//    _signOutBtn.backgroundColor = [UIColor blueColor];
    [_signOutBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_signOutBtn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateHighlighted];
    [_signOutBtn.layer setMasksToBounds:YES];
    [_signOutBtn.layer setCornerRadius:2.0];
    //_signOutBtn.showsTouchWhenHighlighted = YES;
    UIImageView *signOutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/4.5,BTNHEIGHT/2-27 ,55 ,54)];
    signOutImageView.image = [PublicFunction skinFromImageName:@"qiantui_icon.png"];
    [_signOutBtn addSubview:signOutImageView];
    UILabel *signOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2.2,BTNHEIGHT/2-27, BTNWIDTH, 54)];
    signOutLabel.text = @"考勤签退";
    signOutLabel.font = [UIFont systemFontOfSize:25];
    signOutLabel.textColor = [UIColor whiteColor];
    [_signOutBtn addSubview:signOutLabel];
    [_signOutBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _onGuardBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,15+15+15+BTNHEIGHT+BTNHEIGHT+STATUSBARHEIGHT+NavBarHeight, BTNWIDTH, BTNHEIGHT)];
//    _onGuardBtn.backgroundColor = [UIColor orangeColor];
    [_onGuardBtn setBackgroundImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
    [_onGuardBtn setBackgroundImage:[UIImage imageNamed:@"5"] forState:UIControlStateHighlighted];
    [_onGuardBtn.layer setMasksToBounds:YES];
    [_onGuardBtn.layer setCornerRadius:2.0];
    //_onGuardBtn.showsTouchWhenHighlighted = YES;
    //UIImageView *onGuardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/6,BTNHEIGHT/3 ,BTNWIDTH/5.4 ,BTNHEIGHT/3)];
    UIImageView *onGuardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BTNWIDTH/6,BTNHEIGHT/2-27 ,55 ,54)];
    onGuardImageView.image = [PublicFunction skinFromImageName:@"dingdian_icon.png"];
    [_onGuardBtn addSubview:onGuardImageView];
    UILabel *onGuardLabel = [[UILabel alloc]initWithFrame:CGRectMake(BTNWIDTH/2.8,BTNHEIGHT/2-27, BTNWIDTH, 54)];
    onGuardLabel.text = @"在岗定点签到";
    onGuardLabel.font = [UIFont systemFontOfSize:25];
    onGuardLabel.textColor = [UIColor whiteColor];
    [_onGuardBtn addSubview:onGuardLabel];
    [_onGuardBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_signInBtn];
    [self.view addSubview:_signOutBtn];
    [self.view addSubview:_onGuardBtn];
}

- (void)btnClick:(UIButton *)sender
{
    
    NSString *currentTime = [PublicFunction currentTime];
    if (sender == _signInBtn) {
        signtype = 1;
        [self showselectItemView:self withmessage:[NSString stringWithFormat:@"现在时间是:%@, 您确认进行签到?",currentTime] andTime:currentTime andtype:1];
    }
    
    if (sender == _signOutBtn) {
        signtype = 2;
        UIAlertView *signInAlert2 = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"现在时间是:%@, 您确认进行签退?",currentTime] delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        signInAlert2.tag = 2;
        [signInAlert2 show];
    }
    
    if(sender == _onGuardBtn){
        signtype = 3;
        [self showselectItemView:self withmessage:[NSString stringWithFormat:@"现在时间是:%@, 您确认进行在岗定点签到?",currentTime] andTime:currentTime andtype:3];
    }
}

-(void)showselectItemView:(UIViewController *)viewController withmessage:(NSString *)msg andTime:(NSString *)time andtype:(int)type
{
    selectItemView = [[SigninselectItemView alloc] initWithNibName:@"SigninselectItemView" bundle:nil];
    selectItemView.msg = msg;
    selectItemView.time = time;
    selectItemView.type = type;
    selectItemView.delegate = self;
    [selectItemView setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
    [selectItemView setPopinOptions:BKTPopinDefault];
    [selectItemView setPopinAlignment:BKTPopinAlignementOptionCentered];
    [selectItemView setPreferedPopinContentSize:CGSizeMake(300.0, 300.0)];
    [selectItemView setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [self.navigationController presentPopinController:selectItemView animated:YES completion:^{
//        NSLog(@"Popin presented !");
        
    }];
}

- (void)goonsignin:(int)type withProject:(ProjectArray *)project{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"alertViewtag"];
    [[NSUserDefaults standardUserDefaults]setFloat:[project.latitude floatValue] forKey:@"project_lat"];
    [[NSUserDefaults standardUserDefaults]setFloat:[project.longitude floatValue] forKey:@"project_lon"];
    if (type == 1) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
        [defaulte setBool:YES forKey:@"isqiandao"];
        NSString *date = [PublicFunction currentDate];
        if (![[defaulte objectForKey:@"currentDate"] isEqualToString:date] || [defaulte objectForKey:@"currentDate"]==nil){
            [appDelegate startLocationService];
            updatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(signin:) userInfo:dict repeats:YES];
            [updatetimer fire];
        }
    }else if (type == 3){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
        
        [defaulte setObject:[formatter stringFromDate:[NSDate date]] forKey:@"currentHH"];
        [defaulte synchronize];
        updatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(signin:) userInfo:dict repeats:YES];
        [updatetimer fire];
    }
}

- (NSString *)isdistanceMorethan500:(ProjectArray *)project{
    NSString *loclatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *loclongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    BMKMapPoint locpoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([loclatitude floatValue],[loclongitude floatValue]));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults]floatForKey:@"project_lat"],[[NSUserDefaults standardUserDefaults]floatForKey:@"project_lon"]));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(locpoint,point2);
    
    if (distance >1000) {
        isMorethan500 = YES;
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([loclatitude floatValue],[loclongitude floatValue]);
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        return @"1";
    }else{
        isMorethan500 = NO;
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults]floatForKey:@"project_lat"],[[NSUserDefaults standardUserDefaults]floatForKey:@"project_lon"]);
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        return @"0";
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      NSString * name = [UserDefaults objectForKey:@"yezhu_name"];
      NSString * str;
      if (isMorethan500) {
          str = result.address;
      }else{
          str=[NSString stringWithFormat:@"%@(%@)",name,result.address];
      }
//      NSLog(@"%@",str);
      [staffModel sharedInstance].sign_address = str;
//      NSLog(@"%@",result.address);
      [self updateWorkingStatus];
//      在此处理正常结果
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

#pragma mark   UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:alertView.tag] forKey:@"alertViewtag"];
    switch (alertView.tag) {
        case 2:
            if (buttonIndex == 0) {
                [UserDefaults setBool:NO forKey:@"isqiandao"];
                if ([UserDefaults objectForKey:@"Id"]){
                    updatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(signin:) userInfo:dict repeats:YES];
                    [updatetimer fire];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)updateWorkingStatus{
    [[staffModel sharedInstance]updateWorkingStatus:signtype successBlock:^(id responseObject, NSDictionary *userInfo) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
            int returnid = [dict[@"result"][@"id"] intValue];
            NSString * Id = [NSString stringWithFormat:@"%d",returnid];
            if (200 == statusCode) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.customView = [[UIImageView alloc]initWithImage:[PublicFunction skinFromImageName:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"操作成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                if (signtype==1) {
                    NSString *date = [PublicFunction currentDate];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH"];
                    //_qiandaoTime = [formatter stringFromDate:[NSDate date]];
                    //NSLog(@"%@",date);
                    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
                    [defaulte setObject:date forKey:@"currentDate"];
                    [defaulte setObject:Id forKey:@"Id"];
                    [defaulte setObject:[formatter stringFromDate:[NSDate date]] forKey:@"currentHH"];
                    [defaulte synchronize];
                }
                if (signtype==2) {
                    [UserDefaults setObject:nil forKey:@"Id"];
                    //关闭定位功能
                    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                    [appDelegate stopLocationService];
                    
                    //将日期移除
                    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
                    //                [defaulte removeObjectForKey:@"currentDate"];
                    [defaulte removeObjectForKey:@"is_GPS_work"];
                    [defaulte removeObjectForKey:@"currentHH"];
                }
                //                    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
                //                    [defaulte setObject:nil forKey:@"latitude"];
                //                    [defaulte setObject:nil forKey:@"longitude"];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.customView = [[UIImageView alloc]initWithImage:[PublicFunction skinFromImageName:@"error.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"操作失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)signin:(NSTimer *)timer{
    NSString *is_GPS_work = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_GPS_work"];
    if (is_GPS_work || times>4) {
        times = 0;
        [updatetimer invalidate];
        [staffModel sharedInstance].sign_type = [self isdistanceMorethan500:nil];
        
    }else{
        times++;
    }
//    else{
//        if ([tag intValue]==3) {
//            UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"签退后不能进行在岗定点签到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            [updatetimer invalidate];
//        }else{
//            times++;
//            if (times>4) {
//                [updatetimer invalidate];
//                UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"无法定位，必须定位才能签到，请检查定位功能是否关闭" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show];
//            }
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    NSString *pastHH = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentHH"];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH"];
    
    
    NSString *currentHH = [formatter stringFromDate:[NSDate date]];
    if (pastHH) {
        if ([currentHH intValue]-2 > [pastHH intValue]) {
            UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已经过了两小时，请再次进行在岗定点签到。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

@end
