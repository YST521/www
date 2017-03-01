//
//  ProjectInfoModel.m
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "ProjectInfoModel.h"

@implementation ProjectInfoModel


static ProjectInfoModel *projectModel;
+(ProjectInfoModel *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == projectModel)
        {
            projectModel = [[self alloc] init] ;
        }
    }
    
    return projectModel ;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void)getProjectInfoWithUserID:(NSString *)user_id successBlock:(RequestSuccessBlock)successHandler
                      errorBlock:(RequestErrorBlock)errorHandler
{
    NSDictionary *params = @{@"root":@{@"parameters":@{
                                     @"user_id":user_id,
                                     @"project_id":[UserDefaults objectForKey:@"project_id"],
                                     @"banci_id":[UserDefaults objectForKey:@"banci_id"]
                                     }}};
//    NSLog(@"%@",params);
    NSString *URLString = FullURL(kURL_getProjectInfo);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorHandler(error);
        
    }];
}

- (void)getowerinfosuccessBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler{
    NSString *URLString = FullURL(kURL_getOwnerInfo);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorHandler(error);
        
    }];
}
@end
