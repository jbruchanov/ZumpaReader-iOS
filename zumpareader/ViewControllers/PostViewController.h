//
//  PostViewController.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/9/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZumpaAsyncWrapper.h"
#import "ZumpaItem.h"

@protocol PostViewControllerDelegate <NSObject>

-(void) userDidSendMessage;


@end

@interface PostViewController : UIViewController

@property (weak, nonatomic) ZumpaItem *item;
@property (weak, nonatomic) ZumpaAsyncWrapper *zumpa;
@property (weak, nonatomic) id<PostViewControllerDelegate> delegate;
@property (weak, nonatomic) NSUserDefaults *settings;
@property (strong, nonatomic) NSString *prefilledMessage;

@end
