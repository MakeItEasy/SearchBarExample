//
//  City+Extensions.h
//  SearchBarExample
//
//  Created by moyan on 15-2-5.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

#ifndef SearchBarExample_City_Extensions_h
#define SearchBarExample_City_Extensions_h

#import "City.h"

@interface City (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc;
- (NSString *)sectionTitle;

@end


#endif
