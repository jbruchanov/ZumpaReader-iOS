//
//  LoginResult.m
//  zumpareader
//
//  Created by Joe Scurab on 18/11/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult

+(LoginResult*) parse:(NSDictionary*)dict{
    LoginResult *result = [[LoginResult alloc]init];
    result.Result = [[dict valueForKey:@"Result"] boolValue];
    result.UID = [dict valueForKey:@"UID"];
    result.Cookies = [dict valueForKey:@"Cookies"];
    result.ZumpaResult = [dict valueForKey:@"ZumpaResult"];
    return result;
}

@end
