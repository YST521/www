//
//  LoginViewController.h
//  SecurityInspection
//
//  Created by logic on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)NSString    *password;
@property (nonatomic,strong)NSString    *userName;
@property (nonatomic,strong)UITextField *userNameText;
@property (nonatomic,strong)UITextField *passwordText;
@property (nonatomic,strong)UIButton    *loginBtn;
@property (nonatomic,strong)UIButton    *backBtn;
@end
