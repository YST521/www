//
//  CheckingStatusModel.h
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

typedef enum checkingStatusType
{
    NORMAL = 1,
    UNNORMAL = 2
}CHECKINGSTATUSTYPE;

#import <Foundation/Foundation.h>

@interface CheckingStatusModel : NSObject
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *project_id;
@property (nonatomic,strong)NSString *plan_id;
@property (nonatomic,strong)NSString *banci_id;
@property (nonatomic,strong)NSString *point_id;
@property (nonatomic,strong)NSString *check_items;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *is_start;
@property (nonatomic,strong)NSString *check_time;
@property (nonatomic,strong)NSString *plan_start_time;
+(CheckingStatusModel *)sharedInstance;

- (void)uploadCheckingStatusWithParameters:(NSArray *)parameters successBlock:(RequestSuccessBlock)successHandler errorBlock:(RequestErrorBlock)errorHandler;

@end
