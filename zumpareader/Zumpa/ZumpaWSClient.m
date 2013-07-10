//
//  ZumpaWSClient.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaWSClient.h"
#import "ZumpaItem.h"
#import "ZumpaSubItem.h"
#import "NSString+URLEncoding.h"

#define kPost @"POST"
#define kContentLen @"Content-length"
#define kContentType @"Content-Type"
#define kContentTypeValue @"application/x-www-form-urlencoded"

#define kContext @"Context"
#define kItems @"Items"
#define kPrevPage @"PreviousPage"
#define kNextPage @"NextPage"

#define IS_LOGGED_IN @"IS_LOGGED_IN"
#define COOKIES @"COOKIES"
#define USERNAME @"USERNAME"


const double kDefaultTimeout = 2.0;


@interface ZumpaWSClient()
@property (nonatomic, copy) NSString *cookie;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString *serviceUrl;
@end


@implementation ZumpaWSClient

@synthesize cookie = _cookie;
@synthesize isLoggedIn = _isLoggedIn;
@synthesize defaults = _defaults;
@synthesize serviceUrl = _serviceUrl;


-(id) init{
    self = [super init];
    if(self){
        self.defaults = [[NSUserDefaults alloc]init];
        self.isLoggedIn = [self.defaults boolForKey:IS_LOGGED_IN];
        if(self.isLoggedIn){
            self.cookie = [self.defaults stringForKey:COOKIES];
        }
        
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* plistPath = [bundle pathForResource:@"PrivateSettings" ofType:@"plist"];
            
        NSDictionary* props = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.serviceUrl = [props objectForKey:@"ZumpaWebServiceURL"];
        
    }
    return self;
}

-(NSString*) encode:(NSArray*) params{
    NSMutableString *result = [[NSMutableString alloc]init];

    int len = [params count] - ([params count] % 2);
    for (int i = 0; i<len ;i++)
    {
        NSString *arg = [params objectAtIndex:i];
        if(i % 2 == 0){
            if([[params objectAtIndex:i+1] length] > 0){//ignore if value is nil
                [result appendString:arg];
                [result appendString:@"="];
            }else{
                i++;
            }
        }else{
            [result appendString:[arg urlEncode]];
            [result appendString:@"&"];
        }
    }
    
    NSString *toReturn = result;
    if([result length] > 0){
        toReturn = [result substringToIndex:[result length] - 1];
    }
    return toReturn;
}

-(NSMutableURLRequest*)createPostRequest:(NSString*)url andParams:(NSArray*)params{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:kPost];

    NSMutableArray *nsa = [NSMutableArray arrayWithArray:params];
    [nsa addObject:@"UserName"];
    [nsa addObject:@""];//[self.defaults stringForKey:USERNAME]];
    

    if(self.cookie){
        [nsa addObject:@"Cookies"];
        [nsa addObject:self.cookie];
    }
    
    params = nsa;
    
    if(params){
        NSString *postString = [self encode:params];
        [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:kContentLen];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}

-(NSData*) sendRequest:(NSURLRequest*) request{
    NSURLResponse* response;
    NSError* error = nil;
    
    return [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
}


-(BOOL) logIn:(NSString*)uid with:(NSString*)password{
    NSData* jsonData = [self sendRequest:[self createPostRequest:[self.serviceUrl stringByAppendingString:@"login"]
                                                       andParams:[NSArray arrayWithObjects:@"UserName",
                                                                  uid,
                                                                  @"Password",
                                                                  password, nil]]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSString *context = [jsonDict objectForKey:kContext];
    
#ifdef DEBUG
    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
#endif
    self.cookie = context;
    
    BOOL isLoggedIn = [context rangeOfString:@"PHPSESSID="].location != NSNotFound;
    [self.defaults setBool:isLoggedIn forKey:IS_LOGGED_IN];
    if(isLoggedIn){
        [self.defaults setObject:uid forKey:USERNAME];
        [self.defaults setObject:self.cookie forKey:COOKIES];
    }
    [self.defaults synchronize];
    return isLoggedIn;
}

-(BOOL) logOut{
    NSData* jsonData = [self sendRequest:[self createPostRequest:[self.serviceUrl stringByAppendingString:@"logout"]
                                                       andParams:[NSArray arrayWithObjects:nil]]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSString *context = [jsonDict objectForKey:kContext];
    
#ifdef DEBUG
    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
#endif

    return [context boolValue];
}

-(ZumpaMainPageResult*) getItems{
    return [self getItems:nil];
}

-(ZumpaMainPageResult*) getItems:(NSString*) withUrl{
    NSData* jsonData = [self sendRequest:[self createPostRequest:[self.serviceUrl stringByAppendingString:@"zumpa"]
                                                       andParams:[NSArray arrayWithObjects:
                                                                  @"Page",
                                                                  (withUrl) ? withUrl : @"", nil]]];
#ifdef DEBUG
    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
#endif
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *context = [jsonDict objectForKey:kContext];
    NSArray* jsonitems = [context objectForKey:kItems];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in jsonitems) {
        ZumpaItem *zi = [ZumpaItem fromJson:item];
        [items addObject:zi];
    }
    
    ZumpaMainPageResult *result = [[ZumpaMainPageResult alloc]init];
    result.items = items;
    result.previousPage = [context objectForKey:kPrevPage];
    result.nextPage = [context objectForKey:kNextPage];
    
    return result;
}

-(NSArray*) getSubItemsWithUrl:(NSString*)url{
    NSData* jsonData = [self sendRequest:[self createPostRequest:[self.serviceUrl stringByAppendingString:@"thread"]
                                                       andParams:[NSArray arrayWithObjects:@"ItemsUrl",
                                                                  url, nil]]];
#ifdef DEBUG
    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
#endif
 
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSArray* jsonitems = [jsonDict objectForKey:kContext];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in jsonitems) {
        ZumpaSubItem *zi = [ZumpaSubItem fromJson:item];
        [items addObject:zi];
    }
    
    return items;    
}

-(BOOL) post:(int)threadId withSubject:(NSString*) subject andMessage:(NSString*)message{
    
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"Subject", subject,
                       @"Message", message,
                       nil];
    
    if(threadId > 0){
        [params addObject:@"ThreadID"];
        [params addObject:[NSString stringWithFormat:@"%i",threadId]];
    }
    
    NSData* jsonData = [self sendRequest:[self createPostRequest:[self.serviceUrl stringByAppendingString:@"post"]
                                                       andParams:params]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSString *result = [jsonDict objectForKey:kContext];
    
#ifdef DEBUG
    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
#endif
    return [result boolValue];
}

-(BOOL) postThread:(NSString*)subject andMessage:(NSString*)message{
    return [self post:0 withSubject:subject andMessage:message];
}

-(BOOL) replyToThread:(int)threadId withSubject:(NSString*) subject andMessage:(NSString*)message{
    return [self post:threadId withSubject:subject andMessage:message];
}

@end
