//
//  ZumpaSubItem.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Survey.h"

@interface ZumpaSubItem : NSObject

@property (nonatomic, copy) NSString* authorReal;
@property (nonatomic, copy) NSString* authorFake;
@property (nonatomic, copy) NSString* body;
@property (nonatomic) long long time;
@property (nonatomic) BOOL hasResponseForYou;
@property (nonatomic) BOOL hasInsideUris;
@property (nonatomic, strong) NSArray* insideUrls;
@property (nonatomic, strong) Survey* survey;
@property (nonatomic, copy) NSString *parsedTime;

+(ZumpaSubItem*) fromJson:(NSDictionary*)dict;

@end
