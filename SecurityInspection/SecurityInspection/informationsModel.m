//
//  informationsModel.m
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "informationsModel.h"

@implementation informationsModel
static informationsModel *infoModel;
+(informationsModel*)sharedInstance
{
    @synchronized(self)
    {
        if (nil == infoModel)
        {
            infoModel = [[self alloc] init] ;
        }
    }
    
    return infoModel ;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}
/*
- (void)setReadedNews:(NSMutableArray *)readedNews{
    if (readedNews) {
        [[NSUserDefaults standardUserDefaults] setObject:readedNews forKey:@"readedNews"];
    }
}

- (NSMutableArray *)readedNews{
    NSMutableArray *readedNews = [[NSUserDefaults standardUserDefaults] objectForKey:@"readedNews"];
    if (readedNews == nil) {
        NSMutableArray * temp = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"readedNews"];
        return temp;
    }
    return readedNews;
}

- (void)setReadedRules:(NSMutableArray *)readedRules{
    if (readedRules) {
        [[NSUserDefaults standardUserDefaults] setObject:readedRules forKey:@"readedRules"];
    }
}

- (NSMutableArray *)readedRules{
    NSMutableArray *readedrules = [[NSUserDefaults standardUserDefaults] objectForKey:@"readedRules"];
    if (readedrules == nil) {
        NSMutableArray * temp = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"readedRules"];
        return temp;
    }
    return readedrules;
}

- (void)setReadedstatus:(NSMutableArray *)readedstatus{
    if (readedstatus) {
        [[NSUserDefaults standardUserDefaults] setObject:readedstatus forKey:@"readedstatus"];
    }
}

-(NSMutableArray *)readedstatus{
    NSMutableArray *readedstatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"readedstatus"];
    if (readedstatus == nil) {
        NSMutableArray * temp = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"readedstatus"];
        return temp;
    }
    return readedstatus;
}
*/
-(void)getInformations:(NSString *)kinds successBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler{
    NSDictionary *params = nil;
    if (kinds != nil) {
        params = @{@"root":@{@"parameters":@{
                                     @"kind":kinds
                                     }}};
    }
    NSString *URLString = FullURL(kURL_getInformations);
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
