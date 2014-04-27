//
//  UIColor+Parser.h
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FAVORITE 0xFFFF6600
#define OWN 0xFF336699
#define MSG_4U 0xFFFF0000

@interface UIColor (Parser)

+(UIColor*) colorWithHexString:(NSString*)hexValue;
+(UIColor*) colorWithInt:(int)value;

@end
