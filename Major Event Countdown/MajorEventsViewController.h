//
//  ViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 08/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorEvent.h"
#import "iAd/AdBannerView.h"
#import "AddMajorEventViewController.h"

@interface MajorEventsViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, ADBannerViewDelegate, AddMajorEventViewControllerDelegate>

@property (nonatomic, retain) IBOutlet ADBannerView *adView;

@property (nonatomic, retain) IBOutlet UISearchDisplayController* searchController;
@property IBOutlet UISearchBar *evnetsSearchBar;

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@property (nonatomic, retain) NSMutableArray* majorEvents;
@property (nonatomic, retain) NSMutableArray* json;
@property (nonatomic, retain) NSMutableArray* sections;
@property (nonatomic, retain) NSMutableArray* listOfItems;
@property (retain, nonatomic) NSMutableArray* filteredEventsArray;
@property (retain, nonatomic) NSMutableArray* personalEvents;

@property (strong, atomic) NSString* category;
@property (readonly) IBOutlet UIBarButtonItem* revealButtonItem;

@property BOOL isFiltered;

@property (nonatomic, retain) MajorEvent* selectedMajorEvent;

@property CGFloat initialTableHeight;

- (void) setEventCategory:(NSString *) category withFilteredEvents:(BOOL) isFiltered;

@end
