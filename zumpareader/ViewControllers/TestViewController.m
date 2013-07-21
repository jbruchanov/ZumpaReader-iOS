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
@interface TestViewController ()

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
    
    Survey *survey = [[Survey alloc]init];
    
    survey.question = @"Blablablabla";
    survey.answers = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];
    survey.percents = [NSArray arrayWithObjects:@"10",@"40",@"50",@"0", nil];
    survey.votedItem = 2;
    survey.responds = 15;
    UISurvey *uisurvey = [[UISurvey alloc]initWithSurvey:survey forTop:0 andWidth:self.view.frame.size.width];
    
    [self.view addSubview:uisurvey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
