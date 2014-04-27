//
//  ZRMainViewCell.m
//  zumpareader
//
//  Created by Joe Scurab on 12/02/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZRMainViewCell.h"
#import "UIColor+Parser.h"
#import "Settings.h"


@interface ZRMainViewCell()

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *itemsCount;
@property (weak, nonatomic) IBOutlet UILabel *threadAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIView *colorStrip;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *toU1;
@property (strong, nonatomic) NSString *toU2;

@end


@implementation ZRMainViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ZumpaItem *)item {
    _item = item;
    [self initUI];
}

-(void) initUI{
    if (!self.userName) {
        self.userName = [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
        if(self.userName && [self.userName length] > 0){
            self.toU1 = [NSString stringWithFormat:@"2%@", self.userName];
            self.toU2 = [NSString stringWithFormat:@"2 %@", self.userName];
        }
    }
    if(self.item){
        self.itemsCount.text = [NSString stringWithFormat:@"%d", self.item.responds];
        self.subject.text = self.item.subject;
        self.threadAuthor.text = self.item.author;
        if(self.item.lastAnswerAuthor){
            self.bottomRightLabel.text = [NSString stringWithFormat:@"%@  %@", self.item.lastAnswerAuthor, self.item.parsedTime];
        }else{
            self.bottomRightLabel.text = self.item.parsedTime;
        }
        [self resetColorStrip];
        [self layoutIfNeeded];
    }
}

-(void) resetColorStrip{
    BOOL show = YES;
    if (self.item.favoriteThread) {
        [self.colorStrip setBackgroundColor:[UIColor colorWithInt:FAVORITE]];
    } else if ([self.item.author isEqualToString:self.userName]) {
        [self.colorStrip setBackgroundColor:[UIColor colorWithInt:OWN]];
    } else if ([self.item.subject rangeOfString:self.toU1].location != NSNotFound
            || [self.item.subject rangeOfString:self.toU2].location != NSNotFound) {
        [self.colorStrip setBackgroundColor:[UIColor colorWithInt:MSG_4U]];
    } else {
        show = NO;
    }

    [self.colorStrip setHidden:!show];
}

@end
