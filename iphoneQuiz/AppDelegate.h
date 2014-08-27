//
//  AppDelegate.h
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    int questionNumber;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) int questionNumber;
@property (nonatomic,retain) NSMutableArray *tempCorrect;
@property (nonatomic,retain) NSMutableArray *tempIncorrect;

@end
