//
// Created by Joe Scurab on 27/04/14.
// Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"


@interface ZumpaHelper : NSObject

+(DetailViewController *) controllerForZumpaSubItemById:(int) threadId;

+(DetailViewController *) controllerForZumpaSubItemByLink:(NSString*) link;

@end