//
//  ZRMainViewCell.m
//  zumpareader
//
//  Created by Joe Scurab on 12/02/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZRMainViewCell.h"


@interface ZRMainViewCell()

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *itemsCount;
@property (weak, nonatomic) IBOutlet UILabel *threadAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UIView *conView;

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
    if(self.item){
        self.itemsCount.text = [NSString stringWithFormat:@"%d", self.item.responds];
        self.subject.text = self.item.subject;
        self.threadAuthor.text = self.item.author;
        if(self.item.lastAnswerAuthor){
            self.bottomRightLabel.text = [NSString stringWithFormat:@"%@  %@", self.item.lastAnswerAuthor, self.item.parsedTime];
        }else{
            self.bottomRightLabel.text = self.item.parsedTime;
        }
        [self layoutIfNeeded];
    }
}

@end
