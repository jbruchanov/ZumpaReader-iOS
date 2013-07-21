//
//  ZumpaSubItem.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaSubItem.h"

@implementation ZumpaSubItem

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
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:item.time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    item.parsedTime = [formatter stringFromDate:date];
    
    
    return item;
}
@end
