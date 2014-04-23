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

    if(item.survey){
//        self.survey = [[UISurvey alloc]initWithSurvey:item.survey forTop:self.message.contentSize.height andWidth:self.frame.size.width];
//        self.survey.delegate = self.surveyDelegate;
//        [self.childViews addSubview:self.survey];
    }
    [self layoutIfNeeded];
}

+ (ZRSubViewCell *)create {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZRSubViewCell" owner:nil options:nil] lastObject];
}

@end
