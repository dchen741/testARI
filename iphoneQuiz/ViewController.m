//
//  ViewController.m
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)myButtonMethod
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"loadSegue" sender: self];
}

- (IBAction)nextView:(id)sender {
    [self myButtonMethod];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *deviceName =  [[UIDevice currentDevice] name];
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query whereKey:@"name" equalTo:deviceName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       //if there is not row with name = deviceID, create one
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            PFObject *appObject = [PFObject objectWithClassName:@"iPhoneQuizApp"];
            appObject[@"name"] = deviceName;
            [appObject saveInBackground];
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    //find row where name == deviceName
    PFQuery *query2 = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query2 whereKey:@"name" equalTo:deviceName];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved");
            // set global variable rowID = rowID
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.rowID = object.objectId;
                NSLog(@"rowID %@",appDelegate.rowID);
                PFQuery *query3 = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
                [query3 getObjectInBackgroundWithId:appDelegate.rowID block:^(PFObject *iphoneApp, NSError *error) {
                    iphoneApp[@"questionsToday"] = @0;
                    [iphoneApp saveInBackground];
                }];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [NSThread sleepForTimeInterval:1];

    //[NSTimer scheduledTimerWithTimeInterval: 2 target: self selector: @selector(myButtonMethod) userInfo: nil repeats: NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
	