//
//  ZumpaMainViewCell.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/7/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaMainViewCell.h"

@interface ZumpaMainViewCell()
@property (weak, nonatomic) IBOutlet UILabel *responds;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *date;

#define GAP 5

-(void) initUI;

@end

@implementation ZumpaMainViewCell
const static int kBottomMargin = 10;

@synthesize item = _item;

-(void) setItem:(ZumpaItem *)item{
    _item = nil;
    _item = item;
    [self initUI];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ZumpaMainViewCell"
                                                         owner:self
                                                       options:nil];
            ZumpaMainViewCell *view = [arr lastObject];
            [self addSubview:view];
            self.frame = view.frame;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) initUI{
    if(self.item){
        self.responds.text = [NSString stringWithFormat:@"%d", self.item.responds];
        self.subject.text = self.item.subject;
        self.author.text = self.item.author;
        self.date.text = self.item.parsedTime;
        
        CGRect subjectFrame = self.subject.frame;
        
        CGSize size = [self.subject.text sizeWithFont:self.subject.font constrainedToSize:CGSizeMake(subjectFrame.size.width, 100000)];
        
        CGRect newSubject = CGRectMake(subjectFrame.origin.x, subjectFrame.origin.y, subjectFrame.size.width, size.height);
        self.subject.frame = newSubject;
        
        CGRect oldOne = self.author.frame;
        self.author.frame = CGRectMake(oldOne.origin.x, size.height + GAP, oldOne.size.width, oldOne.size.height);
        
        CGRect oldDate = self.date.frame;
        self.date.frame = CGRectMake(oldDate.origin.x, size.height + GAP, oldDate.size.width, oldDate.size.height);
        
        self.frame = CGRectMake(0, 0, self.frame.size.width, size.height + oldOne.size.height + 2*GAP);
    }
}

-(int)measure{
    return self.subject.frame.origin.y + self.subject.frame.size.height + self.author.frame.size.height + kBottomMargin;
}

@end
