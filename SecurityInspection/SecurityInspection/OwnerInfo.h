//
//  OwnerInfo.h
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "ownerContent.h"

@interface OwnerInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) NSArray *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
