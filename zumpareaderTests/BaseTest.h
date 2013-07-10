//
//  BaseTest.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/10/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface BaseTest : SenTestCase

@property (strong, nonatomic, readonly) NSString *login;
@property (strong, nonatomic, readonly) NSString *password;
@property (strong, nonatomic, readonly) NSString *zumpaServiceURL;

@end
