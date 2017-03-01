//
//  IntroViewController.m
//  SecurityInspection
//
//  Created by cs on 15/5/15.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "IntroViewController.h"
#import "GuideViewController.h"
#import "mainViewController.h"
#import "PageContntViewController.h"
#import "ProjectInfoModel.h"
#import "staffModel.h"
@interface IntroViewController ()<UIPageViewControllerDataSource>{
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *contents; // view controllers array

@end

@implementation IntroViewController

- (NSArray *)contents
{
    if (!_contents) {
        NSMutableArray *cs = [NSMutableArray array];
        for (NSInteger i = 0; i < 1; i++) {
            PageContntViewController *content = [PageContntViewController new];
            content.dataSource = FullImageURL(ImageURLLaunch, @"5.jpg");
            if (IS_IPHONE_5) {
                content.dataSource = FullImageURL(ImageURLLaunch, @"6.jpg");
            }
            if (IS_IPHONE_6) {
                content.dataSource = FullImageURL(ImageURLLaunch, @"7.jpg");
            }
            [cs addObject:content];
        }
        _contents = cs;//@[];
    }
    
    return _contents;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self.contents.count > 1) {
        self.pageController.dataSource = self;
    }
    self.pageController.view.frame = self.view.bounds;
    [self.pageController setViewControllers:@[self.contents[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [self.view insertSubview:self.pageController.view atIndex:0];
    [self.pageController didMoveToParentViewController:self];
    
    //    [self performSelector:@selector(jumpToMainViewController) withObject:nil afterDelay:3];
    [[ProjectInfoModel sharedInstance] getowerinfosuccessBlock:^(id responseObject, NSDictionary *userInfo) {
        [ProjectInfoModel sharedInstance].owerinfo = [OwnerInfo modelObjectWithDictionary:responseObject];
    } errorBlock:^(NSError *error) {
        ;
    }];
//    UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [but addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
    if ([staffModel sharedInstance].loginType == LOGINSUCCESS){
        [[staffModel sharedInstance]login:[UserDefaults stringForKey:@"username"] withpassword:[UserDefaults stringForKey:@"password"] successBlock:^(id responseObject, NSDictionary *userInfo) {
            
            //                NSLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = responseObject;
                NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
                if (200 == statusCode) {
                    if ([dict[@"content"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *staffinfo = dict[@"content"];
                        NSString * user_id = staffinfo[@"id"];
                        NSString * name = staffinfo[@"name"];
                        NSString * password = staffinfo[@"password"];
                        //                        NSString * project_id = staffinfo[@"project_id"];
                        NSString * username = staffinfo[@"username"];
                        [UserDefaults setObject:user_id forKey:@"user_id"];
                        [UserDefaults setObject:name forKey:@"name"];
                        [UserDefaults setObject:password forKey:@"password"];
                        [UserDefaults setObject:username forKey:@"username"];
                        //                        [UserDefaults setObject:project_id forKey:@"project_id"];//
                        //                        [UserDefaults setValue:staffinfo[@"banci_id"] forKey:@"banci_id"];
                        //                        [UserDefaults setObject:staffinfo[@"start_time"] forKey:@"start_time"];
                        //                        [UserDefaults setObject:staffinfo[@"end_time"] forKey:@"end_time"];
                        [UserDefaults synchronize];
                        //                    [self.navigationController popViewControllerAnimated:YES];
                        [DefaultNotificationCenter postNotificationName:@"loginfinish" object:nil];
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    }
                }else if (201 == statusCode){
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或者密码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [UserDefaults setObject:nil forKey:@"user_id"];
                }
            }
            
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
    [self performSelector:@selector(jumpToGuideController) withObject:nil afterDelay:2];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)BtnClick:(UIButton *)sender {
    [self jumpToGuideController];
}

- (void)jumpToGuideController
{
    mainViewController * main = [[mainViewController alloc]init];
    [self.navigationController pushViewController:main animated:YES];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.contents indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return self.contents[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.contents indexOfObject:viewController];
    if (index == self.contents.count - 1 || index == NSNotFound) {
        return nil;
    }
    return self.contents[++index];
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
