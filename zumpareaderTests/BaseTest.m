//
//  BaseTest.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/10/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "BaseTest.h"

@interface BaseTest()

@property (strong, nonatomic, readwrite) NSString *login;
@property (strong, nonatomic, readwrite) NSString *password;
@property (strong, nonatomic, readwrite) NSString *zumpaServiceURL;

-(void) initProperties;

@end

@implementation BaseTest

@synthesize login, password, zumpaServiceURL;

- (void)setUp
{
    [super setUp];
    [self initProperties];
}

-(void) initProperties{
    NSBundle* bundle = [NSBundle mainBundle];
	NSString* plistPath = [bundle pathForResource:@"PrivateSettings" ofType:@"plist"];
    
	NSDictionary* props = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.login = [props objectForKey:@"Login"];
    self.password = [props objectForKey:@"Password"];
    self.zumpaServiceURL = [props objectForKey:@"ZumpaWebServiceURL"];
}

@end
