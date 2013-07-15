//
//  SettingsViewController.h
//  zumpareader
//
//  Created by Joe Scurab on 7/11/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZumpaAsyncWrapper.h"

@protocol SettingsViewControllerDelegate <NSObject>
-(void) settingsWillClose:(id)source;
@end

@interface SettingsViewController : UIViewController


@property (nonatomic, weak) ZumpaAsyncWrapper *zumpa;
@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end


