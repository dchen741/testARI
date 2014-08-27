//
//  ViewController.m
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)myButtonMethod
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"loadSegue" sender: self];
}

- (void)viewDidLoad
{
    //PFObject *testObject = [PFObject objectWithClassName:@"iPhoneQuizApp"];
    //[testObject saveInBackground];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval: 2 target: self selector: @selector(myButtonMethod) userInfo: nil repeats: NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
	