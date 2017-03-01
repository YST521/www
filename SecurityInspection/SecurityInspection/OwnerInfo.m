//
//  OwnerInfo.m
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OwnerInfo.h"



NSString *const kOwnerInfoResult = @"result";
NSString *const kOwnerInfoContent = @"content";


@interface OwnerInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OwnerInfo

@synthesize result = _result;
@synthesize content = _content;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.result = [Result modelObjectWithDictionary:[dict objectForKey:kOwnerInfoResult]];
    NSObject *receivedContent = [dict objectForKey:kOwnerInfoContent];
    NSMutableArray *parsedContent = [NSMutableArray array];
    if ([receivedContent isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedContent) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedContent addObject:[ownerContent modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedContent isKindOfClass:[NSDictionary class]]) {
       [parsedContent addObject:[ownerContent modelObjectWithDictionary:(NSDictionary *)receivedContent]];
    }

    self.content = [NSArray arrayWithArray:parsedContent];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.result dictionaryRepresentation] forKey:kOwnerInfoResult];
    NSMutableArray *tempArrayForContent = [NSMutableArray array];
    for (NSObject *subArrayObject in self.content) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForContent addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForContent addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForContent] forKey:kOwnerInfoContent];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.result = [aDecoder decodeObjectForKey:kOwnerInfoResult];
    self.content = [aDecoder decodeObjectForKey:kOwnerInfoContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kOwnerInfoResult];
    [aCoder encodeObject:_content forKey:kOwnerInfoContent];
}

- (id)copyWithZone:(NSZone *)zone
{
    OwnerInfo *copy = [[OwnerInfo alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
