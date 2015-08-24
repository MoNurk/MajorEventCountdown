//
//  MajorEventCell.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 11/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MajorEventCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel * eventName;
@property (nonatomic, strong) IBOutlet UILabel * eventDescription;
@property (nonatomic, strong) IBOutlet UILabel * eventDate;

@end
