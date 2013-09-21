//
//  ZumpaSubViewCell.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaSubViewCell.h"

@interface ZumpaSubViewCell()

@property (weak, nonatomic) ZumpaSubItem *item;
@property (readwrite, nonatomic) int height;

@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIView *strip;
@property (strong, nonatomic) NSString *parsedTime;


@end

@implementation ZumpaSubViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.message setScrollEnabled:NO];
    }
    return self;
}

-(void)setItem:(ZumpaSubItem*)item withSurvey:(BOOL) createSurvey{
    [self.message setScrollEnabled:NO];//TODO:better place for this
    _item = item;
    if(item.authorFake){
        self.author.text = [NSString stringWithFormat:@"%@ (%@)", item.authorFake, item.authorReal];
    }else{
        self.author.text = item.authorReal;
    }
    
    if(item.hasInsideUris){
        self.message.dataDetectorTypes = UIDataDetectorTypeLink;
    }else{
        self.message.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    
    self.message.text = item.body;
    self.time.text = item.parsedTime;
    
    if(item.survey){
        if(createSurvey){//createSurvey can be false, when viewcontrollerl has survey in cache, and will be added in few moments later
            self.survey = [[UISurvey alloc]initWithSurvey:item.survey forTop:self.message.contentSize.height andWidth:self.frame.size.width];
            self.survey.delegate = self.surveyDelegate;
            [self addSubview:self.survey];
        }else{
            if(self.survey){
                [self.survey setSurvey:item.survey];
            }
        }
    }
}

-(UIFont*) fontForMeasurement{
    return [UIFont fontWithName:self.message.font.fontName size:self.message.font.pointSize];
}

-(int)surveyHeight{
    return (self.survey) ? self.survey.frame.size.height: 0;
}

@end