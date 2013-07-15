//
//  ZumpaMainPageResult.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZumpaMainPageResult : NSObject
@property (nonatomic, copy) NSString *previousPage;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic) NSArray *items;
@end
