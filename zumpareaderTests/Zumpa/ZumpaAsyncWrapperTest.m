//
//  ZumpaAsyncWrapperTest.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/7/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaAsyncWrapperTest.h"
#import "ZumpaWSClient.h"
#import "ZumpaAsyncWrapper.h"

#define TIMEOUT 5000000

@interface ZumpaAsyncWrapper()
-(void) activeWait:(BOOL*) stop;
@end

@implementation ZumpaAsyncWrapperTest

-(void) testLogin{
    ZumpaAsyncWrapper *zaw = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    
    __block BOOL finalResult = NO;
    
    
    [zaw logIn:self.login andPassword:self.password withCallback:^(BOOL result) {
        finalResult = YES;
    }];
    
    [self activeWait:&finalResult];
    XCTAssertEqual(YES, finalResult, @"Should be finished!");
}

-(void) testLogout{
    ZumpaAsyncWrapper *zaw = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    
    __block BOOL finalResult = NO;
    
    
    [zaw logOutWithCallback:^(BOOL result) {
        finalResult = YES;
    }];
    
    [self activeWait:&finalResult];
    XCTAssertEqual(YES, finalResult, @"Should be finished!");
}

-(void) testGetItemsWithCallback{
    ZumpaAsyncWrapper *zaw = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    
    __block BOOL finalResult = NO;
    
    
    [zaw getItemsWithCallback:^(ZumpaMainPageResult *pageResult) {
        finalResult = YES;
        XCTAssertNil(pageResult, @"PageResult");
    }];
    
    [self activeWait:&finalResult];
    XCTAssertEqual(YES, finalResult, @"Should be finished!");
}

-(void) testGetItemsUrlWithCallback{
    ZumpaAsyncWrapper *zaw = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    
    __block BOOL finalResult = NO;
    
    
    [zaw getItemsWithUrl:nil andCallback:^(ZumpaMainPageResult *pageResult) {
        finalResult = YES;
        XCTAssertNil(pageResult, @"PageResult");
    }];
    
    [self activeWait:&finalResult];
    XCTAssertEqual(YES, finalResult, @"Should be finished!");
}

-(void) testGetSubItemsWithUrl{
    ZumpaAsyncWrapper *zaw = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    
    __block BOOL finalResult = NO;
    
    
    [zaw getSubItemsWithUrl:@"http://portal2.dkm.cz/phorum/read.php?f=2&i=1155762&t=1155762" andCallback:^(NSArray *array) {
        finalResult = YES;
        XCTAssertNil(array, @"NSArray NIL");
    }];
    
    [self activeWait:&finalResult];
    XCTAssertEqual(YES, finalResult, @"Should be finished!");
}

-(void) activeWait:(BOOL*) stop{
    for(int i = 0;i<5 && *stop == NO;i++){//while(*stop == NO){
        [NSThread sleepForTimeInterval:.5];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

@end
