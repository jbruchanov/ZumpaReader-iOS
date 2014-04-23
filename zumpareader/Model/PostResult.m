//
// Created by Joe Scurab on 23/04/14.
// Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "PostResult.h"


@implementation PostResult {

}

+ (PostResult *)fromJson:(NSDictionary *)dict {
    PostResult *result = [[PostResult alloc] init];
    result.HasError = [[dict valueForKey:@"HasError"] boolValue];
    result.ErrorMessage = [dict valueForKey:@"Error"];
    return result;
}

@end