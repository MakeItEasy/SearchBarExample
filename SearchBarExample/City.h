//
//  City.h
//  SearchBarExample
//
//  Created by moyan on 15-2-5.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * spelling;
@property (nonatomic, retain) NSString * desc;

@end
