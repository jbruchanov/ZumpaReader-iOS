//
//  UIColor+Parser.m
//  zumpareader
//
//  Created by Joe Scurab on 7/21/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "UIColor+Parser.h"

@implementation UIColor (Parser)

+(UIColor*) colorWithHexString:(NSString*)hexValue{
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];
    unsigned int hex;
    
    NSRange range = [hexValue rangeOfString:@"#"];
    if(range.location == NSNotFound){
        if (![scanner scanHexInt:&hex]) {
          return nil;
        }
    }else if(range.location == 0){
        [scanner setScanLocation:1];
        if (![scanner scanHexInt:&hex]) {
            return nil;
        }
    }else{
        return nil;
    }
    
    int a = (hex >> 24) & 0xFF;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:a /255.0];
}
@end
