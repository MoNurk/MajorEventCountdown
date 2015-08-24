//
//  MenuViewController.h
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * categories;
@property (nonatomic, retain) NSMutableArray* json;
@property (nonatomic, retain) NSMutableArray* listOfItems;

@property BOOL filter;

@end
