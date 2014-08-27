//
//  questionCorrectViewController.h
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionClass.h"

@interface questionCorrectViewController : UIViewController{
    int currentQuestion;
}

@property (strong, nonatomic) NSString *correctAnswerString;
@property (strong, nonatomic) NSNumber *questionNumber;
@property (strong, nonatomic) NSNumber *JOL;
@property (nonatomic, assign) BOOL gotAnswerCorrect;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UILabel *correctWrongLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *questionProgressBar;
@property (nonatomic, assign) float progressBarFill;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkCrossImageView;

@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b5;

@end
