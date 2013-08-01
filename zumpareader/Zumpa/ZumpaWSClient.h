//
//  ZumpaWSClient.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/2/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZumpaMainPageResult.h"
#import "Survey.h"

@protocol ZumpaWSClientDelegate

-(void) hasErrorDuringSending:(NSError*)error;

@end


@interface ZumpaWSClient : NSObject

@property (nonatomic, weak) id<ZumpaWSClientDelegate> delegate;

-(void) reloadSettings;

-(ZumpaMainPageResult*) getItems;
-(ZumpaMainPageResult*) getItems:(NSString*) withUrl;


-(BOOL) logIn:(NSString*)uid with:(NSString*)password;
-(BOOL) logOut;

-(NSArray*) getSubItemsWithUrl:(NSString*)url;

/*

-(void) postThread:(NSString*)subject andMessage:(NSString*)msg withSurvey:(id)survey;

 */

-(BOOL) postThread:(NSString*)subject andMessage:(NSString*)message;

-(BOOL) replyToThread:(int)threadId withSubject:(NSString*) subject andMessage:(NSString*)message;

-(NSString*) sendImageToQ3:(NSData*)jpeg;

-(Survey*) voteSurvey:(int)surveyId forItem:(int)surveyButtonIndex;

-(BOOL) switchFavoriteThread:(int)threadId;

@end
