//
//  ZumpaItem.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZumpaItem : NSObject
@property (nonatomic) int ID;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* subject;
@property (nonatomic) int responds;
@property (nonatomic) long long time;
@property (nonatomic, copy) NSString* itemsUrl;
@property (nonatomic, strong) NSString *parsedTime;
@property (nonatomic, copy) NSString *lastAnswerAuthor;

+(ZumpaItem*) fromJson:(NSDictionary*)dict;
@end
