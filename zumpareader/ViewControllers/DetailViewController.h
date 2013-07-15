//
//  DetailViewController.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZumpaAsyncWrapper.h"
#import "ZumpaItem.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZumpaAsyncWrapper *zumpa;
@property (nonatomic, weak) ZumpaItem *item;

@end
