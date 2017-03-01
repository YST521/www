//
//  GuideViewController.m
//  SecurityInspection
//
//  Created by cs on 15/4/20.
//  Copyright (c) 2015年 cs. All rights reserved.
//

#import "GuideViewController.h"
#import "mainViewController.h"
#import "MBProgressHUD.h"
#import "staffModel.h"

#define btnTop 60
#define btnJG 10
#define btnLeftJG 25
#define btnWidth (ScreenWidth -btnLeftJG*2-btnJG)/2
#define btnHeight btnWidth

@interface GuideViewController ()

@end

@implementation GuideViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NavBar.hidden = YES;
    int width = (int)(ScreenWidth/2);
    //int hight = (int)(ScreenHeight/2);
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    UIImageView * bgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgview.image= [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgview];
    _anbaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnLeftJG, btnTop, btnWidth, btnHeight)];
    [_anbaoBtn setImage:[UIImage imageNamed:@"security"] forState:UIControlStateNormal];
    [_anbaoBtn.layer setMasksToBounds:YES];
    [_anbaoBtn.layer setCornerRadius:2.0];
    [_anbaoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _baojieBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+btnJG/2, btnTop, btnWidth, btnHeight)];
    [_baojieBtn setImage:[UIImage imageNamed:@"clean"] forState:UIControlStateNormal];
    [_baojieBtn.layer setMasksToBounds:YES];
    [_baojieBtn.layer setCornerRadius:2.0];
    [_baojieBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnLeftJG, btnTop+btnHeight+btnJG, btnWidth, btnHeight)];
    [_kefuBtn setImage:[UIImage imageNamed:@"customerservice"] forState:UIControlStateNormal];
    [_kefuBtn.layer setMasksToBounds:YES];
    [_kefuBtn.layer setCornerRadius:2.0];
    [_kefuBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _gongchengBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+btnJG/2, btnTop+btnHeight+btnJG, btnWidth, btnHeight)];
    [_gongchengBtn setImage:[UIImage imageNamed:@"repair"] forState:UIControlStateNormal];
    [_gongchengBtn.layer setMasksToBounds:YES];
    [_gongchengBtn.layer setCornerRadius:2.0];
    [_gongchengBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight-80, 100, 40)];
    label.text = @"智慧管家";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self.view addSubview:_anbaoBtn];
    [self.view addSubview:_baojieBtn];
    [self.view addSubview:_kefuBtn];
    [self.view addSubview:_gongchengBtn];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = YES;
    
    // 不需要GuideView
//    NSString *UserDefaultsappVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"VERSIONNEW"];
//    if (UserDefaultsappVersion == nil) {
//        [self showGuide];
//    }
//    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"VERSIONNEW"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showGuide
{
    _guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_guideView];
    [self.view bringSubviewToFront:_guideView];
}

- (void)BtnClick:(UIButton *)sender {
    if (sender == _anbaoBtn) {
        mainViewController * main = [[mainViewController alloc]init];
        [self.navigationController pushViewController:main animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"还在开发中，敬请期待！";
        hud.labelColor = [UIColor blackColor];
        hud.margin = 10.f;
        hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
        hud.color = RGB(1.0, 1.0, 1.0);
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1];
    }
    
}
@end
