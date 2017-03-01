//
//  GPSModel.m
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "GPSModel.h"

@implementation GPSModel

static GPSModel *gpsModel;
+(GPSModel *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == gpsModel)
        {
            gpsModel = [[self alloc] init] ;
        }
    }
    
    return gpsModel ;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void)uploadGPSWithArray:(NSMutableArray *)array successBlock:(RequestSuccessBlock)successHandler
                errorBlock:(RequestErrorBlock)errorHandler
{
    NSDictionary *params = @{@"root":@{@"parameters":array}};
    NSString *URLString = FullURL(kURL_uploadGPSInfo);
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
