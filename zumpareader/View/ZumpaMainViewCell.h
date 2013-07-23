//
//  ZumpaMainViewCell.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/7/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZumpaItem.h"

@interface ZumpaMainViewCell : UITableViewCell
@property (nonatomic) ZumpaItem* item;

@property (nonatomic, copy) NSString* currentUserName;

-(int)measure;

@end
