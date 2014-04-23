//
//  ZRSubViewCell.h
//  zumpareader
//
//  Created by Joe Scurab on 23/04/14.
//  Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISurvey.h"
#import "ZumpaSubItem.h"

@interface ZRSubViewCell : UITableViewCell

@property (strong, nonatomic) UISurvey *survey;

@property (strong, nonatomic) id<UISurveyDelegate> surveyDelegate;

@property (strong, nonatomic) ZumpaSubItem* item;

+(ZRSubViewCell *) create;

@end
