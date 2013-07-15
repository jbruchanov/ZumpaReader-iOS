//
//  zumpareaderTests.m
//  zumpareaderTests
//
//  Created by Joe Scurab on 7/10/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "zumpareaderTests.h"

@implementation zumpareaderTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testFormatDate{
    long long q = 1373585070000;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:q];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *result = [formatter stringFromDate:date];
    NSLog(@"%@", result);
}

@end
