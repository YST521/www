//
//  LoginViewController.m
//  SecurityInspection
//
//  Created by logic on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "LoginViewController.h"
#import "staffModel.h"


#define TEXT_USERNAME_TAG      1001
#define TEXT_PASSWORD_TAG      1002
#define TEXTFIELDWIDTH  ScreenWidth/9*6
#define TEXTFIELDHEIGHT ScreenHeight/12
#define LOGINBTNWIDTH   ScreenWidth/9*7
#define LOGINBTNHEIGHT  ScreenHeight/12
#define IMAGEVIEWWIDTH  ScreenWidth/15
#define IMAGEVIEWHEIGHT ScreenWidth/15
#define LEFTVIEWWIDTH   ScreenWidth/9
#define btnWidth 60
#define btnHight 40
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //logo图片
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/3, ScreenHeight/4.5, ScreenWidth/3, ScreenWidth/3)];
    logoImageView.image = [PublicFunction skinFromImageName:@"company_logo.png"];
    [self.view addSubview:logoImageView];
//    arrow_left@3x
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, btnWidth, btnHight)];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 32, 32)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
//    _backBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:backImage];
    [self.view addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //用户名view
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/9.5,ScreenHeight/2.1 , LOGINBTNWIDTH, LOGINBTNHEIGHT)];
    userView.backgroundColor = RGB(0.96, 0.96, 0.96);
    
    UIView *userLeftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFTVIEWWIDTH, LOGINBTNHEIGHT)];
    userLeftview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 13, IMAGEVIEWWIDTH,IMAGEVIEWHEIGHT )];
    userImageView.image = [PublicFunction skinFromImageName:@"user.png"];
    [userLeftview addSubview:userImageView];
    [userView addSubview:userLeftview];
    
    _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(LOGINBTNWIDTH/7+10, 0,TEXTFIELDWIDTH-10,TEXTFIELDHEIGHT)];
    _userNameText.borderStyle = UITextBorderStyleNone;
    _userNameText.placeholder = @"请在此处输入用户名";
    _userNameText.tag = TEXT_USERNAME_TAG;
    _userNameText.returnKeyType =UIReturnKeyDone;
    _userNameText.delegate = self;
    [userView addSubview:_userNameText];
    
    userView.layer.borderWidth = 0.8;
    userView.layer.borderColor = [RGB(0.93, 0.93, 0.93)CGColor];
    
    
    //密码view
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/9.5,ScreenHeight/1.72 , LOGINBTNWIDTH, LOGINBTNHEIGHT)];
    passwordView.backgroundColor = RGB(0.96, 0.96, 0.96);
    
    UIView *passwordLeftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFTVIEWWIDTH, LOGINBTNHEIGHT)];
    passwordLeftview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 13, IMAGEVIEWWIDTH,IMAGEVIEWHEIGHT )];
    passwordImageView.image = [PublicFunction skinFromImageName:@"lock.png"];
    [passwordLeftview addSubview:passwordImageView];
    [passwordView addSubview:passwordLeftview];
    
    _passwordText = [[UITextField alloc]initWithFrame:CGRectMake(LOGINBTNWIDTH/7+10, 0, TEXTFIELDWIDTH-10, TEXTFIELDHEIGHT)];
    _passwordText.borderStyle = UITextBorderStyleNone;
    _passwordText.placeholder = @"请在此处输入密码";
    _passwordText.tag = TEXT_PASSWORD_TAG;
    _passwordText.secureTextEntry = YES;
    _passwordText.returnKeyType =UIReturnKeyDone;
    _passwordText.delegate = self;
    [passwordView addSubview:_passwordText];

    passwordView.layer.borderWidth = 0.8;
    passwordView.layer.borderColor = [RGB(0.93, 0.93, 0.93)CGColor];
    
    
    //登陆button
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/9.5,ScreenHeight/1.4 , LOGINBTNWIDTH, LOGINBTNHEIGHT)];
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[PublicFunction skinFromImageName:@"login_btn.png"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:userView];
    [self.view addSubview:passwordView];
    [self.view addSubview:_loginBtn];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userNameText resignFirstResponder];
    [_passwordText resignFirstResponder];
}
- (void)loginBtnClick:(UIButton *)sender
{
    [_userNameText resignFirstResponder];
    [_passwordText resignFirstResponder];
    [[staffModel sharedInstance]login:_userNameText.text withpassword:_passwordText.text successBlock:^(id responseObject, NSDictionary *userInfo) {
        
//        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
            if (200 == statusCode) {
                if ([dict[@"content"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *staffinfo = dict[@"content"];
                    NSString * user_id = staffinfo[@"id"];
                    NSString * name = staffinfo[@"name"];
                    NSString * password = staffinfo[@"password"];
//                    NSString * project_id = staffinfo[@"project_id"];
                    NSString * username = staffinfo[@"username"];
                    [UserDefaults setObject:user_id forKey:@"user_id"];
                    [UserDefaults setObject:name forKey:@"name"];
                    [UserDefaults setObject:password forKey:@"password"];
                    [UserDefaults setObject:username forKey:@"username"];
//                    [UserDefaults setObject:project_id forKey:@"project_id"];//
                    
//                    [UserDefaults setObject:staffinfo[@"start_time"] forKey:@"start_time"];
//                    [UserDefaults setObject:staffinfo[@"end_time"] forKey:@"end_time"];
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
-(void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NavBar.hidden = NO;
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
//    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark  UITextField  delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    [self moveView:-100];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveView:100];
}

-(void)moveView:(float)move{
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.25];
//    NSTimeInterval animationDuration = 3.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
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
