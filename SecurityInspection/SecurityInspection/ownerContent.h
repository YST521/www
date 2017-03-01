//
//  ownerContent.h
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BanciArray.h"
#import "ProjectArray.h"


@interface ownerContent : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *contentIdentifier;
@property (nonatomic, strong) NSArray *banciArray;
@property (nonatomic, strong) NSString *yezhuName;
@property (nonatomic, strong) NSArray *projectArray;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
