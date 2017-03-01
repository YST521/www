//
//  BanciArray.m
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BanciArray.h"


NSString *const kBanciArrayCode = @"code";
NSString *const kBanciArrayBanciId = @"banci_id";
NSString *const kBanciArrayBanciName = @"banci_name";
NSString *const kBanciArrayStartTime = @"start_time";
NSString *const kBanciArrayEndTime = @"end_time";
NSString *const kBanciArrayBanciType = @"banci_type";


@interface BanciArray ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BanciArray

@synthesize code = _code;
@synthesize banciId = _banciId;
@synthesize banciName = _banciName;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize banciType = _banciType;


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
            self.code = [self objectOrNilForKey:kBanciArrayCode fromDictionary:dict];
            self.banciId = [self objectOrNilForKey:kBanciArrayBanciId fromDictionary:dict];
            self.banciName = [self objectOrNilForKey:kBanciArrayBanciName fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kBanciArrayStartTime fromDictionary:dict];
            self.endTime = [self objectOrNilForKey:kBanciArrayEndTime fromDictionary:dict];
            self.banciType = [self objectOrNilForKey:kBanciArrayBanciType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.code forKey:kBanciArrayCode];
    [mutableDict setValue:self.banciId forKey:kBanciArrayBanciId];
    [mutableDict setValue:self.banciName forKey:kBanciArrayBanciName];
    [mutableDict setValue:self.startTime forKey:kBanciArrayStartTime];
    [mutableDict setValue:self.endTime forKey:kBanciArrayEndTime];
    [mutableDict setValue:self.banciType forKey:kBanciArrayBanciType];

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

    self.code = [aDecoder decodeObjectForKey:kBanciArrayCode];
    self.banciId = [aDecoder decodeObjectForKey:kBanciArrayBanciId];
    self.banciName = [aDecoder decodeObjectForKey:kBanciArrayBanciName];
    self.startTime = [aDecoder decodeObjectForKey:kBanciArrayStartTime];
    self.endTime = [aDecoder decodeObjectForKey:kBanciArrayEndTime];
    self.banciType = [aDecoder decodeObjectForKey:kBanciArrayBanciType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_code forKey:kBanciArrayCode];
    [aCoder encodeObject:_banciId forKey:kBanciArrayBanciId];
    [aCoder encodeObject:_banciName forKey:kBanciArrayBanciName];
    [aCoder encodeObject:_startTime forKey:kBanciArrayStartTime];
    [aCoder encodeObject:_endTime forKey:kBanciArrayEndTime];
    [aCoder encodeObject:_banciType forKey:kBanciArrayBanciType];
}

- (id)copyWithZone:(NSZone *)zone
{
    BanciArray *copy = [[BanciArray alloc] init];
    
    if (copy) {

        copy.code = [self.code copyWithZone:zone];
        copy.banciId = [self.banciId copyWithZone:zone];
        copy.banciName = [self.banciName copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.endTime = [self.endTime copyWithZone:zone];
        copy.banciType = [self.banciType copyWithZone:zone];
    }
    
    return copy;
}


@end
