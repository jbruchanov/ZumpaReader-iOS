//
//  ZumpaItem.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaItem.h"

@implementation ZumpaItem

+(ZumpaItem*) fromJson:(NSDictionary*)dict{
    ZumpaItem *zi = [[ZumpaItem alloc]init];
    zi.ID = [[dict valueForKey:@"ID"] integerValue];
    zi.author = [dict valueForKey:@"Author"];
    zi.subject = [dict valueForKey:@"Subject"];
    zi.responds = [[dict valueForKey:@"Responds"] integerValue];
    zi.itemsUrl = [dict valueForKey:@"ItemsUrl"];
    zi.time = [[dict valueForKey:@"Time"] longLongValue];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:zi.time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    long long time = zi.time/1000;
    if(time < 86400){
        [formatter setDateFormat:@"HH:mm"];
        zi.lastAnswerAuthor = [dict valueForKey:@"LastAnswerAuthor"];
    }else{
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    }
    
    zi.parsedTime = [formatter stringFromDate:date];

    
    return zi;
}

@end
