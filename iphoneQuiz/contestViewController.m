//
//  contestViewController.m
//  iphoneQuiz
//
//  Created by Dennis Chen on 9/2/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "contestViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface contestViewController ()

@end

@implementation contestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)nextViewFunction:(id)sender{
    NSLog(@"AKSLFJLKSJFLKSDJFKLSDJFLKSJFSLKDJFKLSJFLSKD WORK PLZ");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query getObjectInBackgroundWithId:appDelegate.rowID block:^(PFObject *iphoneApp, NSError *error) {
        self.questionNumber = iphoneApp[@"pendingQuestions"];
        NSDate *estToday = [NSDate date];
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:flags fromDate:estToday];
        estToday = [calendar dateFromComponents:components];
        iphoneApp[@"pendingQuestions"] = @-1;
        [iphoneApp saveInBackground];
        [NSThread sleepForTimeInterval:1];
        [iphoneApp addObject:self.questionNumber forKey:@"correctAnswerArray"];
        [iphoneApp addObject:self.JOL forKey:@"correctJOLArray"];
        [iphoneApp addObject:estToday forKey:@"correctDateArray"];
        [iphoneApp saveInBackground];
        
        //date formatter to y/m/d
        NSMutableArray *dateArray = iphoneApp[@"correctDateArray"];
        NSMutableArray *JOLArray = iphoneApp[@"correctJOLArray"];
        NSMutableArray *correctArray = iphoneApp[@"correctAnswerArray"];
        NSMutableArray *contestMispelled = iphoneApp[@"contestMispelled"];
        NSMutableArray *contestIncorrect = iphoneApp[@"contestIncorrect"];
        NSMutableArray *contestObsolete = iphoneApp[@"contestObsolete"];
        NSMutableArray *contestAnswers = iphoneApp[@"contestAnswers"];
        NSMutableArray *contestCorrect = iphoneApp[@"contestCorrect"];
        NSString *pendingContest = iphoneApp[@"pendingContest"];
        NSMutableArray *questionArray = [[NSMutableArray alloc] init];
        
        if([self.CONTESTED intValue] == 1){
            [contestMispelled addObject:self.questionNumber];
        }
        else if ([self.CONTESTED intValue] == 2){
            [contestIncorrect addObject:self.questionNumber];
        }
        else if ([self.CONTESTED intValue] == 3){
            [contestObsolete addObject:self.questionNumber];
        }
        else {
            [contestCorrect addObject:self.questionNumber];
        }
        [contestAnswers addObject:pendingContest];
        
        int n = 0;
        NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
        [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];
        NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
        NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
        //for datearray, if date = today, n++
        for (int i=0;i<[dateArray count];i++){
                //NSLog(@"%@",[dateComparisonFormatter stringFromDate:dateArray[i]]);
                QuestionClass *question = [[QuestionClass alloc]initWithQuestion:correctArray[i] andJOL:JOLArray[i] andDate:dateArray[i]];
                if ([[dateComparisonFormatter stringFromDate:estToday] isEqualToString:[dateComparisonFormatter stringFromDate:dateArray[i]]]){
                    //NSLog(@"same date");
                    [questionArray addObject:question];
                    //NSLog(@"question# %d",[incorrectArray[i] integerValue]);
                    //NSLog(@"JOL %d",[JOLArray[i] integerValue]);
                    //NSLog(@"%@",dateArray[i]);
                    n++;
                }
                else{
                    //NSLog(@"different date");
                    [sortedQuestionArray addObject:question.questionNumber];
                    [sortedJOLArray addObject:question.JOL];
                }
            }
            
        //sort questionArray into sortedArray by JOL
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"JOL" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [questionArray sortedArrayUsingDescriptors:sortDescriptors];
            
        //NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
        //NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
        for (int i=0;i<[sortedArray count];i++){
                QuestionClass *temp = sortedArray[i];
                [sortedQuestionArray addObject:temp.questionNumber];
                [sortedJOLArray addObject:temp.JOL];
                //NSLog(@"%d",[sortedQuestionArray[i] integerValue]);
        }
        
        iphoneApp[@"contestMispelled"]= contestMispelled;
        iphoneApp[@"contestIncorrect"]= contestIncorrect;
        iphoneApp[@"contestObsolete"]= contestObsolete;
        iphoneApp[@"correctJOLArray"] = sortedJOLArray;
        iphoneApp[@"contestCorrect"]= contestCorrect;
        iphoneApp[@"correctAnswerArray"] = sortedQuestionArray;
        iphoneApp[@"contestAnswers"] = contestAnswers;
        [iphoneApp saveInBackground];

        NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
        numberOfBadges -=1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
        
        NSNumber *questionsToday = iphoneApp[@"questionsToday"];
        if ([questionsToday integerValue] == 5){
            [self performSegueWithIdentifier:@"contestFinishSegue" sender:sender];
        }
        else {
            [self performSegueWithIdentifier:@"contestNavigatorSegue" sender:sender];
        }
        [iphoneApp saveInBackground];
    }];
    
}

- (IBAction)mispelledAnswer:(id)sender {
    self.JOL = @1;
    self.CONTESTED = @1;
    [self nextViewFunction:(id)sender];
}
- (IBAction)incorrectAnswer:(id)sender {
    self.JOL = @1;
    self.CONTESTED = @2;
    [self nextViewFunction:(id)sender];
}
- (IBAction)obsoleteAnswer:(id)sender {
    self.JOL = @1;
    self.CONTESTED = @3;
    [self nextViewFunction:(id)sender];
}
- (IBAction)correctAnswer:(id)sender {
    self.JOL = @1;
    self.CONTESTED = @4;
    [self nextViewFunction:(id)sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    contestViewController *transferViewController = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"contestBackSegue"])
    {
        transferViewController.correctAnswerString = self.correctAnswerString;
        transferViewController.answerBoldLeft = self.answerBoldLeft;
        transferViewController.answerBoldRight = self.answerBoldRight;
        transferViewController.answer = self.answer;
        transferViewController.userAnswer = self.userAnswer;
        transferViewController.gotAnswerCorrect = self.gotAnswerCorrect;
        transferViewController.progressBarFill = self.progressBarFill;
        transferViewController.questionNumber = self.questionNumber;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
