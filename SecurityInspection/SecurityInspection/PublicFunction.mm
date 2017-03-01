//
//  PublicFunction.m
//  SecurityInspection
//
//  Created by cs on 15/4/21.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#import "PublicFunction.h"
#include <sys/xattr.h>
@implementation PublicFunction

+ (NSString *)imageToBase64String:(UIImage *)image{
    if (nil == image) {
        return nil;
    }
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    NSString *encodedImageStr = [pictureData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return encodedImageStr;
}

+ (UIImage *)skinFromImageName:(NSString*)imageName
{
    if ([UIScreen mainScreen].scale == 3.0) {
        NSRange range = NSMakeRange(imageName.length-4,4);
        imageName = [imageName stringByReplacingCharactersInRange:range withString:@"@3x.png"];
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }
    else {
 
        NSRange range = NSMakeRange(imageName.length-4,4);
        imageName = [imageName stringByReplacingCharactersInRange:range withString:@"@2x.png"];
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }
}

+ (NSString*)currentTime{
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* time = [formatter stringFromDate:date];
    return time;
}

+ (NSString*)currentDate{
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* time = [formatter stringFromDate:date];
    return time;
}

+ (NSString *)currentMinute{
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    //时间精确到分钟
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    
    NSString* time = [formatter stringFromDate:date];
    return time;
}
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }else{
            NSLog(@"成功---%@",[URL lastPathComponent]);
        }
        
        return success;
        
    }else{
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    
}
@end
