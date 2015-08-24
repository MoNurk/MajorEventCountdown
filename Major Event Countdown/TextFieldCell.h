//
//  LoginCell.h
//  VirtualEventCentre
//
//  Created by Muhammed Nurkerim on 17/09/2012.
//
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell {
    UITextField * cellTextField;
}

@property (nonatomic, retain) IBOutlet UITextField * cellTextField;

@end
