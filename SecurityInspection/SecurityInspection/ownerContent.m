//
//  Content.m
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ownerContent.h"



NSString *const kContentId = @"id";
NSString *const kContentBanciArray = @"banci_array";
NSString *const kContentYezhuName = @"yezhu_name";
NSString *const kContentProjectArray = @"project_array";


@interface ownerContent ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ownerContent

@synthesize contentIdentifier = _contentIdentifier;
@synthesize banciArray = _banciArray;
@synthesize yezhuName = _yezhuName;
@synthesize projectArray = _projectArray;


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
            self.contentIdentifier = [self objectOrNilForKey:kContentId fromDictionary:dict];
    NSObject *receivedBanciArray = [dict objectForKey:kContentBanciArray];
    NSMutableArray *parsedBanciArray = [NSMutableArray array];
    if ([receivedBanciArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBanciArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBanciArray addObject:[BanciArray modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBanciArray isKindOfClass:[NSDictionary class]]) {
       [parsedBanciArray addObject:[BanciArray modelObjectWithDictionary:(NSDictionary *)receivedBanciArray]];
    }

    self.banciArray = [NSArray arrayWithArray:parsedBanciArray];
            self.yezhuName = [self objectOrNilForKey:kContentYezhuName fromDictionary:dict];
    NSObject *receivedProjectArray = [dict objectForKey:kContentProjectArray];
    NSMutableArray *parsedProjectArray = [NSMutableArray array];
    if ([receivedProjectArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedProjectArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedProjectArray addObject:[ProjectArray modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedProjectArray isKindOfClass:[NSDictionary class]]) {
       [parsedProjectArray addObject:[ProjectArray modelObjectWithDictionary:(NSDictionary *)receivedProjectArray]];
    }

    self.projectArray = [NSArray arrayWithArray:parsedProjectArray];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.contentIdentifier forKey:kContentId];
    NSMutableArray *tempArrayForBanciArray = [NSMutableArray array];
    for (NSObject *subArrayObject in self.banciArray) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBanciArray addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBanciArray addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBanciArray] forKey:kContentBanciArray];
    [mutableDict setValue:self.yezhuName forKey:kContentYezhuName];
    NSMutableArray *tempArrayForProjectArray = [NSMutableArray array];
    for (NSObject *subArrayObject in self.projectArray) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectArray addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectArray addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectArray] forKey:kContentProjectArray];

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

    self.contentIdentifier = [aDecoder decodeObjectForKey:kContentId];
    self.banciArray = [aDecoder decodeObjectForKey:kContentBanciArray];
    self.yezhuName = [aDecoder decodeObjectForKey:kContentYezhuName];
    self.projectArray = [aDecoder decodeObjectForKey:kContentProjectArray];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_contentIdentifier forKey:kContentId];
    [aCoder encodeObject:_banciArray forKey:kContentBanciArray];
    [aCoder encodeObject:_yezhuName forKey:kContentYezhuName];
    [aCoder encodeObject:_projectArray forKey:kContentProjectArray];
}

- (id)copyWithZone:(NSZone *)zone
{
    ownerContent *copy = [[ownerContent alloc] init];
    
    if (copy) {

        copy.contentIdentifier = [self.contentIdentifier copyWithZone:zone];
        copy.banciArray = [self.banciArray copyWithZone:zone];
        copy.yezhuName = [self.yezhuName copyWithZone:zone];
        copy.projectArray = [self.projectArray copyWithZone:zone];
    }
    
    return copy;
}


@end
