//
//  UISurveyButton.m
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "UISurveyButton.h"
#import "UIColor+Parser.h"

static CGFloat const kStripLeftMargin = 10;
static CGFloat const kStripRightMargin = 10;

@interface UISurveyButton()

@property (nonatomic, strong) UIView *bottomStrip;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSString *realTitle;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation UISurveyButton

- (id)init
{
    self = [super init];
    if (self) {
        [self initButton:YES];
    }
    return self;
}

-(void) setSurveyButtonIndex:(int)surveyButtonIndex{
    _surveyButtonIndex = surveyButtonIndex;
    [self initStrip];
}

-(void) setPercentage:(int)percentage{
    _percentage = percentage;
    [self initStrip];
    [self setTitle:self.realTitle forState:UIControlStateNormal];
}

-(void) setTitle:(NSString *)title forState:(UIControlState)state{
    self.realTitle = title;
    [super setTitle:[NSString stringWithFormat:@"%@ (%d%%)", title, self.percentage] forState:state];    
}

-(void)initButton:(BOOL) fontColors{
    
    UIImage *normal = [[UIImage imageNamed:@"home_button_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    UIImage *pressed = [[UIImage imageNamed:@"home_button_background_hit.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:pressed forState:UIControlStateHighlighted];
    [self setClearsContextBeforeDrawing:YES];
    self.titleLabel.numberOfLines = 0;
    
    /*
     Colors from android version
     Color.parseColor("#A0FF9999"),
     Color.parseColor("#A099FF99"),
     Color.parseColor("#A09999FF"),
     Color.parseColor("#A0EE99FF"),
     Color.parseColor("#A099FFFF"),
     Color.parseColor("#A0FFEE33")*/
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, kStripLeftMargin, 0, kStripRightMargin);
    
    self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:14];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    
    self.colors = [NSArray arrayWithObjects:
                   [UIColor colorWithHexString:@"#A0FF9999"],
                   [UIColor colorWithHexString:@"#A099FF99"],
                   [UIColor colorWithHexString:@"#A09999FF"],
                   [UIColor colorWithHexString:@"#A0EE99FF"],
                   [UIColor colorWithHexString:@"#A099FFFF"],
                   [UIColor colorWithHexString:@"#A0FFEE33"],nil];
    
    [self initStrip];
}

-(void) initStrip{

    NSDictionary *viewsDictionary;

    if (!self.bottomStrip) {
        self.bottomStrip = [[UIView alloc] init];
        self.bottomStrip.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bottomStrip];

        viewsDictionary = @{@"bottomStrip" : self.bottomStrip};
        //align bottom with h=4pt rule
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomStrip(4)]-4-|"
                                                                     options:0 metrics:nil views:viewsDictionary]];
    } else {
        viewsDictionary = @{@"bottomStrip" : self.bottomStrip};
    }

    if (self.widthConstraint) {
        [self removeConstraints:self.widthConstraint];
        self.widthConstraint = nil;
    }

    NSString *constraint = [NSString stringWithFormat:@"|-4-[bottomStrip(%d)]-4-|", (int)(self.percentage * 3.1f)];
    self.widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:self.widthConstraint];
    [self.bottomStrip setBackgroundColor:[self.colors objectAtIndex:self.surveyButtonIndex]];
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}

@end
