//
//  ZRSubViewCell.m
//  zumpareader
//
//  Created by Joe Scurab on 23/04/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZRSubViewCell.h"
#import "DetailViewController.h"

#define MSG_FONT_NAME @"Verdana"
#define MSG_FONT_SIZE 10.0

@interface ZRSubViewCell()

@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIView *strip;
@property (weak, nonatomic) IBOutlet UIView *childViews;


@end

@implementation ZRSubViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        // Initialization code
    }
    return self;
}

-(void)setItem:(ZumpaSubItem*)item
{
    _item = item;
    if(item.authorFake){
        self.author.text = [NSString stringWithFormat:@"%@ (%@)", item.authorFake, item.authorReal];
    }else{
        self.author.text = item.authorReal;
    }

    self.message.text = item.body;
    self.time.text = item.parsedTime;

    if (item.survey && !self.survey) {
        self.childViews.hidden = NO;

        self.survey = [[UISurvey alloc] initWithSurvey:item.survey];
        self.survey.delegate = self.surveyDelegate;
        [self.childViews addSubview:self.survey];
        NSDictionary *viewsDictionary = @{@"uisurvey": self.survey/*, @"message": self.message*/};
        [self.childViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[uisurvey]|"
                                                                                options:0 metrics:nil views:viewsDictionary]];
        if (!item.hasInsideUris) {
            [self.childViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[uisurvey(>=25)]|"
                                                                                    options:0 metrics:nil views:viewsDictionary]];
        }
    }

    if(item.hasInsideUris){
        self.childViews.hidden = NO;
        NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc]init];
        NSString *vConstrain = [NSString string];
        if(self.survey){
            [viewsDictionary setObject:self.survey forKey:@"uisurvey"];
        }

        for (int i = 0, n = [item.insideUrls count]; i < n; i++) {
            NSString *url = [item.insideUrls objectAtIndex:i];
            UIButton *button= [self createButton:url];

            [self.childViews addSubview:button];

            NSString *name = [NSString stringWithFormat:@"button%d", i];
            [viewsDictionary setObject:button forKey:name];

            NSString *constrain = [NSString stringWithFormat:@"|-5-[%@]-5-|", name];
            [self.childViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrain
                                                                                    options:0 metrics:nil views:viewsDictionary]];

            vConstrain = [vConstrain stringByAppendingFormat:@"-5-[%@(>=35)]", name];

        }
        if (self.survey) {
            vConstrain = [@"V:|[uisurvey(>=25)]" stringByAppendingString:vConstrain];
        } else {
            vConstrain = [@"V:|" stringByAppendingString:vConstrain];
        }
        vConstrain = [vConstrain stringByAppendingString:@"-5-|"];

        [self.childViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vConstrain
                                                                                options:0 metrics:nil views:viewsDictionary]];

    }
    [self layoutIfNeeded];
}

- (UIButton *)createButton:(NSString *)url {
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    UIImage *normal = [[UIImage imageNamed:@"home_button_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    UIImage *pressed = [[UIImage imageNamed:@"home_button_background_hit.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:pressed forState:UIControlStateHighlighted];
    [button setClearsContextBeforeDrawing:YES];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    [button setTitle:url forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont fontWithName:MSG_FONT_NAME size:MSG_FONT_SIZE];

    [button addTarget:self action:@selector(didClickOnURLButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didClickOnURLButton:(UIButton *)button {
    NSString *urlValue = button.titleLabel.text;
    if ([urlValue rangeOfString:@"portal2.dkm.cz/phorum/"].location != NSNotFound) {
        if (self.clickDelegate) {
            [self.clickDelegate didOpenZumpaLink:urlValue];
        }
    } else {
        NSURL *url = [NSURL URLWithString:urlValue];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (ZRSubViewCell *)create {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZRSubViewCell" owner:nil options:nil] lastObject];
}

@end
