//
//  questionViewController.m
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "questionViewController.h"
#import "questionCorrectViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface questionViewController ()

@end

@implementation questionViewController


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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *estToday = [[NSDate date] dateByAddingTimeInterval:-60*60*5];
    NSString *questionString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *questionCategory = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray * questionArray = [questionString componentsSeparatedByString:@"\n"];
    NSArray * questionCategoryArray =[questionCategory componentsSeparatedByString:@"\n"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query getObjectInBackgroundWithId:appDelegate.rowID block:^(PFObject *iphoneApp, NSError *error) {
        
        NSNumber *questionsToday = iphoneApp[@"questionsToday"];
        progressBarFill = (float) [questionsToday integerValue]/5;
        
        self.progressLabel.text = [NSString stringWithFormat:@"%i of 5 questions answered",[questionsToday integerValue]];
        self.questionProgressBar.progress = progressBarFill;
        
        NSArray *correctDateArray = iphoneApp[@"correctDateArray"];
        NSArray *incorrectDateArray = iphoneApp[@"incorrectDateArray"];
        NSArray *questionPoolArray = iphoneApp[@"questionPoolArray"];
        
        int incorrectSize=0;
        for (int i=0;i<[incorrectDateArray count];i++){
            NSDate *oneDayAhead = incorrectDateArray[i];
            oneDayAhead = [oneDayAhead dateByAddingTimeInterval:60*60*19];
            //if oneDayAhead is after today
            if ([oneDayAhead compare:estToday] == NSOrderedAscending){
                incorrectSize++;
                NSLog(@"onedayahead %@",oneDayAhead);
            }
        }
        
        int correctSize=0;
        for (int i=0;i<[correctDateArray count];i++){
            NSDate *threeDaysAhead = correctDateArray[i];
            threeDaysAhead = [threeDaysAhead dateByAddingTimeInterval:(60*60*24*2 + 60*60*19)];
            //if threeDaysAhead is after today
            if ([threeDaysAhead compare:estToday] == NSOrderedAscending){
                correctSize++;
                NSLog(@"3dayahead %@",threeDaysAhead);
            }
        }
    
        [NSThread sleepForTimeInterval:.5];
        NSNumber *pendQuestion = iphoneApp[@"pendingQuestions"];
        if (incorrectSize > 0){
            NSMutableArray *incorrectAnswerArray = iphoneApp[@"incorrectAnswerArray"];
            NSMutableArray *incorrectDateArray = iphoneApp[@"incorrectDateArray"];
            NSMutableArray *incorrectJOLArray = iphoneApp[@"incorrectJOLArray"];
            questionNumber = incorrectAnswerArray[0];
            NSLog(@"remove %@ from incorrect",questionNumber);
            [incorrectDateArray removeObjectAtIndex:0];
            [incorrectJOLArray removeObjectAtIndex:0];
            [iphoneApp removeObject:questionNumber forKey:@"incorrectAnswerArray"];
            iphoneApp[@"incorrectDateArray"] = incorrectDateArray;
            iphoneApp[@"incorrectJOLArray"] = incorrectJOLArray;
            iphoneApp[@"pendingQuestions"] = questionNumber;
            [iphoneApp saveInBackground];
        }
        else if (correctSize > 0){
            NSMutableArray *correctDateArray = iphoneApp[@"correctDateArray"];
            NSMutableArray *correctAnswerArray = iphoneApp[@"correctAnswerArray"];
            NSMutableArray *correctJOLArray = iphoneApp[@"correctJOLArray"];
            questionNumber = correctAnswerArray[0];
            NSLog(@"remove %@ from correct",questionNumber);
            [correctDateArray removeObjectAtIndex:0];
            [correctJOLArray removeObjectAtIndex:0];
            [iphoneApp removeObject:questionNumber forKey:@"correctAnswerArray"];
            iphoneApp[@"correctDateArray"] = correctDateArray;
            iphoneApp[@"correctJOLArray"] = correctJOLArray;
            iphoneApp[@"pendingQuestions"] = questionNumber;
            [iphoneApp saveInBackground];
        }
        else if ([pendQuestion intValue] > -1){
            questionNumber = pendQuestion;
            NSLog(@"pending %@",questionNumber);
        }
        else {
            int rnd = arc4random()%[questionPoolArray count];
            questionNumber = questionPoolArray[rnd];
            NSLog(@"remove %@ from pool",questionNumber);
            [iphoneApp removeObject:questionNumber forKey:@"questionPoolArray"];
            iphoneApp[@"pendingQuestions"] = questionNumber;
            [iphoneApp saveInBackground];
        }
        
        int numberBrackets = 0;
        for (int i=0;i<[questionArray[[questionNumber integerValue]] length];i++){
            unichar ch = [questionArray[[questionNumber integerValue]] characterAtIndex:i];
            //NSLog(@"%C",ch);
            if (ch == '['){
                numberBrackets++;
            }
        }
        //NSLog(@"brackets %i",numberBrackets);
        int rndQuestion = (arc4random()%(numberBrackets))+1;
        //NSLog(@"rnd %i",rndQuestion);
        
        numberBrackets = 0;
        int leftBracketIndex;
        int rightBracketIndex;
        for (int i=0;i<[questionArray[[questionNumber integerValue]] length];i++){
            unichar ch = [questionArray[[questionNumber integerValue]] characterAtIndex:i];
            if (ch == '['){
                numberBrackets++;
                if (numberBrackets == rndQuestion){
                    leftBracketIndex = i;
                    //NSLog(@"left %i",leftBracketIndex);
                }
            }
            else if (ch == ']'){
                if (numberBrackets == rndQuestion){
                    rightBracketIndex = i;
                    //NSLog(@"right %i",rightBracketIndex);
                }
            }
        }
        
        wholeQuestion = questionArray[[questionNumber integerValue]];
        answer = [questionArray[[questionNumber integerValue]] substringWithRange:NSMakeRange(leftBracketIndex+1, rightBracketIndex-leftBracketIndex-1)];
        NSLog(answer);
        //NSLog(wholeQuestion);
        question = [questionArray[[questionNumber integerValue]] stringByReplacingCharactersInRange:NSMakeRange(leftBracketIndex, rightBracketIndex-leftBracketIndex+1) withString:@"_______"];
        
        for (int i=0;i<[question length];i++){
            unichar ch = [question characterAtIndex:i];
            if ((ch == '[') || (ch == ']')){
                question = [question stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
            }
        }
        
        for (int i=0;i<[wholeQuestion length];i++){
            unichar ch = [wholeQuestion characterAtIndex:i];
            if ((ch == '[') || (ch == ']')){
                wholeQuestion = [wholeQuestion stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
            }
        }
        self.questionTextView.text = question;
        self.questionCategoryLabel.text = questionCategoryArray[[questionNumber integerValue]];
    }];
}

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.view endEditing:YES];
    if ([[self.answerInputTextfield.text lowercaseString] isEqualToString:[answer lowercaseString]]){
        gotAnswerCorrect = true;
    }
    else gotAnswerCorrect = false;
    questionCorrectViewController *transferViewController = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"questionSegue"])
    {
        transferViewController.correctAnswerString = wholeQuestion;
        transferViewController.gotAnswerCorrect = gotAnswerCorrect;
        transferViewController.progressBarFill = progressBarFill;
        transferViewController.questionNumber = questionNumber;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
