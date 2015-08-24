//
//  ManagePersonalEventsViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 28/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "ManagePersonalEventsViewController.h"
#import "MajorEvent.h"
#import "SWRevealViewController.h"

@interface ManagePersonalEventsViewController ()

@end

@implementation ManagePersonalEventsViewController

@synthesize personalEvents = _personalEvents;
@synthesize personalItems = _personalItems;
@synthesize revealButtonItem = _revealButtonItem;
@synthesize tableView = _tableView;
@synthesize selectedRow = _selectedRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.revealViewController.panGestureRecognizer setDelegate:self];
    [_tableView addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    _personalEvents = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
    
    _personalItems = [[NSMutableArray alloc] init];
    for (NSArray* values in _personalEvents) {
        MajorEvent* majorEvent = [[MajorEvent alloc] initWithEventId:0 eventName:[self checkIfNull:[values objectAtIndex:0]] eventDescription:[self checkIfNull:[values objectAtIndex:1]] eventCategory:[self checkIfNull:[values objectAtIndex:4]] eventUTCDate:[self checkIfNull:[values objectAtIndex:3]] eventNotes:[self checkIfNull:[values objectAtIndex:2]]];
        
        [_personalItems addObject:majorEvent];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (NSString*)checkIfNull:(NSString*) value
{
    if (value == Nil || value == nil || value == NULL) {
        value = @"";
        
        return value;
    }
    else {
        return value;
    }
}

- (NSString *) saveFilePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"personalEvents.plist"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_personalItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text =  (NSString*)[[_personalItems objectAtIndex:indexPath.row] eventName];
    cell.detailTextLabel.text = (NSString*)[[_personalItems objectAtIndex:indexPath.row] eventDescription];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete" delegate:self cancelButtonTitle:@"Do Nothing" destructiveButtonTitle: nil otherButtonTitles: @"Delete Event", nil];
    
    [actionSheet showInView:self.view];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.

    _selectedRow = indexPath.row;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_personalEvents removeObjectAtIndex:_selectedRow];
        [_personalItems removeObjectAtIndex:_selectedRow];
        
        [_personalEvents writeToFile:[self saveFilePath] atomically:YES];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_personalEvents removeObjectAtIndex:_selectedRow];
        [_personalItems removeObjectAtIndex:_selectedRow];
        
        [_personalEvents writeToFile:[self saveFilePath] atomically:YES];
        
        [_tableView reloadData];
    }
}

@end
