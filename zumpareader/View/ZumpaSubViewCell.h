//
//  ZumpaSubViewCell.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZumpaSubItem.h"

@interface ZumpaSubViewCell : UITableViewCell

@property (nonatomic, readonly) int height;
-(void)setItem:(ZumpaSubItem*)item;

@end
