//
//  City+Extensions.m
//  SearchBarExample
//
//  Created by moyan on 15-2-5.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

#import "City+Extensions.h"

@implementation City (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City"
                                              inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        NSArray *cities = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *item in cities)
        {
            City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City"
                                                             inManagedObjectContext:moc];
            city.name = [item valueForKey:@"name"];
            city.spelling = [item valueForKey:@"spelling"];
            city.desc = [item valueForKey:@"desc"];
        }
        
        if (![moc save:&error])
        {
            NSLog(@"failed to import data: %@", [error localizedDescription]);
        }
    }
}

- (NSString *)sectionTitle
{
    return [self.spelling substringToIndex:1].uppercaseString ;
}
@end