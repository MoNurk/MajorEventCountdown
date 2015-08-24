//
//  AddMajorEventViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 27/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "AddMajorEventViewController.h"
#import "TextFieldCell.h"

@interface AddMajorEventViewController ()

@end

@implementation AddMajorEventViewController

@synthesize majorEvent = _majorEvent, placeholderTexts = _placeholderTexts, tableView = _tableView, dateTo = _dateTo;
@synthesize delegate = _delegate;
@synthesize customBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect navBarFrame = CGRectMake(0, 0, self.view.frame.size.width, 64.0);
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    
    UINavigationItem *navItem = [UINavigationItem alloc];
    navItem.title = @"Add Your Own Event";
    
    [navBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [navBar setTranslucent:NO];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];

    [navItem setLeftBarButtonItem:cancelButton];
    [navItem setRightBarButtonItem:doneButton];
    
    [navBar pushNavigationItem:navItem animated:false];
    
    [self.view addSubview:navBar];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardAndPicker)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:gestureRecognizer];
    
    _placeholderTexts = [[NSMutableArray alloc] initWithObjects:@"Event Name", @"Event Description", @"Notes", @"Event Date", nil];
    _majorEvent = [[MajorEvent alloc] init];
    [_majorEvent setEventName:@""];
    [_majorEvent setEventDescription:@""];
    [_majorEvent setEventDate:@""];
    [_majorEvent setNotes:@""];
    [_majorEvent setCategory:@"Personal"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideKeyboardAndPicker
{
    [self.view endEditing:YES];
    
    if (_datePicker) {
        [_datePicker removeFromSuperview];
    }
}

- (void)dateToPickerChanged:(id)sender
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *dateToShow = [dateFormatter stringFromDate:[sender date]];
    _dateTo = dateToShow;
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString *dateToSave = [dateFormatter stringFromDate:[sender date]];
    [_majorEvent setEventDate:dateToShow];
    [_tableView reloadData];
}

- (IBAction)updateEventDetails:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:(TextFieldCell*)[[[sender superview] superview] superview]];
    
    if (indexPath.row == 0) {
        [_majorEvent setEventName:((UITextField *)sender).text];
        NSLog(@"%@", [_majorEvent eventName]);
    }
    else if (indexPath.row == 1) {
        [_majorEvent setEventDescription:((UITextField *)sender).text];
        NSLog(@"%@", [_majorEvent eventDescription]);
    }
    else if (indexPath.row == 2) {
        [_majorEvent setNotes:((UITextField *)sender).text];
        NSLog(@"%@", [_majorEvent notes]);
    }
}

- (IBAction)done:(id)sender
{
    if ([[_majorEvent eventName] isEqualToString:@""] ||
        [[_majorEvent eventDescription] isEqualToString:@""] ||
        [[_majorEvent notes] isEqualToString:@""] ||
        _dateTo == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please ensure all fields have been entered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else {
        
        NSMutableArray* personalEvents;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:[self saveFilePath]]) {
            personalEvents = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
        }
        else {
            personalEvents = [[NSMutableArray alloc] init];
        }
        
        NSArray* saveArray = [[NSArray alloc] initWithObjects:[_majorEvent eventName], [_majorEvent eventDescription], [_majorEvent notes], [_majorEvent eventDate], [_majorEvent category], nil];
        [personalEvents addObject:saveArray];
        [personalEvents writeToFile:[self saveFilePath] atomically:YES];
        
        [_delegate myModalViewControllerDidFinishAddingEvent:self];
    }
}

- (IBAction)cancel:(id)sender
{
    [_delegate myModalViewControllerDidCancel:self];
    
}

- (NSString *) saveFilePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"personalEvents.plist"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placeholderTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.row <= 2) {
        cell.cellTextField.placeholder = [_placeholderTexts objectAtIndex:indexPath.row];
        [[cell cellTextField] setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        
        return cell;
    }
    else {
        if (_dateTo) {
            cell.textLabel.text = _dateTo;
        } else {
            cell.textLabel.text = @"Set Date";
        }
        cell.cellTextField.hidden = YES;
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        CGRect pickerFrame = CGRectMake(0, 0, 0, 0);
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        [_datePicker setTimeZone:[NSTimeZone systemTimeZone]];
        [_datePicker addTarget:self action:@selector(dateToPickerChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker setAlpha:0];
        
        [self.view addSubview:_datePicker];
        
        [self animateDatePicker:_datePicker];
        
        NSLog(@"%@", [_datePicker timeZone]);
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Event Information";
}

#pragma mark Animation

- (void) animateDatePicker:(UIDatePicker *) picker
{
    CGFloat yTranslation = self.view.frame.size.height - _datePicker.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, yTranslation);
    picker.transform = transfrom;
    picker.alpha = picker.alpha * (-1) + 1;
    [UIView commitAnimations];
}

@end
