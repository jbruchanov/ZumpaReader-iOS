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
static int const kLeftMargin = 10;
static int const kRightMargin = kLeftMargin;
static int const kTopMargin = kLeftMargin;
static int const kSpacing = 10;
static CGFloat const kButtonHeight = 40;

@interface UISurvey()

@property (nonatomic, strong) UILabel* question;
@property (nonatomic, strong) NSArray* buttons;

@end

@implementation UISurvey


- (id)initWithSurvey:(Survey*) survey forTop:(int) top andWidth:(int)width;
{
    self = [super initWithFrame:[self createFrameAndUI:survey forTop:top andWidth:width]];
    if (self) {
        [self addSubview:self.question];
        for(UIButton *button in self.buttons){
            [self addSubview:button];
        }
    }
    return self;
}

-(CGRect)createFrameAndUI:(Survey*)survey forTop:(int) top andWidth:(int)width{
    
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:[survey.answers count]];
    
    int contentWidth = width - kRightMargin - kLeftMargin;
    NSString *question = [NSString stringWithFormat:@"%@\n%@: %d", survey.question, NSLoc(@"Responses"), survey.responds];
    
    self.question = [[UILabel alloc]init];//WithFrame:CGRectMake(kLeftMargin, kTopMargin, width - kRightMargin - kLeftMargin, 50)];
    CGSize size = [question sizeWithFont:self.question.font constrainedToSize:CGSizeMake(contentWidth, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    self.question.frame = CGRectMake(kLeftMargin, top + kTopMargin, contentWidth, size.height);
    self.question.numberOfLines = 5;
    self.question.lineBreakMode = UILineBreakModeWordWrap;
    
    [self.question setText:question];
    
    int y = top + kTopMargin + kSpacing + size.height;

    for(int i = 0, n = [survey.answers count]; i<n;i++){
    
        NSString *ans = [survey.answers objectAtIndex:i];
        UISurveyButton *usb = [[UISurveyButton alloc]initWithFrame:CGRectMake(kLeftMargin, y, contentWidth, kButtonHeight)];
        
        [usb addTarget:self action:@selector(surveyButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [usb setTitle:ans forState:UIControlStateNormal];
        
        int percentage = [[survey.percents objectAtIndex:i]intValue];
        usb.percentage = percentage;
        usb.surveyButtonIndex = i;
        [usb setEnabled: i != survey.votedItem];
        
        [buttons addObject:usb];
        y += kSpacing + kButtonHeight;
    }
    self.buttons = buttons;
    return CGRectMake(0, kTopMargin + top, contentWidth, y);
}

-(void) surveyButtonDidClick:(UISurveyButton*) source{
    [self.delegate didVote:source.surveyButtonIndex];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
