//
//  TestViewController.m
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "TestViewController.h"
#import "UISurvey.h"
#import "Survey.h"
#import "UISurveyButton.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UIView *innerView;
@end

@implementation TestViewController

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

////    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
//    UILabel *label1 = [[UILabel alloc]init];
//    label1.translatesAutoresizingMaskIntoConstraints = NO;
//    label1.text = @"Hovno Vole";
//    label1.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.8];
//
//    UILabel *label2 = [[UILabel alloc]init];
//    label2.translatesAutoresizingMaskIntoConstraints = NO;
//    label2.text = @"Hovno Vole2";
//    label2.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.8];
//
//    UISurveyButton *button = [[UISurveyButton alloc]init];
//    button.translatesAutoresizingMaskIntoConstraints = NO;
//    [button setTitle:@"Hovno" forState:UIControlStateNormal];
//    button.percentage = 100;
//    button.surveyButtonIndex = 2;
////    label2.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.8];
//
//    UISurveyButton *button2 = [[UISurveyButton alloc]init];
//    button2.translatesAutoresizingMaskIntoConstraints = NO;
//    [button2 setTitle:@"Hovno\nDruhyHovno\nDruhyHovno\nDruhyHovno\nDruhyHovno\nDruhyHovno" forState:UIControlStateNormal];
//    button2.percentage = 66;
//    button.surveyButtonIndex = 4;
////    label2.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.8];
//
//    [self.innerView addSubview:label1];
//    [self.innerView addSubview:label2];
//    [self.innerView addSubview:button];
//    [self.innerView addSubview:button2];

//    NSDictionary *viewsDictionary =
//            NSDictionaryOfVariableBindings(label1, label2, button, button2);
//    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[label1]|"
//                                                                           options:0 metrics:nil views:viewsDictionary]];
//    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[label2]|"
//                                                                           options:0 metrics:nil views:viewsDictionary]];
//    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button]|"
//                                                                           options:0 metrics:nil views:viewsDictionary]];
//    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button2]|"
//                                                                           options:0 metrics:nil views:viewsDictionary]];
//    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label1(50)]-5-[label2]-5-[button(>=40)]-5-[button2(>=40)]|"
//                                                                           options:0 metrics:nil views:viewsDictionary]];

    Survey *survey = [[Survey alloc]init];
    survey.ID = 1;
    survey.answers = @[@"Answer 1", @"Answer 2", @"Answer 3",@"Answer 1", @"Answer 2", @"Answer 3"];
    survey.percents= @[@10, @40, @30,@10,@10,@10];
    survey.responsesSum = 100;
    survey.votedItem = -1;
    survey.question= @"Haaaleluje buuch ta miluje pico!";

    UISurvey *uisurvey = [[UISurvey alloc] initWithSurvey:survey];


    [self.innerView addSubview:uisurvey];

        NSDictionary *viewsDictionary =
            NSDictionaryOfVariableBindings(uisurvey);
    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[uisurvey]|"
                                                                           options:0 metrics:nil views:viewsDictionary]];
    [self.innerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[uisurvey]|"
                                                                           options:0 metrics:nil views:viewsDictionary]];

    // Height constraint, half of parent view height
//    [self.innerView addConstraint:[NSLayoutConstraint constraintWithItem:button
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.innerView
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:0.5
//                                                           constant:0]];




//    Survey *survey = [[Survey alloc]init];
//    
//    survey.question = @"Blablablabla";
//    survey.answers = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];
//    survey.percents = [NSArray arrayWithObjects:@"10",@"40",@"50",@"0", nil];
//    survey.votedItem = 2;
//    survey.responsesSum = 15;
//    UISurvey *uisurvey = [[UISurvey alloc]initWithSurvey:survey forTop:0 andWidth:self.view.frame.size.width];
//    
//    [self.view addSubview:uisurvey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
