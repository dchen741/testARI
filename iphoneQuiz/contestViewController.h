//
//  contestViewController.h
//  iphoneQuiz
//
//  Created by Dennis Chen on 9/2/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionClass.h"

@interface contestViewController : UIViewController
@property (strong, nonatomic) NSString *correctAnswerString;
@property (strong, nonatomic) NSString *userAnswer;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSNumber *questionNumber;
@property (strong, nonatomic) NSNumber *answerBoldLeft;
@property (strong, nonatomic) NSNumber *answerBoldRight;
@property (nonatomic, assign) float progressBarFill;
@property (nonatomic, assign) BOOL questionsLeft;
@property (weak, nonatomic) IBOutlet UIButton *mispelledAnswer;
@property (nonatomic, assign) BOOL gotAnswerCorrect;
@property (strong, nonatomic) NSNumber *CONTESTED;
@property (strong, nonatomic) NSNumber *JOL;
@end
