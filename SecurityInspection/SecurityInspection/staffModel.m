//
//  staffModel.m
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "staffModel.h"
#import "ProjectInfoModel.h"

@implementation staffModel
static staffModel *staff;
+(staffModel*)sharedInstance
{
    @synchronized(self)
    {
        if (nil == staff)
        {
            staff = [[self alloc] init] ;
        }
    }
    
    return staff ;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (LOGINTYPE)loginType{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (user_id == nil) {
        return LOGINFAIL;
    }
    return LOGINSUCCESS;
}

- (NSString *)user_id
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (user_id == nil) {
        return nil;
    }
    return user_id;
}

-(void)login:(NSString *)userName withpassword:(NSString *)password successBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler{
    NSDictionary *params = @{@"root":@{@"parameters":@{
                                     @"username":userName,
                                     @"password":password
                                     }}};
    NSString *URLString = FullURL(kURL_login);
//    NSLog(@"%@",URLString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorHandler(error);
    }];
}

- (void)updateWorkingStatus:(int)type successBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler{
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    if(latitude == nil){
        latitude = @"";
    }
    if(longitude == nil){
        longitude = @"";
    }
    NSString * banci_id;
    if ([UserDefaults  objectForKey:@"banci_id"]) {
        banci_id = [UserDefaults  objectForKey:@"banci_id"];
    }else{
        banci_id = @"";
    }
    self.banci_type = @"";
    NSString * yezhuid = [UserDefaults objectForKey:@"yezhu_id"];
    NSArray * oinfo=[ProjectInfoModel sharedInstance].owerinfo.content;
    for (ownerContent * comen in oinfo) {
        if ([comen.contentIdentifier isEqualToString:yezhuid]) {
            for (BanciArray * ban in comen.banciArray) {
                if ([ban.banciId isEqualToString:banci_id]) {
                    self.banci_type  = ban.banciType;
                    break;
                }
            }
            break;
        }
    }
    NSString * start_time;
    NSString * end_time;
    NSString * Id;
    if ([UserDefaults  objectForKey:@"Id"]) {
        Id = [UserDefaults  objectForKey:@"Id"];
    }else{
        Id = @"";
    }

    if ([UserDefaults  objectForKey:@"start_time"]) {
        start_time = [UserDefaults  objectForKey:@"start_time"];
    }else{
        start_time = @"";
    }
    if ([UserDefaults  objectForKey:@"end_time"]) {
        end_time = [UserDefaults  objectForKey:@"end_time"];
    }else{
        end_time = @"";
    }
    switch (type) {
        case kqqd:
            end_time = @"";
            Id = @"";
            break;
        case kqqt:
            banci_id = @"";
            start_time = @"";
            break;
        case ddqd:
            start_time = @"";
            end_time = @"";
            Id = @"";
            break;
            
        default:
            break;
    }
//    NSLog(@"1_%@",self.user_id);
//    NSLog(@"2_%@",longitude);
//    NSLog(@"3_%@",latitude);
//    NSLog(@"4_%@",[NSNumber numberWithInt:type]);
//    NSLog(@"5_%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"project_id"]);
//    NSLog(@"6_%@",banci_id);
//    NSLog(@"7_%@",start_time);
//    NSLog(@"8_%@",end_time);
//    NSLog(@"9_%@",Id);
//    NSLog(@"10_%@",self.sign_address);
//    NSLog(@"11_%@",self.sign_type);
//    NSLog(@"12_%@",self.banci_type);
    NSDictionary *params = @{@"root":@{@"parameters":@{
                                     @"user_id":self.user_id,
                                     @"gps_longitude":longitude,
                                     @"gps_latitude":latitude,
                                     @"type":[NSNumber numberWithInt:type],
                                     @"project_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"project_id"],
                                     @"banci_id":banci_id,
                                     @"start_time":start_time,
                                     @"end_time":end_time,
                                     @"id":Id,
                                     @"sign_address":self.sign_address,
                                     @"sign_type":self.sign_type,
                                     @"banci_type":self.banci_type
                                     }}};
    NSString *URLString = FullURL(kURL_updateWorkingStatus);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorHandler(error);
    }];
}

- (void)requestCheckTimeSuccessBlock:(RequestSuccessBlock)successHandler
                          errorBlock:(RequestErrorBlock)errorHandler{
    NSDictionary *params = @{@"root":@{@"parameters":@{
                                               @"user_id":self.user_id
                                               }}};
    NSString *URLString = FullURL(kURL_getLastCheckInTime);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorHandler(error);
    }];

}

@end
