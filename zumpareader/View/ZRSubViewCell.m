//
//  ZRSubViewCell.m
//  zumpareader
//
//  Created by Joe Scurab on 23/04/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZRSubViewCell.h"
#import "DetailViewController.h"
#import "Settings.h"
#import "UIColor+Parser.h"

#define MSG_FONT_NAME @"Verdana"
#define MSG_FONT_SIZE 10.0

@interface ZRSubViewCell()

@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIView *colorStrip;
@property (weak, nonatomic) IBOutlet UIView *childViews;

@property (strong, nonatomic) NSString *userName;

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

    if (!self.userName) {
        self.userName = [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
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
    [self initColorStrip];

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
    __block UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];



    [button setClearsContextBeforeDrawing:YES];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    [button setTitle:url forState:UIControlStateNormal];

    if ([url hasSuffix:@".jpg"] || [url hasSuffix:@".png"] || [url hasSuffix:@".jpeg"] || [url hasSuffix:@".gif"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                ^{
                    NSURL *imageURL = [NSURL URLWithString:url];
                    __block NSData *imageData;
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                            ^{
                                imageData = [NSData dataWithContentsOfURL:imageURL];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    if(!imageData || [imageData length] == 0){
                                        [self initButtonBackground:button];
                                        return;
                                    }

                                    UIImage *image = [UIImage imageWithData:imageData];
                                    if (image) {
                                        if (button) {

                                            CGFloat viewHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                                            CGFloat buttonHeight = [button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                                            CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
                                            float ratio = width / image.size.width;

                                            [button setImage:image forState:UIControlStateNormal];
                                            [button setTitle:@"" forState:UIControlStateNormal];
                                            [self.cellDelegate setHeight:(int) (1 + viewHeight - buttonHeight + (image.size.height * ratio)) forItemAtIndex:self.index];
                                        }
                                    } else {
                                        [self initButtonBackground:button];
                                    }
                                });
                            });
                });
    } else {
        [self initButtonBackground:button];
    }

    button.titleLabel.font = [UIFont fontWithName:MSG_FONT_NAME size:MSG_FONT_SIZE];

    [button addTarget:self action:@selector(didClickOnURLButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)initButtonBackground:(UIButton *)button {
    UIImage *normal = [[UIImage imageNamed:@"home_button_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    UIImage *pressed = [[UIImage imageNamed:@"home_button_background_hit.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:pressed forState:UIControlStateHighlighted];
}

- (void)didClickOnURLButton:(UIButton *)button {
    NSString *urlValue = button.titleLabel.text;
    if ([urlValue rangeOfString:@"portal2.dkm.cz/phorum/"].location != NSNotFound) {
        if (self.cellDelegate) {
            [self.cellDelegate didOpenZumpaLink:urlValue];
        }
    } else {
        NSURL *url = [NSURL URLWithString:urlValue];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (ZRSubViewCell *)create {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZRSubViewCell" owner:nil options:nil] lastObject];
}

-(void) initColorStrip{
    BOOL show = YES;
    if ([self.item.authorReal isEqualToString:self.userName]) {
        [self.colorStrip setBackgroundColor:[UIColor colorWithInt:OWN]];
    } else {
        show = NO;
    }

    [self.colorStrip setHidden:!show];
}

@end
