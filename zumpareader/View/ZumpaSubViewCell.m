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

@synthesize item = _item;
@synthesize height = _height, parsedTime = _parsedTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setItem:(ZumpaSubItem*)item{
    _item = item;
    self.author.text = item.authorReal;
    if(item.hasInsideUris){
        self.message.dataDetectorTypes = UIDataDetectorTypeLink;
    }else{
        self.message.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    self.message.text = item.body;
    self.time.text = item.parsedTime;
}

@end
