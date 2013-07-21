//
//  UIColor+Parser.h
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Parser)

+(UIColor*) colorWithHexString:(NSString*)hexValue;

@end
