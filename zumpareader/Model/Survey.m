//
//  Survey.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Survey.h"

@implementation Survey

@synthesize answers = _answers;
@synthesize ID = _ID;
@synthesize percents = _percents;
@synthesize question = _question;
@synthesize responds = _responds;
@synthesize votedItem = _votedItem;

+(Survey*) fromJson:(NSDictionary*)jsonDict{
    if(!jsonDict){
        return nil;
    }
    Survey *item = [[Survey alloc] init];
    
    item.answers = [jsonDict valueForKey:@"Answers"];
    item.ID = [[jsonDict valueForKey:@"ID"] intValue];
    item.percents = [jsonDict valueForKey:@"Percents"];
    item.question = [jsonDict valueForKey:@"Question"];
    item.responds = [[jsonDict valueForKey:@"Responds"] intValue];
    item.votedItem = [[jsonDict valueForKey:@"VotedItem"] intValue];

    return item;
}
@end
