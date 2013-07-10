//
//  ZumpaSubItem.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaSubItem.h"

@implementation ZumpaSubItem

@synthesize authorReal = _authorReal;
@synthesize authorFake = _authorFake;
@synthesize body = _body;
@synthesize time = _time;
@synthesize hasResponseForYou = _hasResponseForYou;
@synthesize hasInsideUris = _hasInsideUris;
@synthesize insideUrls = _insideUrls;
@synthesize survey = _survey;

+(ZumpaSubItem*) fromJson:(NSDictionary*)dict{
    ZumpaSubItem *item = [[ZumpaSubItem alloc] init];
    
    item.authorReal = [dict valueForKey:@"AuthorReal"];
    item.authorFake = [dict valueForKey:@"AuthorFake"];
    item.body = [dict valueForKey:@"Body"];
    item.time = [[dict valueForKey:@"Time"] longLongValue];
    item.hasResponseForYou = [[dict valueForKey:@"HasRespondForYou"] boolValue];
    item.hasInsideUris = [[dict valueForKey:@"HasInsideUris"] boolValue];
    if(item.hasInsideUris){
        item.insideUrls = [dict valueForKey:@"InsideUris"];
    }
    item.survey = [Survey fromJson:[dict valueForKey:@"Survey"]];
    return item;
}
@end
