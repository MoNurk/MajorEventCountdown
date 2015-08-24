//
//  Category.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 13/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject {
    
}

@property (nonatomic, retain) NSString * name;

- (Category *) initWithCategoryName:(NSString*) categoryName;

@end
