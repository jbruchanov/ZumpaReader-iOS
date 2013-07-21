//
//  UISurvey.h
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"

@protocol UISurveyDelegate

-(void) didVote:(int) surveyButtonIndex;

@end

@interface UISurvey : UIView

//this is must respect same structure like firstly set one (same number of buttons)
@property (nonatomic, strong) Survey* survey;

@property (nonatomic, weak) id<UISurveyDelegate> delegate;

- (id)initWithSurvey:(Survey*) survey forTop:(int) top andWidth:(int)width;

+ (int) estimateHeight:(Survey*) survey forWidth:(int) width;

@end
