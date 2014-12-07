//
//  finalViewController.m
//  iphoneQuiz
//
//  Modified by Dennis Chen throughout 2014
//  Created by Dennis Chen on 11/2/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "finalViewController.h"

@interface finalViewController ()

@end

@implementation finalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
    numberOfBadges = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
