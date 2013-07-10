//
//  ZumpaItem.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaItem.h"

@implementation ZumpaItem

@synthesize ID = _ID;
@synthesize author = _author;
@synthesize subject = _subject;
@synthesize responds = _responds;
@synthesize itemsUrl = _itemsUrl;

+(ZumpaItem*) fromJson:(NSDictionary*)dict{
    ZumpaItem *zi = [[ZumpaItem alloc]init];
    zi.ID = [[dict valueForKey:@"ID"] integerValue];
    zi.author = [dict valueForKey:@"Author"];
    zi.subject = [dict valueForKey:@"Subject"];
    zi.responds = [[dict valueForKey:@"Responds"] integerValue];
    zi.itemsUrl = [dict valueForKey:@"ItemsUrl"];
    zi.time = [[dict valueForKey:@"ItemsUrl"] longLongValue];
    return zi;
}

@end
