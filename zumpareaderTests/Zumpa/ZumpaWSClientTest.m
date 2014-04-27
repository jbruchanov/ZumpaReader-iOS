//
//  ZumpaWSClientTest.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaWSClientTest.h"
#import "ZumpaWSClient.h"
#import "ZumpaItem.h"
#import "ZumpaSubItem.h"
#import "NSString+URLEncoding.h"

@implementation ZumpaWSClientTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testUrlEscape{
    NSString *url = @"http://portal2.dkm.cz/phorum/list.php?f=2&t=1155343&a=1";
    NSString *q = [url urlEncode];
    XCTAssertFalse([url isEqualToString:q], @"Should't be same");
}

-(void) testDownloadDataMain{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    ZumpaMainPageResult *result = [client getItems];
    NSArray *list = result.items;
    XCTAssertNil(result.previousPage, @"PreivousPage should be nil");
    XCTAssertNotNil(result.nextPage, @"NextPage should not be nil");
    XCTAssertNotNil(list, @"List should not be nil");
    XCTAssertEqual((int)35, (int)[list count], @"List should have size 35 items");
}

-(void) testDownloadDataPage{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    ZumpaMainPageResult *result = [client getItems:@"http://portal2.dkm.cz/phorum/list.php?f=2&t=1155343&a=1"];
    NSArray *list = result.items;
    XCTAssertNotNil(result.previousPage, @"PreivousPage should not be nil");
    XCTAssertNotNil(result.nextPage, @"NextPage should not be nil");
    XCTAssertNotNil(list, @"List should not be nil");
    XCTAssertEqual((int)35, (int)[list count], @"List should have size 35 items");
}

-(void) testParse{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    ZumpaMainPageResult *result = [client getItems];
    NSArray *list = result.items;
    for (id item in list) {
        ZumpaItem *zi = (ZumpaItem*)item;
        XCTAssertNotNil(zi, @"Invalid object");
        XCTAssertNotNil(zi.author, @"author test");
        XCTAssertNotNil(zi.subject, @"subject test");
        XCTAssertNotNil(zi.itemsUrl, @"itemsUrl test");
    }
}

-(void) testLogin{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    LoginResult *login = [client logIn:self.login with:self.password];
    XCTAssertEqual(YES, login.Result, @"Should be loggeding");
}

-(void) testLogout{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    [client logIn:self.login with:self.password];
    BOOL logout = [client logOut];
    XCTAssertEqual(YES, logout, @"Should be loggeding");
}

-(void) testSubItems{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    NSArray *subItems = [client getSubItemsWithUrl:@"http://portal2.dkm.cz/phorum/read.php?f=2&i=1155593&t=1155593"];
    
    XCTAssertNotNil(subItems, @"Items should not be nil!");
    
    ZumpaSubItem *zsi = [subItems objectAtIndex:0];
    XCTAssertNotNil(zsi.survey, @"Survey should not be nil");
    
    /* 
     @property (nonatomic, copy) NSString *question;
     @property (nonatomic) int responsesSum;
     @property (nonatomic, copy) NSString *ID;
     @property (nonatomic, assign) NSArray *answers;
     @property (nonatomic, assign) NSArray *percents;
     @property (nonatomic) int votedItem;
     */
    XCTAssertNotNil(zsi.survey.question, @"Survey question Nil");
    XCTAssertTrue(zsi.survey.responsesSum > 0, @"Survey responsesSum 0");
    XCTAssertTrue(zsi.survey.ID > 0, @"Survey ID Nil");
    XCTAssertNotNil(zsi.survey.answers, @"Survey answers Nil");
    XCTAssertNotNil(zsi.survey.percents, @"Survey percents Nil");
    
    /*
     @property (nonatomic, copy) NSString* authorReal;
     @property (nonatomic, copy) NSString* authorFake;
     @property (nonatomic, copy) NSString* body;
     @property (nonatomic) long time;
     @property (nonatomic) BOOL hasResponseForYou;
     @property (nonatomic) BOOL hasInsideUris;
     @property (nonatomic, assign) NSArray* insideUrls;
     @property (nonatomic, assign) Survey* survey;
     */
    
    BOOL hasInsideUris = NO;
    for (ZumpaSubItem *zsi in subItems) {
        XCTAssertNotNil(zsi, @"Nil subitem");
        XCTAssertNotNil(zsi.authorReal, @"Nil subitem authorReal");
        XCTAssertNotNil(zsi.body, @"Nil subitem body");
        XCTAssertTrue(zsi.time != 0, @"Time is 0");
        hasInsideUris |= zsi.hasInsideUris;
    }
    
    XCTAssertTrue(hasInsideUris, @"No inside uris at all!");
}

-(void) testReplyToThread{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    [client logIn:self.login with:self.password];
    //[client replyToThread:1152897 withSubject:@"iOS subject" andMessage:@"iOS 1234 test"];
}

-(void) testFailedLogin{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    XCTAssertFalse([client logIn:self.login with:@"blabla"], @"Should be NO for invalid login credentials!");
    //[client replyToThread:1152897 withSubject:@"iOS subject" andMessage:@"iOS 1234 test"];
}

-(void) privatestPostQ3{
    //it works, disabled for not doing mess around
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"appicon@2" ofType:@"png"]; 
    if(filePath){
        NSData *img = [NSData dataWithContentsOfFile:filePath];
        ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
        NSString *serverURL = [client sendImageToQ3:img];
        XCTAssertNotNil(serverURL, @"There should be some image url");
        NSLog(@"%@", serverURL);
    }
}

-(void)testVoteSurvey{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    [client logIn:self.login with:self.password];
    Survey *s = [client voteSurvey:3879 forItem:4];
    XCTAssertNotNil(s, @"Survey should be ni;!");
    XCTAssertEqual(3879, s.ID, @"Different survey ID");
}

-(void)testSwitchFavoriteThread{
    ZumpaWSClient *client = [[ZumpaWSClient alloc] init];
    [client logIn:self.login with:self.password];
    BOOL switched = [client switchFavoriteThread:1175788    ];
    XCTAssertEqual(YES, switched, @"Different survey ID");
}

@end