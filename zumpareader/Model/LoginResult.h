//
//  LoginResult.h
//  zumpareader
//
//  Created by Joe Scurab on 18/11/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResult : NSObject

@property (nonatomic, copy) NSString* UID;
@property (nonatomic) BOOL Result;
@property (nonatomic, copy) NSString* ZumpaResult;
@property (nonatomic, copy) NSString* Cookies;

+(LoginResult*) parse:(NSDictionary*)dict;
@end
