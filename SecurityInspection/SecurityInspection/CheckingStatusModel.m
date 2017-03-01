//
//  CheckingStatusModel.m
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "CheckingStatusModel.h"

@implementation CheckingStatusModel

static CheckingStatusModel *checkingStatusModel;
+(CheckingStatusModel *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == checkingStatusModel)
        {
            checkingStatusModel = [[self alloc] init] ;
        }
    }
    
    return checkingStatusModel ;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void)uploadCheckingStatusWithParameters:(NSArray *)parameters successBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler
{
//    NSLog(@"1 %@",_user_id);
//    NSLog(@"2 %@",_project_id);
//    NSLog(@"3 %@",_plan_id);
//    NSLog(@"4 %@",_banci_id);
//    NSLog(@"5 %@",_point_id);
//    NSLog(@"6 %@",_check_items);
//    NSLog(@"7 %@",_status);
//    NSLog(@"8 %@",_note);
//    NSLog(@"9 %@",_image);
//    NSLog(@"10 %@",_is_start);
//    NSLog(@"11 %@",_check_time);
//    NSLog(@"12 %@",_plan_start_time);
    NSDictionary *params = @{@"root":@{@"parameters":@{
                                         @"user_id":_user_id,
                                         @"project_id":_project_id,
                                         @"plan_id":_plan_id,
                                         @"banci_id":_banci_id,
                                         @"point_id":_point_id,
                                         @"check_items":_check_items,
                                         @"status":_status,
                                         @"note":_note,
                                         @"image":_image,
                                         @"is_start":_is_start,
                                         @"check_time":_check_time,
                                         @"plan_start_time":_plan_start_time
                                         }}};
    NSString *URLString = FullURL(kURL_uploadCheckingStatus);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        errorHandler(error);
    }];
}

@end
