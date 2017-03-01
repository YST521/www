//
//  PublicFunction.h
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject
+ (NSString *)imageToBase64String:(UIImage *)image;
+ (UIImage *)skinFromImageName:(NSString*)imageName;
+ (NSString*)currentTime;
+ (NSString*)currentDate;
+ (NSString *)currentMinute;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
