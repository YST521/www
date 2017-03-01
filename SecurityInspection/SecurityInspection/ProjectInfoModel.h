//
//  ProjectInfoModel.h
//  SecurityInspection
//
//  Created by logic on 15/4/28.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OwnerInfo.h"

@interface ProjectInfoModel : NSObject

@property (nonatomic,strong)NSString *project_id;
@property (nonatomic,strong)NSString *project_name;
@property (nonatomic,strong)NSString *project_address;
@property (nonatomic,strong)NSString *project_note;

@property (nonatomic,strong)NSString *plan_id;
@property (nonatomic,strong)NSString *plan_name;
@property (nonatomic,strong)NSString *plan_start_time;
@property (nonatomic,strong)NSString *banci_id;
@property (nonatomic,strong)NSString *banci_code;
@property (nonatomic,strong)NSString *banci_name;
@property (nonatomic,strong)NSString *check_point_ids;

@property (nonatomic,strong)NSString *point_id;
@property (nonatomic,strong)NSString *point_code;
@property (nonatomic,strong)NSString *point_name;
@property (nonatomic,strong)NSString *point_ordering;
@property (nonatomic,strong)NSString *is_star;
@property (nonatomic,strong)NSString *is_end;
@property (nonatomic,strong)NSString *need_image;

@property (nonatomic,strong)NSString *item_id;
@property (nonatomic,strong)NSString *item_content;
@property (nonatomic,strong)OwnerInfo * owerinfo;

+(ProjectInfoModel *)sharedInstance;

- (void)getProjectInfoWithUserID:(NSString *)user_id successBlock:(RequestSuccessBlock)successHandler
                      errorBlock:(RequestErrorBlock)errorHandler;
- (void)getowerinfosuccessBlock:(RequestSuccessBlock)successHandler
                      errorBlock:(RequestErrorBlock)errorHandler;

@end
