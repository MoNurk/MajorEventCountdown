//
//  Category.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 13/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize name = _name;

- (Category *) initWithCategoryName:(NSString *)categoryName
{
    _name = categoryName;
    
    return self;
}

@end
