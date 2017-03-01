//
//  ProjectArray.m
//
//  Created by   on 15/9/17
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ProjectArray.h"


NSString *const kProjectArrayAddress = @"address";
NSString *const kProjectArrayLatitude = @"latitude";
NSString *const kProjectArrayLongitude = @"longitude";
NSString *const kProjectArrayProjectName = @"project_name";
NSString *const kProjectArrayProjectId = @"project_id";


@interface ProjectArray ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ProjectArray

@synthesize address = _address;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize projectName = _projectName;
@synthesize projectId = _projectId;


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
            self.address = [self objectOrNilForKey:kProjectArrayAddress fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kProjectArrayLatitude fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kProjectArrayLongitude fromDictionary:dict];
            self.projectName = [self objectOrNilForKey:kProjectArrayProjectName fromDictionary:dict];
            self.projectId = [self objectOrNilForKey:kProjectArrayProjectId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kProjectArrayAddress];
    [mutableDict setValue:self.latitude forKey:kProjectArrayLatitude];
    [mutableDict setValue:self.longitude forKey:kProjectArrayLongitude];
    [mutableDict setValue:self.projectName forKey:kProjectArrayProjectName];
    [mutableDict setValue:self.projectId forKey:kProjectArrayProjectId];

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

    self.address = [aDecoder decodeObjectForKey:kProjectArrayAddress];
    self.latitude = [aDecoder decodeObjectForKey:kProjectArrayLatitude];
    self.longitude = [aDecoder decodeObjectForKey:kProjectArrayLongitude];
    self.projectName = [aDecoder decodeObjectForKey:kProjectArrayProjectName];
    self.projectId = [aDecoder decodeObjectForKey:kProjectArrayProjectId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kProjectArrayAddress];
    [aCoder encodeObject:_latitude forKey:kProjectArrayLatitude];
    [aCoder encodeObject:_longitude forKey:kProjectArrayLongitude];
    [aCoder encodeObject:_projectName forKey:kProjectArrayProjectName];
    [aCoder encodeObject:_projectId forKey:kProjectArrayProjectId];
}

- (id)copyWithZone:(NSZone *)zone
{
    ProjectArray *copy = [[ProjectArray alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.projectName = [self.projectName copyWithZone:zone];
        copy.projectId = [self.projectId copyWithZone:zone];
    }
    
    return copy;
}


@end
