//
//  ZumpaAsyncWrapper.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaAsyncWrapper.h"


@interface ZumpaAsyncWrapper()
@property (nonatomic, strong) ZumpaWSClient *client;
@end

@implementation ZumpaAsyncWrapper

-(id) initWithWebService:(ZumpaWSClient*) webServiceClient{
    self = [super init];
    if(self){
        self.client = webServiceClient;
    }
    return self;
}

/*-(BOOL) logIn:(NSString*)uid with:(NSString*)password;*/
-(void) logIn:(NSString*)uid andPassword:(NSString*)password withCallback:(void (^)(LoginResult*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LoginResult *result = [self.client logIn:uid with:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) logOutWithCallback:(void (^)(BOOL))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self.client logOut];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) getItemsWithCallback:(void (^)(ZumpaMainPageResult*))callback{
    [self getItemsWithUrl:nil andCallback:callback];
}

-(void) getItemsWithUrl:(NSString*) withUrl andCallback:(void (^)(ZumpaMainPageResult*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZumpaMainPageResult *result = [self.client getItems:withUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) getSubItemsWithUrl:(NSString*)url andCallback:(void (^)(NSArray*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *result = [self.client getSubItemsWithUrl:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) postThread:(NSString*)subject andMessage:(NSString*)message withCallback:(void (^)(PostResult*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PostResult *result = [self.client postThread:subject andMessage:message];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) replyToThread:(int)threadId withSubject:(NSString*) subject andMessage:(NSString*)message withCallback:(void (^)(PostResult*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PostResult *result = [self.client replyToThread:threadId withSubject:subject andMessage:message];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) sendImageToQ3:(NSData*)jpeg withCallback:(void (^) (NSString*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *result = [self.client sendImageToQ3:jpeg];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) voteSurvey:(int)surveyId forItem:(int)surveyButtonIndex withCallback:(void (^) (Survey*))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Survey *result = [self.client voteSurvey:surveyId forItem:surveyButtonIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) switchFavoriteThread:(int)threadId withCallback:(void (^)(BOOL))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self.client switchFavoriteThread:threadId];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

-(void) register:(BOOL) reg pushToken:(NSString *)token forUser:(NSString *)userName withUID:(NSString *)uid withCallback:(void (^)(BOOL))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self.client register:reg pushToken:token forUser:userName withUID:uid];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(result);
            });
        }
    });
}
@end
