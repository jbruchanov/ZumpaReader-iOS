//
//  main.m
//  zumpareader
//
//  Created by Joe Scurab on 7/10/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            NSLog(@"%@",[NSThread callStackSymbols]);
        }
        @finally {
        
        }
        
    }
}
