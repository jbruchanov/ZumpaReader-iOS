//
//  ZRSubViewCell.m
//  zumpareader
//
//  Created by Joe Scurab on 23/04/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZRSubViewCell.h"


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
        [self.childViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[uisurvey(>=25)]|"
                                                                                options:0 metrics:nil views:viewsDictionary]];
    }
    [self layoutIfNeeded];
}

+ (ZRSubViewCell *)create {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZRSubViewCell" owner:nil options:nil] lastObject];
}

@end
