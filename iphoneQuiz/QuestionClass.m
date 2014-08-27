//
//  QuestionClass.m
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/25/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "QuestionClass.h"

@implementation QuestionClass

- (id)initWithQuestion:(NSNumber *)questionNumber andJOL:(NSNumber *)JOL andDate:(NSDate *)questionDate {
    self = [super init];
    
    if (self) {
        
        _questionNumber = questionNumber;
        _JOL = JOL;
        _questionDate = questionDate;
        
    }
    
    return self;
    
}




@end
