//
//  DataSave.h
//  Clock
//
//  Created by apple on 14-3-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSave : NSObject<NSCoding,NSCopying>
@property(copy,nonatomic)NSArray * clockDates;

@end
