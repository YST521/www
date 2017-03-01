//
//  GPSModel.h
//  SecurityInspection
//
//  Created by cs on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSModel : NSObject

@property (nonatomic,strong)NSString * gps_longitude;
@property (nonatomic,strong)NSString * gps_latitude;
@property (nonatomic,strong)NSString * timeStr;

+(GPSModel *)sharedInstance;

- (void)uploadGPSWithArray:(NSMutableArray *)array successBlock:(RequestSuccessBlock)successHandler
                    errorBlock:(RequestErrorBlock)errorHandler;

@end
