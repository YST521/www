//
//  staffModel.h
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

typedef enum tagLoginType
{
    LOGINSUCCESS = 1,
    LOGINFAIL = 2
}LOGINTYPE;

typedef enum tagSigninType
{
    kqqd = 1,//考勤签到
    kqqt = 2,//考勤签退
    ddqd = 3//在岗定点签到
}SigninType;

#import <Foundation/Foundation.h>

@interface staffModel : NSObject
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *userName;
@property (nonatomic, strong) NSString      *password;
@property (nonatomic, assign) LOGINTYPE     loginType;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *project_id;
@property (nonatomic, strong) NSString      *project_name;
@property (nonatomic, assign) NSString      *banci_type;
@property (nonatomic, assign) NSString      *sign_type;
@property (nonatomic, assign) NSString      *sign_address;

+(staffModel*)sharedInstance;

- (void)login:(NSString *)userName withpassword:(NSString *)password
 successBlock:(RequestSuccessBlock)successHandler
   errorBlock:(RequestErrorBlock)errorHandler;

- (void)updateWorkingStatus:(int)type
               successBlock:(RequestSuccessBlock)successHandler
                 errorBlock:(RequestErrorBlock)errorHandler;


- (void)requestCheckTimeSuccessBlock:(RequestSuccessBlock)successHandler
                          errorBlock:(RequestErrorBlock)errorHandler;

@end
