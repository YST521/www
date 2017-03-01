//
//  informationsModel.h
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

typedef enum tagInformationType
{
    COMPANYINTRODUCTION = 1,
    NEWS = 2,
    NOTICE = 3,
    MANAGEMENTSYSTEM = 4
}INFORMATIONTYPE;

#import <Foundation/Foundation.h>

@interface informationsModel : NSObject
@property (nonatomic, strong) NSString            *title;
@property (nonatomic, strong) NSString            *content;
@property (nonatomic, strong) NSString            *modify_time;
@property (nonatomic, assign) INFORMATIONTYPE     InformationType;
@property (nonatomic, retain) NSMutableArray      *readedNews;//公司新闻
@property (nonatomic, retain) NSMutableArray      *readedRules;//公司制度
@property (nonatomic, retain) NSMutableArray      *readedstatus;//项目情况

+(informationsModel*)sharedInstance;

- (void)getInformations:(NSString *)kinds
 successBlock:(RequestSuccessBlock)successHandler
   errorBlock:(RequestErrorBlock)errorHandler;
@end
