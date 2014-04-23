//
// Created by Joe Scurab on 23/04/14.
// Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PostResult : NSObject

@property (nonatomic) BOOL HasError;
@property (nonatomic, strong) NSString *ErrorMessage;


+(PostResult *)fromJson:(NSDictionary*)dict;

@end