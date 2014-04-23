//
//  UISurvey.m
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "UISurvey.h"
#import "UISurveyButton.h"
#import "I18N.h"

#define MSG_FONT_NAME @"Verdana"
#define MSG_FONT_SIZE 13.0

@interface UISurvey()

@property (nonatomic, strong) UILabel* question;
@property (nonatomic, strong) NSArray* buttons;

@end

@implementation UISurvey


- (id)initWithSurvey:(Survey*) survey
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initUIWithSurvey:survey];
        self.survey = survey;
    }
    return self;
}

- (void)initUIWithSurvey:(Survey *)survey {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[survey.answers count]];

    //question
    NSString *question = [NSString stringWithFormat:@"%@\n%@: %d", survey.question, NSLoc(@"Responses"), survey.responsesSum];
    [self createQuestionView:question];

    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc]init];
    [viewsDictionary setObject:self.question forKey:@"question"];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[question]-10-|" options:0 metrics:nil views:viewsDictionary]];

    NSString *vertConstrain = @"V:|-[question]";

    for (int i = 0, n = [survey.answers count]; i < n; i++) {
        NSString *ans = [survey.answers objectAtIndex:i];
        int percentage = [[survey.percents objectAtIndex:i] intValue];

        UISurveyButton *usb = [self createSurveyButtonWithTitle:ans andPercentage:percentage andIsEnabled:i != survey.votedItem];
        usb.surveyButtonIndex = i;

        [buttons addObject:usb];
        [self addSubview:usb];

        NSString *buttonName = [NSString stringWithFormat:@"button%d", i];
        [viewsDictionary setObject:usb forKey:buttonName];

        NSString *constrain = [NSString stringWithFormat:@"|-[%@]-|", buttonName];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrain options:0 metrics:nil views:viewsDictionary]];
        vertConstrain = [vertConstrain stringByAppendingFormat:@"-2-[%@(>=40)]", buttonName];
    }

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vertConstrain options:0 metrics:nil views:viewsDictionary]];
}

-(UISurveyButton *)createSurveyButtonWithTitle:(NSString*) title andPercentage:(int)percentage andIsEnabled:(BOOL) isEnabled {
    UISurveyButton *usb = [[UISurveyButton alloc] init];
    usb.translatesAutoresizingMaskIntoConstraints = NO;
    [usb addTarget:self action:@selector(surveyButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [usb setTitle:title forState:UIControlStateNormal];
    usb.percentage = percentage;
    [usb setEnabled:isEnabled];
    return usb;
}

- (void)createQuestionView:(NSString *)question {
    self.question = [[UILabel alloc]init];
    self.question.translatesAutoresizingMaskIntoConstraints = NO;
    self.question.font = [UIFont fontWithName:MSG_FONT_NAME size:MSG_FONT_SIZE];
    self.question.numberOfLines = 5;
    self.question.lineBreakMode = NSLineBreakByWordWrapping;
    [self.question setText:question];
    [self.question setTextColor:[UIColor blackColor]];
    [self addSubview:self.question];
}

-(void) surveyButtonDidClick:(UISurveyButton*) source{
    [self.delegate didVote:source.surveyButtonIndex];
}

-(void) setSurvey:(Survey *)survey{
    NSString *question = [NSString stringWithFormat:@"%@\n%@: %d", survey.question, NSLoc(@"Responses"), survey.responsesSum];
    [self.question setText:question];
    if([self.buttons count] == [survey.answers count]){//just for sure
        for(int i = 0, n = [self.buttons count];i<n;i++){
            UISurveyButton *usb = [self.buttons objectAtIndex:i];
            usb.percentage = [[survey.percents objectAtIndex:i]intValue];
            [usb setEnabled: i != survey.votedItem];
            [usb setTitle:[survey.answers objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
}

@end
