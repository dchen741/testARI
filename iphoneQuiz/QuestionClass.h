//
//  QuestionClass.h
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/25/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionClass : NSObject

@property (nonatomic, strong) NSNumber *questionNumber;

@property (nonatomic, strong) NSNumber *JOL;

@property (nonatomic, strong) NSDate *questionDate;

- (id)initWithQuestion: (NSNumber*)questionNumber andJOL:(NSNumber*)JOL andDate:(NSDate*)questionDate;



@end
