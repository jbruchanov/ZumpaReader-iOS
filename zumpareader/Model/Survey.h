//
//  Survey.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject

@property (nonatomic, copy) NSString *question;
@property (nonatomic) int responds;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSArray *percents;
@property (nonatomic) int votedItem;

+(Survey*) fromJson:(NSDictionary*)jsonDict;
@end
