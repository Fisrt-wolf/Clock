//
//  DataSave.m
//  Clock
//
//  Created by apple on 14-3-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "DataSave.h"

static NSString * const kClockDateKey = @"clockDate";

@implementation DataSave

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.clockDates = [aDecoder decodeObjectForKey:kClockDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:kClockDateKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    DataSave * tCopy = [[[self class] allocWithZone:zone] init];
    NSMutableArray * tDateCopy = [NSMutableArray array];
    for (id clockDate in self.clockDates) {
        [tDateCopy addObject:clockDate];
    }
    tCopy.clockDates = tDateCopy;
    return tCopy;
}


@end
