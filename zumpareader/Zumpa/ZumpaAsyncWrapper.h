//
//  ZumpaAsyncWrapper.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZumpaWSClient.h"

@interface ZumpaAsyncWrapper : NSObject

-(id) initWithWebService:(ZumpaWSClient*) webServiceClient;

-(void) logIn:(NSString*)uid andPassword:(NSString*)password withCallback:(void (^)(BOOL))callback;
-(void) logOutWithCallback:(void (^)(BOOL))callback;

-(void) getItemsWithCallback:(void (^)(ZumpaMainPageResult*))callback;
-(void) getItemsWithUrl:(NSString*) withUrl andCallback:(void (^)(ZumpaMainPageResult*))callback;

-(void) getSubItemsWithUrl:(NSString*)url andCallback:(void (^)(NSArray*))callback;

-(void) postThread:(NSString*)subject andMessage:(NSString*)message withCallback:(void (^)(BOOL))callback;

-(void) replyToThread:(int)threadId withSubject:(NSString*) subject andMessage:(NSString*)message withCallback:(void (^)(BOOL))callback;

-(void) sendImageToQ3:(NSData*)jpeg withCallback:(void (^) (NSString*))callback;

@end
