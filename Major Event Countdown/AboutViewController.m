//
//  AboutViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 21/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize revealButtonItem;

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
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)visitWebsite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mo-apps.co.uk"]];
}

- (NSString *) saveFilePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"personalEvents.plist"];
}

- (IBAction)deleteAllPersonalEvents:(id)sender
{
    UIActionSheet* confirmDelete = [[UIActionSheet alloc]
                                    initWithTitle:@"Are you sure?"
                                    delegate:self
                                    cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete"
                                    otherButtonTitles:nil, nil];
    
    [confirmDelete showInView: [self view]];
}

#pragma mark UIActionSheet methods

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        NSError* error;
        
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:[self saveFilePath]]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self saveFilePath] error:&error];
            if (success) {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle:@"Deleted"
                                      message:@"All personal events have been deleted"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
    }
}

@end
