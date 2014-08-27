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
	// Do any additional setup after loading the view."
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    currentQuestion = appDelegate.questionNumber;
    progressBarFill = (float) currentQuestion/5;
    self.progressLabel.text = [NSString stringWithFormat:@"%i of 5 questions answered",currentQuestion];
    self.questionProgressBar.progress = progressBarFill;
    appDelegate.questionNumber++;
    NSString *questionString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray * questionArray = [questionString componentsSeparatedByString:@"\n"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query getObjectInBackgroundWithId:@"mbjJovYMop" block:^(PFObject *iphoneApp, NSError *error) {
        
        NSArray *correctDateArray = iphoneApp[@"correctDateArray"];
        NSArray *incorrectDateArray = iphoneApp[@"incorrectDateArray"];
        NSArray *questionPoolArray = iphoneApp[@"questionPoolArray"];
        
        int incorrectSize=0;
        for (int i=0;i<[incorrectDateArray count];i++){
            NSDate *oneDayAhead = incorrectDateArray[i];
            oneDayAhead = [oneDayAhead dateByAddingTimeInterval:60*60*24];
            //if threeDaysAhead is after today
            if ([oneDayAhead compare:[NSDate date]] == NSOrderedAscending){
                incorrectSize++;
                NSLog(@"onedayahead %@",oneDayAhead);
            }
        }
        NSLog(@"incorrect size %d",incorrectSize);
        
        int correctSize=0;
        for (int i=0;i<[correctDateArray count];i++){
            NSDate *threeDaysAhead = correctDateArray[i];
            threeDaysAhead = [threeDaysAhead dateByAddingTimeInterval:60*60*24*3];
            //if threeDaysAhead is after today
            if ([threeDaysAhead compare:[NSDate date]] == NSOrderedAscending){
                correctSize++;
                NSLog(@"3dayahead %@",threeDaysAhead);
            }
        }
        NSLog(@"correct size %d",correctSize);
        
        if (incorrectSize > 0){
            NSMutableArray *incorrectAnswerArray = iphoneApp[@"incorrectAnswerArray"];
            NSMutableArray *incorrectDateArray = iphoneApp[@"incorrectDateArray"];
            NSMutableArray *incorrectJOLArray = iphoneApp[@"incorrectJOLArray"];
            questionNumber = incorrectAnswerArray[0];
            [incorrectDateArray removeObjectAtIndex:0];
            [incorrectJOLArray removeObjectAtIndex:0];
            [iphoneApp removeObject:questionNumber forKey:@"incorrectAnswerArray"];
            iphoneApp[@"incorrectDateArray"] = incorrectDateArray;
            iphoneApp[@"incorrectJOlArray"] = incorrectJOLArray;
            [iphoneApp saveInBackground];
        }
        else if (correctSize > 0){
            NSMutableArray *correctDateArray = iphoneApp[@"incorrectDateArray"];
            NSMutableArray *correctAnswerArray = iphoneApp[@"correctAnswerArray"];
            NSMutableArray *correctJOLArray = iphoneApp[@"correctJOLArray"];
            questionNumber = correctAnswerArray[0];
            [correctDateArray removeObjectAtIndex:0];
            [correctJOLArray removeObjectAtIndex:0];
            [iphoneApp removeObject:questionNumber forKey:@"correctAnswerArray"];
            iphoneApp[@"correctDateArray"] = correctDateArray;
            iphoneApp[@"correctJOlArray"] = correctJOLArray;
            [iphoneApp saveInBackground];
        }
        else {
            int rnd = arc4random()%[questionPoolArray count];
            questionNumber = questionPoolArray[rnd];
            NSLog(@"remove %@",questionNumber);
            [iphoneApp removeObject:questionNumber forKey:@"questionPoolArray"];
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
    }];
}

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([self.answerInputTextfield.text isEqualToString:answer]){
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
