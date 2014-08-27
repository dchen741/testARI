//
//  questionViewController.h
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionViewController : UIViewController {
    NSString *wholeQuestion;
    NSString *question;
    NSString *answer;
    int currentQuestion;
    NSNumber *questionNumber;
    bool gotAnswerCorrect;
    float progressBarFill;
}

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextField *answerInputTextfield;
@property (weak, nonatomic) IBOutlet UIProgressView *questionProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end
